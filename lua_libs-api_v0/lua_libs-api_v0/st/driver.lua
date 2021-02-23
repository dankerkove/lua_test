local capabilities = require "st.capabilities"
local json = require "dkjson"
local base64 = require "st.base64"
local utils = require "st.utils"
local net_utils = require "st.net_utils"
local datastore = require "datastore"
local devices = _envlibrequire("devices")
local device_lib = require "st.device"
local thread = require "st.thread"
local zigbee_device = require "st.zigbee.device"
local zwave_device = require "st.zwave.device"
local cosock = require "cosock"
local log = require "log"
local socket = cosock.socket
local timer = cosock.timer
local CapabilityCommandDispatcher = require "st.capabilities.dispatcher"
local DeviceLifecycleDispatcher = require "st.device_lifecycle_dispatcher"

local CONTROL_THREAD_NAME = "control"

--- @module driver_templates
local driver_templates = {}

--- @class message_channel
local message_channel = {}


--- @class SubDriver
---
--- A SubDriver is a way to bundle groups of functionality that overrides the basic behavior of a given driver by gating
--- it behind a can_handle function.
---
--- @field public can_handle fun(type: Driver, type: Device, ...):boolean whether or not this sub driver, if it has a matching handler, should handle a message
--- @field public zigbee_handlers table the same zigbee handlers that a driver would have
--- @field public zwave_handlers table the same zwave handlers that a driver would have
--- @field public capability_handlers table the same capability handlers that a driver would have
local sub_driver = {}


--- @class Driver
---
--- This is a template class to define the various parts of a driver table.  The Driver object represents all of the
--- state necessary for running and supporting the operation of this class of devices.  This can be as specific as a
--- single model of device, or if there is much shared functionality can manage several different models and
--- manufacturers.
---
--- Drivers go through initial set up on hub boot, or initial install, but after that the Drivers are considered
--- long running.  That is, they will behave as if they run forever.  As a result, they should have a main run loop
--- that continues to check for work/things to process and handles it when available.  For MOST uses the provided
--- run function should work, and there should be no reason to overwrite the existing run loop.
---
--- @field public NAME string a name used for debug and error output
--- @field public capability_channel message_channel the communication channel for capability commands/events
--- @field public lifecycle_channel message_channel the communication channel for device lifecycle events
--- @field public timer_api timer_api utils related to timer functionality
--- @field public device_api device_api utils related to device functionality
--- @field public environment_channel message_channel the communication channel for environment info updates
--- @field public timers table this will contain a list of in progress timers running for the driver
--- @field public capability_dispatcher CapabilityCommandDispatcher dispatcher for routing capability commands
--- @field public lifecycle_dispatcher DeviceLifecycleDispatcher dispatcher for routing lifecycle events
--- @field public sub_drivers SubDriver[] A list of sub_drivers that contain more specific behavior behind a can_handle function
local Driver = {}
Driver.__index = Driver

driver_templates.Driver = Driver

--- @function Driver:get_device_info
---
--- Get the device table containing information about a device running on this driver.  This is routed through the
--- driver to allow the driver to set up any driver specific information or make any calculations necessary.
--- @param device_uuid string the UUID of the device to query
--- @return Device the device associated with the UUID
function Driver:get_device_info(device_uuid)
  error("Unimplemented error")
end

--------------------------------------------------------------------------------------------
-- Timer related functions
--------------------------------------------------------------------------------------------

--- A template of a callback for a timer
---
--- @param driver Driver the driver the callback was associated with
function driver_templates.timer_callback_template(driver)
end

--- Set up a one shot timer to hit the callback after delay_s seconds
---
--- @param self Driver the driver setting up the timer
--- @param delay_s number the number of seconds to wait before hitting the callback
--- @param callback function the function to call when the timer expires. @see Driver.timer_callback_template
--- @param name string an optional name for the timer
--- @return timer the created timer
function Driver:call_with_delay(delay_s, callback, name)
  local created_timer = self.timer_api.create_oneshot(delay_s)
  if created_timer then
    local handler = function()
      created_timer:handled()
      self:unregister_channel_handler(created_timer)
      callback(self)
    end

    self:register_channel_handler(created_timer, handler, name or "unnamed oneshot")
    return created_timer
  else
    log.error("Timer API failed to create timer")
    return nil
  end
