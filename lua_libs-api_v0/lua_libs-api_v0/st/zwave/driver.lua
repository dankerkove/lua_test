local log = require "log"
--- @type Driver
local Driver = require "st.driver"
local socket = require "cosock.socket"
--- @type st.zwave.Dispatcher
local ZwaveDispatcher = require "st.zwave.dispatcher"
--- @type st.zwave
local zw = require "st.zwave"
local utils = require "st.utils"

--- @class st.zwave.Driver:Driver
--- @alias ZwaveDriver
---
--- @field public zwave_channel message_channel the communication channel for Z-Wave devices
--- @field public function default_handler optional callback to receive all Z-Wave messages for which no other callback is registered
--- @field public zwave_dispatcher st.zwave.Dispatcher
local ZwaveDriver = {}
ZwaveDriver.__index = ZwaveDriver

--- Handler function for the raw zwave channel message receive
---
--- This will be the default registered handler for the Zigbee message_channel
--- receive callback.  It will parse the raw serialized message into an
--- st.zw.Command and then use the zwave_dispatcher to find a handler that can deal
--- with it.
---
--- @param driver st.zwave.Driver
--- @param message_channel table Z-Wave message channel object
local function zw_cmd_handler(driver, message_channel)
  assert(type(message_channel) == "table", "message channel must be a table")
  local uuid, encap, src_channel, dst_channels, cmd_class, cmd_id, payload = message_channel:receive()
  local device = driver:get_device_info(uuid)
  local cmd = zw.Command(cmd_class, cmd_id, payload,
    { encap=encap, src_channel=src_channel, dst_channels=dst_channels })
  log.trace(string.format("Received %s from %s", cmd, device))
  driver.zwave_dispatcher:dispatch(driver, device, cmd)
end

--- Add a number of child handlers that override the top level driver behavior
---
--- Each handler set can contain a `handlers` field that follows exactly the same
--- pattern as the base driver format. It must also contain a
--- `zwave_can_handle(driver, device, cmd_class, cmd_id)` function that returns
--- true if the corresponding handlers should be considered.
---
--- This will recursively follow the `sub_drivers` and build a structure
--- that will correctly find and execute a handler that matches.  It should be
--- noted that a child handler will always be preferred over a handler at the
--- same level, but that if multiple child handlers report that they can handle
--- a message, it will be sent to each handler that reports it can handle the
--- message.
---
--- @param driver st.zwave.Driver
local function populate_zwave_dispatcher_from_sub_drivers(driver)
  for _, sub_driver in ipairs(driver.sub_drivers) do
    sub_driver.zwave_handlers = sub_driver.zwave_handlers or {}
    sub_driver.zwave_dispatcher =
      ZwaveDispatcher(sub_driver.NAME, sub_driver.can_handle, sub_driver.zwave_handlers)
    driver.zwave_dispatcher:register_child_dispatcher(sub_driver.zwave_dispatcher)
    populate_zwave_dispatcher_from_sub_drivers(sub_driver)
  end
end

--- Validate command callbacks.  At runtime, the driver requires a callback
--- registration structure as:
---
--- driver = {
---   zwave_handlers = {
---     [cmd_class] = {
---       [cmd_id] = callback
---     }
---   }
--- }
---
--- @param driver st.zwave.Driver
local function validate_cmd_callbacks(driver)
  driver.zwave_handlers = driver.zwave_handlers or {}
  assert(type(driver.zwave_handlers) == "table", "driver.zwave_handlers must be of type table")
  for cmd_class, v in pairs(driver.zwave_handlers) do
    assert(type(cmd_class) == "number" and type(v) == "table",
           "zwave handler registrations must be of form [cmd_class] = { [cmd_id] = callback } or " ..
           "{ [cmd_class] = { [cmd_id] = { callback, callback, ... } }")
    -- The handlers table must contain numerically-indexed entries keyed on
    -- command class and enclosing numerically-indexed sub-tables keyed on
    -- command code literals.
    for cmd_id, callback in pairs(driver.zwave_handlers[cmd_class]) do
      assert(     type(cmd_id) == "number"
              and (    type(callback) == "function"
                    or (     type(callback) == "table"
                         and (    type(callback[1] == "function")
                               or type(callback[1] == nil)))),
           "zwave handler registrations must be of form [cmd_class] = { [cmd_id] = callback } or " ..
           "{ [cmd_class] = { [cmd_id] = { callback, callback, ... } }")
    end
  end
