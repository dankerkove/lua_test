local capabilities = require "st.capabilities"
--- @type st.zwave.CommandClass
local cc = require "st.zwave.CommandClass"
--- @type st.zwave.constants
local constants = require "st.zwave.constants"
--- @type st.zwave.CommandClass.Basic
local Basic = (require "st.zwave.CommandClass.Basic")({version=1})
--- @type st.zwave.CommandClass.SwitchMultilevel
local SwitchMultilevel = (require "st.zwave.CommandClass.SwitchMultilevel")({version=4})

local zwave_handlers = {}

--- Default handler for basic and switch multilevel reports for implementing devices
---
--- This converts operated level to the equivalent smartthings capability value
---
--- @param driver st.zwave.Driver
--- @param device st.zwave.Device
--- @param cmd st.zwave.CommandClass.Basic.Report | st.zwave.CommandClass.SwitchMultilevel.Report
function basic_and_switch_multilevel_report_handler(driver, device, cmd)
  local event
  local level = cmd.args.target_value and cmd.args.target_value or cmd.args.value
  if level >= 99 then
    event = capabilities.windowShadeLevel.shadeLevel(100)
  elseif level == 0 then
    event = capabilities.windowShadeLevel.shadeLevel(0)
  else
    event = capabilities.windowShadeLevel.shadeLevel(level)
  end
  device:emit_event(event)
end

local capability_handlers = {}

--- Issue a set window shade level command to the specified device.
---
--- @param driver st.zwave.Driver
--- @param device st.zwave.Device
--- @param command table ST level capability command
function capability_handlers.set_shade_level(driver, device, command)
  local set
  local get
  if device:is_cc_supported(cc.SWITCH_MULTILEVEL) then
    set = SwitchMultilevel:Set({
      value = command.args.shadeLevel.value,
      duration = constants.DEFAULT_DIMMING_DURATION
    })
    get = SwitchMultilevel:Get({})
  else
    set = Basic:Set({
      value = command.args.shadeLevel.value
    })
    get = Basic:Get({})
  end
  device:send(set)
  local query_device = function()
    device:send(get)
  end
  device.thread:call_with_delay(constants.MIN_DIMMING_GET_STATUS_DELAY, query_device)
end

--- @param driver st.zwave.Driver
--- @param device st.zwave.Device
local function get_refresh_commands(driver, device)
  if device:supports_capability_by_id(capabilities.windowShadeLevel.ID) and device:is_cc_supported(cc.SWITCH_MULTILEVEL) then
    return { SwitchMultilevel:Get({}) }
  elseif device:supports_capability_by_id(capabilities.windowShadeLevel.ID) and device:is_cc_supported(cc.BASIC) then
    return { Basic:Get({}) }
  end
end

--- @class st.zwave.defaults.windowShadeLevel
--- @alias window_shade_preset_defaults
--- @field public zwave_handlers table
--- @field public capability_handlers table
local window_shade_level_defaults = {
  zwave_handlers = {
    [cc.BASIC] = {
        [Basic.REPORT] = basic_and_switch_multilevel_report_handler
      },
    [cc.SWITCH_MULTILEVEL] = {
      [SwitchMultilevel.REPORT] = basic_and_switch_multilevel_report_handler
    }
  },
  capability_handlers = {
    [capabilities.windowShadeLevel.commands.setShadeLevel] = capability_handlers.set_shade_level
  },
  get_refresh_commands = get_refresh_commands
}

return window_shade_level_defaults