end

--- Set up a periodic timer to hit the callback every interval_s seconds
---
--- @param self Driver the driver setting up the timer
--- @param interval_s number the number of seconds to wait between hitting the callback
--- @param callback function the function to call when the timer expires. @see Driver.timer_callback_template
--- @param name string an optional name for the timer
--- @return timer the created timer
function Driver:call_on_schedule(interval_s, callback, name)
  if interval_s > 0 then
    local created_timer = self.timer_api.create_interval(interval_s)
    if created_timer then
      local handler = function()
        created_timer:handled()
        callback(self)
      end

      self:register_channel_handler(created_timer, handler, name or "unnamed interval")
      return created_timer
    else
      log.error("Timer API failed to create timer")
      return nil
    end
  else
    error("Call on schedule requires an interval greater than zero")
    return nil
  end
end

--- Cancel a timer set up on this driver
---
--- @param self Driver the driver with the timer
--- @param t Timer the timer to cancel
function Driver:cancel_timer(t)
  t:cancel()
  self:unregister_channel_handler(t)
end

--------------------------------------------------------------------------------------------
-- Default capability command handling
--------------------------------------------------------------------------------------------

--- Default handler that can be registered for the capability message channel
---
--- @param self Driver the driver to handle the capability commands
--- @param capability_channel message_channel the capability message channel with data to be read
function Driver:capability_message_handler(capability_channel)
  local device_uuid, cap_data = capability_channel:receive()
  local cap_table = json.decode(cap_data)
  local device = self:get_device_info(device_uuid)
  if device ~= nil and cap_table ~= nil then
    device.thread:queue_event(self.handle_capability_command, self, device, cap_table)
  end
end

--- Default capability command handler.  This takes the parsed command and will look up the command handler and call it
---
--- @param self Driver the driver to handle the capability commands
--- @param device Device the device that this command was sent to
--- @param cap_command table the capability command table including the capability, command, component and args
function Driver:handle_capability_command(device, cap_command)
  local capability = cap_command.capability
  local command = cap_command.command
  if not capabilities[capability].commands[command]:validate_and_normalize_command(cap_command) then
    error(
      string.format("Invalid capability command: %s.%s (%s)", capability, command, utils.stringify_table(command.args))
    )
  else
    if device:supports_capability_by_id(capability) then
      self.capability_dispatcher:dispatch(self, device, cap_command)
    else
      log.warn(string.format("Received command for device %s for unsupported capability %s", device, capability))
    end
  end
end

--------------------------------------------------------------------------------------------
-- Default message channel handling
--------------------------------------------------------------------------------------------

--- Default handler that can be registered for the device lifecycle events
---
--- @param self Driver the driver to handle the device lifecycle events
--- @param lifecycle_channel message_channel the lifecycle message channel with data to be read
function Driver:lifecycle_message_handler(lifecycle_channel)
  local device_uuid, event = lifecycle_channel:receive()

  -- temporary workaround to prevent double initing until "added" message behavior is changed
  local device_already_existed = self.device_cache and self.device_cache[device_uuid]

  local device = self:get_device_info(device_uuid)
  local args = {}
  if event == "infoChanged" then
    local old_device_st_store = self:get_device_info(device_uuid).st_store
    args["old_st_store"] = old_device_st_store
    device = self:get_device_info(device_uuid, true)
  end

  device.thread:queue_event(self.lifecycle_dispatcher.dispatch, self.lifecycle_dispatcher, self, device, event, args)

  -- Do event cleanup that needs to happen regardless
  if event == "added" then
    if not device_already_existed then
      device.thread:queue_event(self.lifecycle_dispatcher.dispatch, self.lifecycle_dispatcher, self, device, "init")
    end
  elseif event == "removed" then
    if self.device_cache ~= nil then
      self.device_cache[device_uuid] = nil
    end
    device.thread:queue_event(device.deleted, device)
  end
