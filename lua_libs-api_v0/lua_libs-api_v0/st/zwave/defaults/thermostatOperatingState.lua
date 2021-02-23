local capabilities = require "st.capabilities"
--- @type st.zwave.CommandClass
local cc = require "st.zwave.CommandClass"
--- @type st.zwave.CommandClass.ThermostatOperatingState
local ThermostatOperatingState = (require "st.zwave.CommandClass.ThermostatOperatingState")({version=1,strict=true})

--- Default handler for thermostat operating state reports for implementing devices
---
--- This converts the command operating state to the equivalent smartthings capability value
---
--- @param self st.zwave.Driver
--- @param device st.zwave.Device
--- @param cmd st.zwave.CommandClass.ThermostatOperatingState.Report
local function thermostat_operating_state_report_handler(self, device, cmd)
  local event = nil
  if (cmd.args.operating_state == ThermostatOperatingState.operating_state.IDLE) then
    event = capabilities.thermostatOperatingState.thermostatOperatingState.idle()
  elseif (cmd.args.operating_state == ThermostatOperatingState.operating_state.HEATING) then
    event = capabilities.thermostatOperatingState.thermostatOperatingState.heating()
  elseif (cmd.args.operating_state == ThermostatOperatingState.operating_state.COOLING) then
    event = capabilities.thermostatOperatingState.thermostatOperatingState.cooling()
  elseif (cmd.args.operating_state == ThermostatOperatingState.operating_state.FAN_ONLY) then
    event = capabilities.thermostatOperatingState.thermostatOperatingState.fan_only()
  elseif (cmd.args.operating_state == ThermostatOperatingState.operating_state.PENDING_HEAT) then
    event = capabilities.thermostatOperatingState.thermostatOperatingState.pending_heat()
  elseif (cmd.args.operating_state == ThermostatOperatingState.operating_state.PENDING_COOL) then
    event = capabilities.thermostatOperatingState.thermostatOperatingState.pending_cool()
  elseif (cmd.args.operating_state == ThermostatOperatingState.operating_state.VENT_ECONOMIZER) then
    event = capabilities.thermostatOperatingState.thermostatOperatingState.vent_economizer()
  end

  if (event ~= nil) then
    device:emit_event(event)
  end
end

--- @class st.zwave.defaults.thermostatOperatingState
--- @alias thermostat_operating_state_defaults
--- @field public zwave_handlers table
local thermostat_operating_state_defaults = {
  zwave_handlers = {
    [cc.THERMOSTAT_OPERATING_STATE] = {
      [ThermostatOperatingState.REPORT] = thermostat_operating_state_report_handler
    }
  }
}

return thermostat_operating_state_defaults
