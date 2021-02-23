local log = require "log"
--- @type Device
local base_device = require "st.device"

local REFRESH_COMMANDS_KEY = "__refresh_commands"

--- @module zwave_device
local zwave_device = {}

--- @class st.zwave.Device:Device
--- @alias ZwaveDevice
local ZwaveDevice = {}

--- Send one-time setup commands to the associated Z-Wave device.
function ZwaveDevice:configure()
  error("Not implemented")
end

--- Add a refresh command to this device's transient store.
---
--- All commands from refresh list shall be sent when `refresh` is called on the device.
---
--- @param self st.zwave.Device
--- @param command st.Zwave.Command refresh command to add
local function _add_refresh_command(self, command)
  local refresh_commands = self:get_field(REFRESH_COMMANDS_KEY) or {}
  refresh_commands[command.cmd_class] = refresh_commands[command.cmd_class] or {}
  refresh_commands[command.cmd_class][command.cmd_id] = refresh_commands[command.cmd_class][command.cmd_id] or {}
  for _, cmd in ipairs(refresh_commands[command.cmd_class][command.cmd_id]) do
    if cmd == command then
      return --idetical command already configured
    end
  end
  table.insert(refresh_commands[command.cmd_class][command.cmd_id], command)
  self:set_field(REFRESH_COMMANDS_KEY, refresh_commands)
end

--- Populate the list of refresh commands for self device.
---
--- The refresh commands list is formulated by executing the functions in the driver.get_refresh_commands_defaults, populated from capability-based defaults.
---
--- @param self st.zwave.Device
--- @param driver st.zwave.Driver
function ZwaveDevice._populate_refresh_commands(self, driver)
  for _, get_refresh_commands in pairs(driver.get_refresh_commands_defaults or {}) do
    if type(get_refresh_commands) == "function" then
      local commands = get_refresh_commands(driver, self)
      for _, command in ipairs(commands or {}) do
        _add_refresh_command(self, command)
      end
    end
  end
end

--- Send refresh commands to the associated Z-Wave device.
function ZwaveDevice:refresh()
  local refresh_commands = self:get_field(REFRESH_COMMANDS_KEY) or {}
  for _, command_class in pairs(refresh_commands) do
    for _, commands in pairs(command_class) do
      for _, command in ipairs(commands) do
        self:send(command)
      end
    end
  end
end

--- Send a Z-Wave command to the associated Z-Wave device.
---
--- @param cmd st.zwave.Command
function ZwaveDevice:send(cmd)
  self.zwave_channel:send(self.id, cmd.encap, cmd.cmd_class, cmd.cmd_id, cmd.payload, cmd.src_channel, cmd.dst_channels)
end

--- Interrogate the device's profile to determine whether a particular command class is supported.
---
--- @param cc_value number the command class id as defined in cc.lua, e.g cc.SWITCH_BINARY = 0x25
--- @return boolean true if the command class is supported, false if not
function ZwaveDevice:is_cc_supported(cc_value)
  if self.zwave_endpoints == nil then
    log.error("ZwaveDevice.zwave_endpoints is nil.")
    return false
  end

  if self.zwave_endpoints[1] == nil then
    log.error("ZwaveDevice.zwave_endpoints[1] is nil.")
    return false
  end

  if self.zwave_endpoints[1].command_classes == nil then
    log.error("ZwaveDevice.zwave_endpoints[1].command_classes is nil")
    return false
  end

  for _, cc in ipairs(self.zwave_endpoints[1].command_classes) do
    if cc.value == cc_value then
      return true
    end
  end
  return false
end

--- Determine whether device self is a match to the passed manufacturer ID(s),
--- product ID(s) and product type(s).  Filter arguments can be numerical
--- literals or arrays of numerical literals.
---
--- In the case that a filter argument is an array, matching uses OR logic.
--- Match against any single array item is considered a device match.
---
--- @param mfr_id number|table numerical manufacturer ID or array of IDs
--- @param product_type number|table numerical product type ( aka product in DTH namespace) or array of types.
--- @param product_id number|table numerical product ID ( aka model in DTH namespace) or array of IDs
--- @return boolean true if device self matches the passed all filter arguments
function ZwaveDevice:id_match(mfr_id, product_type, product_id)
  local match
  local matrix = {
    {
      filter = mfr_id,
      devattr = self.zwave_manufacturer_id
    },
    {
      filter = product_id,
      devattr = self.zwave_product_id
    },
    {
      filter = product_type,
      devattr = self.zwave_product_type
    },
  }
  for _,m in pairs(matrix) do
    match = false
    if type(m.filter) == "number" then
      if m.devattr == m.filter then
        match = true
      end
    elseif type(m.filter) == "table" then
      for _,filter in pairs(m.filter) do
        if m.devattr == filter then
          match = true
          break
        end
      end
    else
      error("unsupported filter type " .. type(mfr_id))
    end
    if match == false then
      return match
    end
  end
  return match
end

--- Initialize an st.zwave.Device instance
---
--- @param cls st.zwave.Device st.zwave.Device class definition table
--- @param driver st.zwave.Driver
--- @param raw_device table cloud-published device instance data
function ZwaveDevice.init(cls, driver, raw_device)
  local out_device = base_device.Device.init(cls, driver, raw_device)
  out_device.driver = driver
  out_device.zwave_channel = driver.zwave_channel
  base_device.Device._protect(cls, out_device)
  out_device:load_updated_data(raw_device)
  return out_device
end

ZwaveDevice.CLASS_NAME = "st.zwave.Device"

--- Get a string with the ID and label of the device.
---
--- @return string a short string representation of the device
function ZwaveDevice:pretty_print()
  return string.format("<%s: %s>", self.CLASS_NAME, self.id)
end

ZwaveDevice.__tostring = ZwaveDevice.pretty_print

zwave_device.ZwaveDevice = ZwaveDevice

setmetatable(ZwaveDevice, {
  __index = base_device.Device,
  __call = ZwaveDevice.init
})

return zwave_device