end

--- Default handler that can be registered for the device discovery events
---
--- @param self Driver the driver to handle the device discovery events
--- @param discovery_channel message_channel the discovery message channel with data to be read
function Driver:discovery_message_handler(discovery_channel)
  local event, opts = discovery_channel:receive()

  if event == "start" then
    if self.discovery ~= nil then
      -- lazily create discovery thread, only needed in some drivers
      if not self.discovery_state.thread then
        self.discovery_state.thread = thread.Thread(self, "discovery")
      end

      if not self.discovery_state.is_running then
	local should_continue = function() return self.discovery_state.is_running or false end

        self.discovery_state.is_running = true
        self.discovery_state.thread:queue_event(self.discovery, self, opts, should_continue)
      end
   end
  elseif event == "stop" then
    self.discovery_state.is_running = nil
    if self.discovery_state.thread then
      self.discovery_state.thread:close()
      self.discovery_state.thread = nil
    end
  end
end

--- Default handler that can be registered for the environment info messages
---
--- @param self Driver the driver to handle the device lifecycle events
--- @param environment_channel message_channel the environment update message channel
function Driver:environment_info_handler(environment_channel)
  local msg_type, msg_val = environment_channel:receive()
  self.environment_info = self.environment_info or {}
  if msg_type == "zigbee" then
    self.environment_info.hub_zigbee_eui = base64.decode(msg_val.hub_zigbee_id)
  elseif msg_type == "lan" then
    local ipv4_string = net_utils.convert_ipv4_decimal_to_string(msg_val.hub_ipv4)
    if ipv4_string ~= nil then
      self.environment_info.hub_ipv4 = ipv4_string
      if self.lan_info_changed_handler ~= nil then
        self:lan_info_changed_handler(self.environment_info.hub_ipv4)
      end
    end
  elseif msg_type == "zwave" then
    log.debug("Z-Wave hub node ID environment changed.")
    self.environment_info.hub_zwave_id = msg_val.hub_node_id
    if self.zwave_hub_node_id_changed_handler ~= nil then
      self:zwave_hub_node_id_changed_handler(self.environment_info.hub_zwave_id)
    end
  end
end

--------------------------------------------------------------------------------------------
-- Default get device info handling
--------------------------------------------------------------------------------------------

---  Default function for getting and caching device info on a driver
---
--- By default this will use the devices api to request information about the device id provided
--- it will then cache that information on the driver.  The information will be stored as a table
--- after being decoded from the JSON sent across.
---
--- @param self Driver the driver running
--- @param device_uuid string the uuid of the device to get info for
--- @param force_refresh boolean if true, re-request from the driver api instead of returning cached value
function Driver:get_device_info(device_uuid, force_refresh)
  if self.device_cache == nil then
    self.device_cache = {}
  end

  -- We don't have any information for this device
  if self.device_cache[device_uuid] == nil then
    local raw_device = json.decode(self.device_api.get_device_info(device_uuid))
    local new_device
    if raw_device.network_type == device_lib.NETWORK_TYPE_ZIGBEE then
      new_device = zigbee_device.ZigbeeDevice(self, raw_device)
    elseif raw_device.network_type == device_lib.NETWORK_TYPE_ZWAVE then
      new_device = zwave_device.ZwaveDevice(self, raw_device)
    else
      new_device = device_lib.Device(self, raw_device)
    end

    -- Optional additional processing provided by the self
    if self.post_device_info_handler ~= nil then
      new_device = self:post_device_info_handler(new_device)
    end

    self.device_cache[new_device.id] = new_device
  elseif force_refresh == true then
    -- We have a device record, but we want to force refresh the data
    local raw_device = json.decode(self.device_api.get_device_info(device_uuid))
    self.device_cache[device_uuid]:load_updated_data(raw_device)
  end
  return self.device_cache[device_uuid]
end

