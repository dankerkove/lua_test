local capabilities = require "st.capabilities"
local constants = require "st.zwave.constants"
--- @type st.zwave.CommandClass
local cc  = require "st.zwave.CommandClass"
--- @type st.zwave.CommandClass.Basic
local Basic = (require "st.zwave.CommandClass.Basic")({version=1,strict=true})
--- @type st.zwave.CommandClass.SwitchBinary
local SwitchBinary = (require "st.zwave.CommandClass.SwitchBinary")({version=2,strict=true})
--- @type st.zwave.CommandClass.Notification
local Notification = (require "st.zwave.CommandClass.Notification")({version=3,strict=true})

local BASIC_AND_SWITCH_BINARY_REPORT_STROBE_LIMIT = 33
local BASIC_AND_SWITCH_BINARY_REPORT_SIREN_LIMIT = 66
local BASIC_REPORT_SIREN_ACTIVE = 0xFF
local BASIC_REPORT_SIREN_IDLE = 0x00

local zwave_handlers = {}

local function determine_siren_cmd(value)
  local event
  if value == SwitchBinary.value.OFF_DISABLE then
    event = capabilities.alarm.alarm.off()
  elseif value <= BASIC_AND_SWITCH_BINARY_REPORT_STROBE_LIMIT then
    event = capabilities.alarm.alarm.strobe()
  elseif value <= BASIC_AND_SWITCH_BINARY_REPORT_SIREN_LIMIT then
    event = capabilities.alarm.alarm.siren()
  else
    event = capabilities.alarm.alarm.both()
  end
  return event
end

--- Default handler for notification command class reports
---
--- This converts notification reports across siren types into alarm events.
---
--- @param self st.zwave.Driver
--- @param device st.zwave.Device
--- @param cmd st.zwave.CommandClass.Notification.Report
local function notification_handler(self, device, cmd)
  if cmd.args.notification_type == Notification.notification_type.SIREN then
    if cmd.args.event == Notification.event.siren.ACTIVE then
      device:emit_event(capabilities.alarm.alarm.both())
      if device:supports_capability_by_id(capabilities.switch.ID) then
        device:emit_event(capabilities.switch.switch.on())
      end
    elseif cmd.args.event == Notification.event.siren.STATE_IDLE then
      device:emit_event(capabilities.alarm.alarm.off())
      if device:supports_capability_by_id(capabilities.switch.ID) then
        device:emit_event(capabilities.switch.switch.off())
      end
    end
  elseif cmd.args.notification_type == Notification.notification_type.HOME_SECURITY then
    if cmd.args.event == Notification.event.home_security.TAMPERING_PRODUCT_COVER_REMOVED then
      device:emit_event(capabilities.alarm.alarm.both())
    end
  end
end

--- Default handler for basic, switch binary reports for siren-implementing devices
---
--- This converts the command value from 0 -> Alarm.alarm.off
--- less than 33 -> Alarm.alarm.strobe, less than 66 -> Alarm.alarm.siren,
--- otherwise Alarm.alarm.off
---
--- @param self st.zwave.Driver
--- @param device st.zwave.Device
--- @param cmd st.zwave.CommandClass.Basic.Report | st.zwave.CommandClass.SwitchBinary.Report
function basic_and_switch_binary_report_handler(driver, device, cmd)
  local event
  if cmd.args.target_value ~= nil then
    event = determine_siren_cmd(cmd.args.target_value)
  else
    event = determine_siren_cmd(cmd.args.value)
  end
  device:emit_event(event)
end

local function siren_set_helper(driver, device, value)
  local delay = constants.DEFAULT_GET_STATUS_DELAY
  local set = Basic:Set({
    value=value
  })
  local get = Basic:Get({})
  device:send(set)
  local query_device = function()
    device:send(get)
  end
  device.thread:call_with_delay(delay, query_device)
end

local capability_handlers = {}

--- Issue a set siren command to the specified device.
---
--- @param driver st.zwave.Driver
--- @param device st.zwave.Device
--- @param command table ST level capability command
function capability_handlers.siren(driver, device)
  siren_set_helper(driver, device, SwitchBinary.value.ON_ENABLE)
end

--- Issue a set strobe command to the specified device.
---
--- @param driver st.zwave.Driver
--- @param device st.zwave.Device
--- @param command table ST level capability command
function capability_handlers.strobe(driver, device)
  siren_set_helper(driver, device, SwitchBinary.value.ON_ENABLE)
end

--- Issue a set both siren and strobe command to the specified device.
---
--- @param driver st.zwave.Driver
--- @param device st.zwave.Device
--- @param command table ST level capability command
function capability_handlers.both(driver, device)
  siren_set_helper(driver, device, SwitchBinary.value.ON_ENABLE)
end

--- Issue a set siren off command to the specified device.
---
--- @param driver st.zwave.Driver
--- @param device st.zwave.Device
--- @param command table ST level capability command
function capability_handlers.off(driver, device)
  siren_set_helper(driver, device, SwitchBinary.value.OFF_DISABLE)
end

--- @param driver st.zwave.Driver
--- @param device st.zwave.Device
local function get_refresh_commands(driver, device)
  if device:supports_capability_by_id(capabilities.alarm.ID) and device:is_cc_supported(cc.BASIC) then
    return {Basic:Get({})}
  end
end

--- @class st.zwave.defaults.alarm
--- @alias alarm_defaults
--- @field public zwave_handlers table
--- @field public capability_handlers table
--- @field public get_refresh_commands function
local alarm_defaults = {
  zwave_handlers = {
    [cc.BASIC] = {
      [Basic.REPORT] = basic_and_switch_binary_report_handler
    },
    [cc.SWITCH_BINARY] = {
      [SwitchBinary.REPORT] = basic_and_switch_binary_report_handler
    },
    [cc.NOTIFICATION] = {
      [Notification.REPORT] = notification_handler
    }
  },
  capability_handlers = {
    [capabilities.alarm.commands.both] = capability_handlers.both,
    [capabilities.alarm.commands.off] = capability_handlers.off,
    [capabilities.alarm.commands.siren] = capability_handlers.siren,
    [capabilities.alarm.commands.strobe] = capability_handlers.strobe
  },
  get_refresh_commands = get_refresh_commands,
}

return alarm_defaults