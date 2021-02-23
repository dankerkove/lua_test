local capabilities = require "st.capabilities"
--- @type st.zwave.CommandClass
local cc = require "st.zwave.CommandClass"
--- @type st.zwave.CommandClass.ThermostatFanMode
local ThermostatFanMode = (require "st.zwave.CommandClass.ThermostatFanMode")({version=3})

--- Default handler for thermostat fan mode reports for implementing devices
---
--- This converts the command fan mode to the equivalent smartthings capability value
---
--- @param self st.zwave.Driver
--- @param device st.zwave.Device
--- @param cmd st.zwave.CommandClass.ThermostatFanMode.Report
local function thermostat_fan_mode_report_handler(self, device, cmd)
  local event = nil
  if (cmd.args.fan_mode == ThermostatFanMode.fan_mode.AUTO_LOW) or
    (cmd.args.fan_mode == ThermostatFanMode.fan_mode.AUTO_HIGH) or
    (cmd.args.fan_mode == ThermostatFanMode.fan_mode.AUTO_MEDIUM) then
    event = capabilities.thermostatFanMode.thermostatFanMode.auto()
  elseif (cmd.args.fan_mode == ThermostatFanMode.fan_mode.LOW) or
    (cmd.args.fan_mode == ThermostatFanMode.fan_mode.MEDIUM) or
    (cmd.args.fan_mode == ThermostatFanMode.fan_mode.HIGH) then
    event = capabilities.thermostatFanMode.thermostatFanMode.on()
  elseif (cmd.args.fan_mode == ThermostatFanMode.fan_mode.CIRCULATION) then
    event = capabilities.thermostatFanMode.thermostatFanMode.circulate()
  end

  if (event ~= nil) then
    device:emit_event(event)
  end
end

--- Default handler for thermostat fan mode supported reports for implementing devices
---
--- This converts the command supported fan modes to the equivalent smartthings capability value
---
--- @param self st.zwave.Driver
--- @param device st.zwave.Device
--- @param cmd st.zwave.CommandClass.ThermostatFanMode.SupportedReport
local function thermostat_supported_fan_modes_report_handler(self, device, cmd)
  local supported_fan_modes = {}
  if (cmd.args.low) then
    table.insert(supported_fan_modes, capabilities.thermostatFanMode.thermostatFanMode.on.NAME)
  end
  if (cmd.args.auto) then
    table.insert(supported_fan_modes, capabilities.thermostatFanMode.thermostatFanMode.auto.NAME)
  end
  if (cmd.args.circulation) then
    table.insert(supported_fan_modes, capabilities.thermostatFanMode.thermostatFanMode.circulate.NAME)
  end
  device:emit_event(capabilities.thermostatFanMode.supportedThermostatFanModes(supported_fan_modes))
end

--- Default handler for the ThermostatFanMode.setThermostatFanMode command
---
--- This will send a thermostat fan mode set of the equivalent z-wave value, with a follow up
--- get to confirm.
---
--- @param driver st.zwave.Driver
--- @param device st.zwave.Device
--- @param command table The capability command table
local function set_thermostat_fan_mode(driver, device, command)
  local modes = capabilities.thermostatFanMode.thermostatFanMode
  local mode = command.args.mode
  local modeValue = nil
  if (mode == modes.auto.NAME) then
    modeValue = ThermostatFanMode.fan_mode.AUTO_LOW
  elseif (mode == modes.on.NAME) then
    modeValue = ThermostatFanMode.fan_mode.LOW
  elseif (mode == modes.circulate.NAME) then
    modeValue = ThermostatFanMode.fan_mode.CIRCULATE
  end

  if (modeValue ~= nil) then
    device:send(ThermostatFanMode:Set({fan_mode = modeValue}))

    local follow_up_poll = function()
      device:send(ThermostatFanMode:Get({}))
    end

    device.thread:call_with_delay(1, follow_up_poll)
  end

end

local fan_mode_setter = function(fan_mode_string)
  return function(driver, device, command)
    set_thermostat_fan_mode(driver, device, {args={mode=fan_mode_string}})
  end
end

--- @class st.zwave.defaults.thermostatFanMode
--- @alias thermostat_mode_defaults
--- @field public zwave_handlers table
--- @field public capability_handlers table
local thermostat_mode_defaults = {
  zwave_handlers = {
    [cc.THERMOSTAT_FAN_MODE] = {
      [ThermostatFanMode.REPORT] = thermostat_fan_mode_report_handler,
      [ThermostatFanMode.SUPPORTED_REPORT] = thermostat_supported_fan_modes_report_handler
    }
  },
  capability_handlers = {
    [capabilities.thermostatFanMode.commands.setThermostatFanMode] = set_thermostat_fan_mode,
    [capabilities.thermostatFanMode.commands.fanAuto] = fan_mode_setter(capabilities.thermostatFanMode.thermostatFanMode.auto.NAME),
    [capabilities.thermostatFanMode.commands.fanOn] = fan_mode_setter(capabilities.thermostatFanMode.thermostatFanMode.on.NAME),
    [capabilities.thermostatFanMode.commands.fanCirculate] = fan_mode_setter(capabilities.thermostatFanMode.thermostatFanMode.circulate.NAME)
  }
}

return thermostat_mode_defaults