--- @function Driver:try_create_device
--- Send a request to create a new device.
---
--- NOTE: At this time, only LAN type devices can be created via this api.
---
--- Example usage: ``local metadata = {
---                    type = "LAN",
---                    device_network_id = "24FD5B0001044502",
---                    label = "Kitchen Smart Bulb",
---                    profile = "bulb.rgb.v1",
---                    manufacturer = "WiFi Smart Bulb Co.",
---                    model = "WiFi Bulb 9000",
---                    vendor_provided_label = "Kitchen Smart Bulb"
---                  })
---
---                  driver:try_create_device(metadata))``
---
--- All metadata fields are type string. Valid metadata fields are:
---
---     type - network type of the device. Must be "LAN". (required)
---     device_network_id - unique identifier specific for this device (required)
---     label - label for the device (required)
---     profile - profile name defined in the profile .yaml file (required)
---     parent_device_id - device id of a parent device
---     manufacturer - device manufacturer
---     model - model name of the device
---     vendor_provided_label - device label provided by the manufacturer/vendor (typically the same as label during device creation)
---
--- @param device_metadata table A table of device metadata
function Driver:try_create_device(device_metadata)
  assert(type(device_metadata) == "table")

  -- extract only keys we know are valid to prevent sending a bunch of garbage over the rpc
  local normalized_metadata = {
    deviceNetworkId = device_metadata.device_network_id,
    label = device_metadata.label,
    profileReference = device_metadata.profile,
    parentDeviceId = device_metadata.parent_device_id,
    manufacturer = device_metadata.manufacturer,
    model = device_metadata.model,
  }

  -- currently only LAN is allowed. ZIGBEE/ZWAVE disabled.
  local network_type = string.upper(device_metadata.type)
  if network_type == "LAN" then
    normalized_metadata["vendorProvidedLabel"] = device_metadata.vendor_provided_label
  else
    error("unsupported network type: " .. network_type, -1)
  end
  normalized_metadata["type"] = network_type

  local metadata_json = json.encode(normalized_metadata)
  if metadata_json == nil then
    error("error parsing device info", -1)
  end

  return devices.create_device(metadata_json)
end

--------------------------------------------------------------------------------------------
-- Message stream handling registration
--------------------------------------------------------------------------------------------

--- Template function for a message handler
---
--- @param driver Driver the driver to handle the message channel
--- @param message_channel message_channel the channel that has the data to read.  A receive should be called on the channel to get the data
function driver_templates.message_handler_callback(driver, message_channel)
end

--- Function to register a message_channel handler
---
--- @param self Driver the driver to handle message events
--- @param message_channel message_channel the message channel to listen to input on
--- @param callback function the callback function to call when there is data on the message channel
--- @param name string Optional name for the channel handler, used for logging
function Driver:register_channel_handler(message_channel, callback, name)
  self.message_handlers = self.message_handlers or {}
  self.message_handlers[message_channel] = {
    callback = callback,
    name = (name or "unnamed")
  }

  -- We have to wake the control thread as there is a new channel to select on
  if self._resync then
    self._resync:send()
  end
end

--- Function to unregister a message_channel handler
---
--- @param self Driver the driver to handle the message events
--- @param message_channel message_channel the message channel to stop listening for input on
function Driver:unregister_channel_handler(message_channel)
  if self.message_handlers then
    self.message_handlers[message_channel] = nil
  end
end

--------------------------------------------------------------------------------------------
-- Helper function for building drivers
--------------------------------------------------------------------------------------------

