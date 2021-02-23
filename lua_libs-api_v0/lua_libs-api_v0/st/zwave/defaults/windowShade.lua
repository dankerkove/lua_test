local capabilities = require "st.capabilities"
--- @type st.zwave.CommandClass
local cc = require "st.zwave.CommandClass"
--- @type st.zwave.constants
local constants = require "st.zwave.constants"
--- @type st.zwave.CommandClass.Basic
local Basic = (require "st.zwave.CommandClass.Basic")({version=1})
--- @type st.zwave.CommandClass.Battery
local Battery = (require "st.zwave.CommandClass.Battery")({version=1})
--- @type st.zwave.CommandClass.SwitchMultilevel
local SwitchMultilevel = (require "st.zwave.CommandClass.SwitchMultilevel")({version=4})

local zwave_handlers = {}

--- Default handler for basic and switch multilevel reports for implementing devices
---
--- This converts the command operating state to the equivalent smartthings capability value
---
--- @param driver st.zwave.Driver
--- @param device st.zwave.Device
--- @param cmd st.zwave.CommandClass.Basic.Report | st.zwave.CommandClass.SwitchMultilevel.Report
function basic_and_switch_multilevel_report_handler(driver, device, cmd)
  local event
  local level = cmd.args.target_value and cmd.args.target_value or cmd.args.value
  if level >= 99 then
    event = capabilities.windowShade.windowShade.open()
  elseif level == 0 then
    event = capabilities.windowShade.windowShade.closed()
  else
    event = capabilities.windowShade.windowShade.partially_open()
  end
  device:emit_event(event)
end

--- Default handler for switch multilevel stop level change for implementing devices
---
--- This converts the command operating state to the equivalent smartthings capability value
---
--- @param driver st.zwave.Driver
--- @param device st.zwave.Device
--- @param cmd st.zwave.CommandClass.SwitchMultilevel.StopLevelChange
function switch_multilevel_stop_level_change_handler(driver, device, cmd)
  device:emit_event(capabilities.windowShade.windowShade.partially_open())
  device:send(SwitchMultilevel:Get({}))
end

local capability_handlers = {}

local function window_shade_state_change(driver, device, value)
  local set
  local get
  if device:is_cc_supported(cc.SWITCH_MULTILEVEL) then
    set = SwitchMultilevel:Set({
      value = value,
      duration = constants.DEFAULT_DIMMING_DURATION
    })
    get = SwitchMultilevel:Get({})
  else
    set = Basic:Set({
      value = value
    })
    get = Basic:Get({})
  end
  device:send(set)
  local query_device = function()
    device:send(get)
  end
  device.thread:call_with_delay(constants.MIN_DIMMING_GET_STATUS_DELAY, query_device)
end

--- Issue a window shade open command to the specified device.
---
--- @param driver st.zwave.Driver
--- @param device st.zwave.Device
--- @param command table ST level capability command
function capability_handlers.open(driver, device)
  window_shade_state_change(driver, device, 99)
end

--- Issue a window shade close command to the specified device.
---
--- @param driver st.zwave.Driver
--- @param device st.zwave.Device
--- @param command table ST level capability command
function capability_handlers.close(driver, device)
  window_shade_state_change(driver, device, SwitchMultilevel.value.OFF_DISABLE)
end

--- Issue a window shade pause command to the specified device.
---
--- @param driver st.zwave.Driver
--- @param device st.zwave.Device
--- @param command table ST level capability command
function capability_handlers.pause(driver, device)
  device:send(SwitchMultilevel:StopLevelChange({}))
end

--- @param driver st.zwave.Driver
--- @param device st.zwave.Device
local function get_refresh_commands(driver, device)
  if device:supports_capability_by_id(capabilities.windowShade.ID) and device:is_cc_supported(cc.SWITCH_MULTILEVEL) then
    return { SwitchMultilevel:Get({}) }
  elseif device:supports_capability_by_id(capabilities.windowShade.ID) and device:is_cc_supported(cc.BASIC) then
    return { Basic:Get({}) }
  end
end

--- @class st.zwave.defaults.windowShade
--- @alias window_shade_defaults
--- @field public zwave_handlers table
--- @field public capability_handlers table
--- @field public get_refresh_commands function
local window_shade_defaults = {
  zwave_handlers = {
    [cc.BASIC] = {
        [Basic.REPORT] = basic_and_switch_multilevel_report_handler
    },
    [cc.SWITCH_MULTILEVEL] = {
      [SwitchMultilevel.REPORT] = basic_and_switch_multilevel_report_handler,
      [SwitchMultilevel.STOP_LEVEL_CHANGE] = switch_multilevel_stop_level_change_handler,
    }
  },
  capability_handlers = {
    [capabilities.windowShade.commands.open] = capability_handlers.open,
    [capabilities.windowShade.commands.close] = capability_handlers.close,
    [capabilities.windowShade.commands.pause] = capability_handlers.pause
  },
  get_refresh_commands = get_refresh_commands
}

return window_shade_defaults
