local capabilities = require "st.capabilities"
--- @type st.zwave.CommandClass
local cc = require "st.zwave.CommandClass"
--- @type st.zwave.CommandClass.ThermostatMode
local ThermostatMode = (require "st.zwave.CommandClass.ThermostatMode")({version=2})

--- Default handler for thermostat mode reports for implementing devices
---
--- This converts the command mode to the equivalent smartthings capability value
---
--- @param self st.zwave.Driver
--- @param device st.zwave.Device
--- @param cmd st.zwave.CommandClass.ThermostatMode.Report
local function thermostat_mode_report_handler(self, device, cmd)
  local event = nil
  if (cmd.args.mode == ThermostatMode.mode.OFF) then
    event = capabilities.thermostatMode.thermostatMode.off()
  elseif (cmd.args.mode == ThermostatMode.mode.HEAT) then
    event = capabilities.thermostatMode.thermostatMode.heat()
  elseif (cmd.args.mode == ThermostatMode.mode.COOL) then
    event = capabilities.thermostatMode.thermostatMode.cool()
  elseif (cmd.args.mode == ThermostatMode.mode.AUTO) then
    event = capabilities.thermostatMode.thermostatMode.auto()
  elseif (cmd.args.mode == ThermostatMode.mode.AUXILIARY_HEAT) then
    event = capabilities.thermostatMode.thermostatMode.emergency_heat()
  end

  if (event ~= nil) then
    device:emit_event(event)
  end
end

--- Default handler for thermostat mode supported reports for implementing devices
---
--- This converts the command supported modes to the equivalent smartthings capability value
---
--- @param self st.zwave.Driver
--- @param device st.zwave.Device
--- @param cmd st.zwave.CommandClass.ThermostatMode.SupportedReport
local function thermostat_supported_modes_report_handler(self, device, cmd)
  local supported_modes = {}
  if (cmd.args.off) then
    table.insert(supported_modes, capabilities.thermostatMode.thermostatMode.off.NAME)
  end
  if (cmd.args.heat) then
    table.insert(supported_modes, capabilities.thermostatMode.thermostatMode.heat.NAME)
  end
  if (cmd.args.cool) then
    table.insert(supported_modes, capabilities.thermostatMode.thermostatMode.cool.NAME)
  end
  if (cmd.args.auto) then
    table.insert(supported_modes, capabilities.thermostatMode.thermostatMode.auto.NAME)
  end
  if (cmd.args.auxiliary_emergency_heat) then
    table.insert(supported_modes, capabilities.thermostatMode.thermostatMode.emergency_heat.NAME)
  end
  device:emit_event(capabilities.thermostatMode.supportedThermostatModes(supported_modes))
end

--- Default handler for the ThermostatMode.setThermostatMode command
---
--- This will send a thermostat mode set of the equivalent z-wave value, with a follow up
--- get to confirm.
---
--- @param driver st.zwave.Driver
--- @param device st.zwave.Device
--- @param command table The capability command table
local function set_thermostat_mode(driver, device, command)
  local modes = capabilities.thermostatMode.thermostatMode
  local mode = command.args.mode
  local modeValue = nil
  if (mode == modes.off.NAME) then
    modeValue = ThermostatMode.mode.OFF
  elseif (mode == modes.heat.NAME) then
    modeValue = ThermostatMode.mode.HEAT
  elseif (mode == modes.cool.NAME) then
    modeValue = ThermostatMode.mode.COOL
  elseif (mode == modes.auto.NAME) then
    modeValue = ThermostatMode.mode.AUTO
  elseif (mode == modes.emergency_heat.NAME) then
    modeValue = ThermostatMode.mode.AUXILIARY_HEAT
  end

  if (modeValue ~= nil) then
    device:send(ThermostatMode:Set({mode = modeValue}))

    local follow_up_poll = function()
      device:send(ThermostatMode:Get({}))
    end

    device.thread:call_with_delay(1, follow_up_poll)
  end

end

local mode_setter = function(mode_name)
  return function(driver, device, command)
    set_thermostat_mode(driver,device,{args={mode=mode_name}})
  end
end

--- @class st.zwave.defaults.thermostatMode
--- @alias thermostat_mode_defaults
--- @field public zwave_handlers table
--- @field public capability_handlers table
local thermostat_mode_defaults = {
  zwave_handlers = {
    [cc.THERMOSTAT_MODE] = {
      [ThermostatMode.REPORT] = thermostat_mode_report_handler,
      [ThermostatMode.SUPPORTED_REPORT] = thermostat_supported_modes_report_handler
    }
  },
  capability_handlers = {
    [capabilities.thermostatMode.commands.setThermostatMode] = set_thermostat_mode,
    [capabilities.thermostatMode.commands.auto] = mode_setter(capabilities.thermostatMode.thermostatMode.auto.NAME),
    [capabilities.thermostatMode.commands.cool] = mode_setter(capabilities.thermostatMode.thermostatMode.cool.NAME),
    [capabilities.thermostatMode.commands.heat] = mode_setter(capabilities.thermostatMode.thermostatMode.heat.NAME),
    [capabilities.thermostatMode.commands.emergencyHeat] = mode_setter(capabilities.thermostatMode.thermostatMode.emergency_heat.NAME),
    [capabilities.thermostatMode.commands.off] = mode_setter(capabilities.thermostatMode.thermostatMode.off.NAME)
  }
}

return thermostat_mode_defaults