--- Standardize the structure of the sub driver structure of this driver
---
--- The handlers registered as a part of the base driver file (or capability defaults) are
--- assumed to be the default behavior of the driver.  However, if there is need for a subset
--- of devices to override the base behavior for one reason or another (e.g. manufacturer or
--- model specific behavior), a value can be added to the "sub_drivers".  Each sub_driver must
--- contain a `can_handle` function of the signature `can_handle(opts, driver, device, ...)`
--- where opts can be used to provide context specific information necessary to determine if
--- the sub_driver should be responsible for some type of work.  The most common use for the
--- sub drivers will be to provide capabiltiy/zigbee/zwave handlers that need to override the
--- default for the driver.  It may optionally also contain its own `sub_drivers` containing
--- further subservient sets.
---
--- @param driver Driver the driver
function Driver.standardize_sub_drivers(driver)
  local handler_sets = {}
  for i, handler_set_list in pairs(driver.sub_drivers or {}) do
    local unwrapped_list = {table.unpack(handler_set_list)}
    if #unwrapped_list ~= 0 then
      for j, list in ipairs(unwrapped_list) do
        -- If there isn't a can_handle, it is a useless handler_set and should be ignored
        if list.can_handle ~= nil then
          table.insert(handler_sets, utils.deep_copy(list))
        end
      end
    else
      if handler_set_list.can_handle ~= nil then
        table.insert(handler_sets, utils.deep_copy(handler_set_list))
      end
    end
  end
  driver.sub_drivers = handler_sets
  for i, s_d in ipairs(driver.sub_drivers) do
    Driver.standardize_sub_drivers(s_d)
  end
end

--- Recursively build the capability dispatcher structure from sub_drivers
---
--- This will recursively follow the `sub_drivers` defined on the driver and build
--- a structure that will correctly find and execute a handler that matches.  It should be
--- noted that a child handler will always be preferred over a handler at the same level,
--- but that if multiple child handlers report that they can handle a message, it will be
--- sent to each handler that reports it can handle the message.
---
--- @param driver Driver the driver
function Driver.populate_capability_dispatcher_from_sub_drivers(driver)
  for _, sub_driver in ipairs(driver.sub_drivers) do
    sub_driver.capability_handlers = sub_driver.capability_handlers or {}
    sub_driver.capability_dispatcher =
      CapabilityCommandDispatcher(sub_driver.NAME, sub_driver.can_handle, sub_driver.capability_handlers)
    driver.capability_dispatcher:register_child_dispatcher(sub_driver.capability_dispatcher)
    Driver.populate_capability_dispatcher_from_sub_drivers(sub_driver)
  end
end

--- Recursively build the lifecycle dispatcher structure from sub_drivers

---
--- @param driver Driver the driver
function Driver.populate_lifecycle_dispatcher_from_sub_drivers(driver)
  for _, sub_driver in ipairs(driver.sub_drivers) do
    sub_driver.lifecycle_handlers = sub_driver.lifecycle_handlers or {}
    sub_driver.lifecycle_dispatcher = DeviceLifecycleDispatcher(
        sub_driver.NAME,
        sub_driver.can_handle,
        sub_driver.lifecycle_handlers
    )
    driver.lifecycle_dispatcher:register_child_dispatcher(sub_driver.lifecycle_dispatcher)
    Driver.populate_lifecycle_dispatcher_from_sub_drivers(sub_driver)
  end
end

local function default_lifecycle_event_handler(driver, device, event)
  log.trace(string.format("%s received %s event but driver has no handler", device, event))
end