end

-- By default, library behavior is to ignore incoming commands for which no
-- callback is registered.  This prevents dynamically loading portions of the
-- protocol library thare are not relevant to driver operation.
local default_handler = nil

--- @param device st.zwave.Device
local function device_added(driver, device, event)
  device:_populate_refresh_commands(driver)
end

local function device_configure(driver, device, event)
  device:configure()
end

local function device_refresh(driver, device, command)
  device:refresh()
end

--- @class st.zwave.Driver.Template
--- @alias Template
---
--- @field public supported_capabilities table flat list of SmartThings capabilities supported by the driver
--- @field public zwave_handlers table Z-Wave command handlers, indexed by [cmd_class][cmd_id]
--- @field public capability_handlers table capability handlers, indexed by capability ID
--- @field public lifecycle_handlers table device-configure and device-added lifecycle event callbacks
--- @field public sub_drivers table device-specific sub-drivers
local template = {}

---   * set Z-Wave command version overrides
---   * set Z-Wave receive channel override
---   * execute base Driver init
---   * parse zwave_handlers callback table
---   * set Z-Wave default handler override
---   * register RX on the Z-Wave socket
---   * register lifecycle callbacks
---
--- @param cls st.zwave.Driver Z-Wave driver definition table
--- @param name string driver name
--- @param driver_template st.zwave.Driver.Template driver-specific template
--- @return st.zwave.Driver driver instance on which :run() method may be called
function ZwaveDriver.init(cls, name, driver_template)
  local out_driver = driver_template or {}

  -- Init the cache.
  out_driver.cache = {}

  -- Set versions override.
  zw._deserialization_versions = driver_template.deserialization_versions or {}

  -- Set library versions fallback.
  setmetatable(zw._deserialization_versions, { __index = zw._versions })

  -- Set the Z-Wave socket in the driver, allowing for override.
  out_driver.zwave_channel = out_driver.zwave_channel or socket.zwave()


  -- Add device management functions
  out_driver.lifecycle_handlers = out_driver.lifecycle_handlers or {}
  utils.merge(
      out_driver.lifecycle_handlers,
      {
        doConfigure = device_configure,
        added = device_added,
      }
  )

  out_driver.capability_handlers = out_driver.capability_handlers or {}
  -- use default refresh if explicit handler not set
  utils.merge(
      out_driver.capability_handlers,
      {
        refresh = {
          refresh = device_refresh
        }
      }
  )

  -- Call base Driver init.
  out_driver = Driver.init(cls, name, out_driver)

  --  Create our dispatcher.
  out_driver.zwave_handlers = out_driver.zwave_handlers or {}
  out_driver.zwave_dispatcher = ZwaveDispatcher(out_driver.NAME,
    function(...) return true end, out_driver.zwave_handlers)

  -- Validate command subscriptions.
  validate_cmd_callbacks(out_driver)

  -- Set default handler override, or fallback to the library default.
  out_driver.default_handler = out_driver.default_handler or default_handler

  -- Register zwave RX handler.
  Driver.register_channel_handler(out_driver, out_driver.zwave_channel, zw_cmd_handler)

  --  Add child handler overrides.
  populate_zwave_dispatcher_from_sub_drivers(out_driver)

  log.trace(string.format("Setup driver %s with Z-Wave handlers:\n%s", out_driver.NAME, out_driver.zwave_dispatcher))
  return out_driver
end

setmetatable(ZwaveDriver, {
  __index = Driver,
  __call = ZwaveDriver.init
})

return ZwaveDriver