---Given a driver template and name initialize the context
---
--- This is used to build the driver context that will be passed around to provide access to various state necessary
--- for operation
---
--- @param cls Driver class to be instantiated
--- @param name string the name of the driver used for logging
--- @param template table a template with any override or necessary driver information
--- @return Driver the constructed driver context
function Driver.init(cls, name, template)
  local out_driver = template or {}
  out_driver.NAME = name
  out_driver.capability_handlers = out_driver.capability_handlers or {}
  out_driver.lifecycle_handlers = out_driver.lifecycle_handlers or {}

  out_driver.capability_channel = socket.capability()
  out_driver.discovery_channel = socket.discovery()
  out_driver.environment_channel = socket.environment_update()
  out_driver.lifecycle_channel = socket.device_lifecycle()
  out_driver.timer_api = timer
  out_driver.device_api = devices
  out_driver.environment_info = {}
  out_driver.device_cache = {}
  out_driver.datastore = datastore.init()
  out_driver.discovery_state = {}
  setmetatable(out_driver, cls)

  out_driver.configure = out_driver.configure or default_configuration_method
  out_driver.refresh = out_driver.refresh or default_refresh_method
  Driver.standardize_sub_drivers(out_driver)

  utils.merge(
      out_driver.lifecycle_handlers,
      {
        doConfigure = default_lifecycle_event_handler,
        infoChanged = default_lifecycle_event_handler,
        added = default_lifecycle_event_handler,
        removed = default_lifecycle_event_handler,
        init = default_lifecycle_event_handler,
      }
  )
  out_driver.lifecycle_dispatcher =
  DeviceLifecycleDispatcher(
      name,
      function(...)
        return true
      end,
      out_driver.lifecycle_handlers
  )
  out_driver.populate_lifecycle_dispatcher_from_sub_drivers(out_driver)

  out_driver.capability_dispatcher =
  CapabilityCommandDispatcher(
      name,
      function(...)
        return true
      end,
      out_driver.capability_handlers
  )
  out_driver.populate_capability_dispatcher_from_sub_drivers(out_driver)
  log.trace(string.format("Setup driver %s with Capability handlers:\n%s", out_driver.NAME, out_driver.capability_dispatcher))

  out_driver:register_channel_handler(
    out_driver.capability_channel,
    template.capability_message_handler or Driver.capability_message_handler,
    "capability"
  )
  out_driver:register_channel_handler(
    out_driver.lifecycle_channel,
    template.lifecycle_message_handler or Driver.lifecycle_message_handler,
    "device_lifecycle"
  )
  out_driver:register_channel_handler(
    out_driver.discovery_channel,
    template.discovery_message_handler or Driver.discovery_message_handler,
    "discovery"
  )
  out_driver:register_channel_handler(
    out_driver.environment_channel,
    template.environment_info_handler or Driver.environment_info_handler,
    "environment_info"
  )

  -- This handler allows us to force the control thread to turn. This is used to re-process the list of message handlers
  -- after one has been added or removed so that it can be added or removed from the list passed to select.
  local resyncsender, resyncreceiver = cosock.channel.new()
  out_driver:register_channel_handler(
    resyncreceiver,
    function(_, resync) resync:receive() end,
    "_resync"
  )
  out_driver._resync = resyncsender

  return out_driver
end

--------------------------------------------------------------------------------------------
-- Default run loop for drivers
--------------------------------------------------------------------------------------------

--- Function to run a driver
---
--- This will run an "infinite" loop for this driver.  It will wait for input on any message channel that has a handler
--- registered for it through the register_channel_handler function.  In addition it will wait for any registered timers
--- to expire and trigger as well.  Whenever data becomes available on one of the message channels the callback will
--- be called and then it will go back to waiting for input.
---
--- @param self Driver the driver to run
function Driver:run()
  -- Do a collectgarbage when a driver is first started as there is a lot of memory bloat as a part of startup
  collectgarbage()

  local function inner_run()
    local existing_devices = self.device_api.get_device_list()
    for _, deviceid in pairs(existing_devices) do
      local device = self:get_device_info(deviceid)
      device.thread:queue_event(self.lifecycle_dispatcher.dispatch, self.lifecycle_dispatcher, self, device, "init")
    end

    while true do
      local sock_list = {}
      for sock, cb in pairs(self.message_handlers or {}) do
        sock_list[#sock_list + 1] = sock
      end
      if #sock_list == 0 then
        sleep(5)
      else
        local read_socks, _, err = socket.select(sock_list, nil, nil)
        for i, sock in ipairs(read_socks) do
          local handler = self.message_handlers[sock]
          if handler then
            log.trace(string.format("Received event with handler %s", handler.name))
            assert(type(handler.callback) == "function", "not a function")
            local status, err = pcall(handler.callback, self, sock)
            if not status then
              log.warn(string.format("%s encountered error: %s", self.NAME, tostring(err)))
            end
          end
        end
      end
      if self.datastore ~= nil then
        if self.datastore:is_dirty() then
          self.datastore:save()
        end
      end
    end
  end

  socket = cosock.socket
  cosock.spawn(inner_run, CONTROL_THREAD_NAME)

  cosock.run()
end

setmetatable(Driver, {
  __call = Driver.init
})

return Driver
