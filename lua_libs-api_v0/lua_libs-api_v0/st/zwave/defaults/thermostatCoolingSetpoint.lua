local capabilities = require "st.capabilities"
--- @type st.utils
local utils = require "st.utils"
--- @type st.zwave.CommandClass
local cc = require "st.zwave.CommandClass"
--- @type st.zwave.constants
local constants = require "st.zwave.constants"
--- @type st.zwave.CommandClass.ThermostatSetpoint
local ThermostatSetpoint = (require "st.zwave.CommandClass.ThermostatSetpoint")({version=2,strict=true})

--- Default handler for thermostat setpoint reports for cooling setpoint-implementing devices
---
--- This converts the command setpoint value to the equivalent cooling setpoint event if the
--- setpoint type is "cooling". It also stores the temperature scale used to report this value,
--- so that commands from the hub to the device will be sent in the same scale.
---
--- @param self st.zwave.Driver
--- @param device st.zwave.Device
--- @param cmd st.zwave.CommandClass.ThermostatSetpoint.Report
local function thermostat_setpoint_report_cooling_handler(self, device, cmd)
  if (cmd.args.setpoint_type == ThermostatSetpoint.setpoint_type.COOLING_1) then
    local scale = 'C'
    if (cmd.args.scale == ThermostatSetpoint.scale.FAHRENHEIT) then scale = 'F' end
    device:set_field(constants.TEMPERATURE_SCALE, cmd.args.scale, {persist = true})
    device:emit_event(capabilities.thermostatCoolingSetpoint.coolingSetpoint({value = cmd.args.value, unit = scale }))
  end
end

--- Default handler for the ThermostatCoolingSetpoint.setCoolingSetpoint command
---
--- This will send a thermostat setpoint set for the cooling setpoint to the device in the scale most
--- recently received by us from the thermostat (if any) followed by a delayed get of the same setpoint
--- to confirm. This command assumes all set setpoint commands are in celsius
---
--- @param driver st.zwave.Driver
--- @param device st.zwave.Device
--- @param command table The capability command table
local function set_cooling_setpoint(driver, device, command)
  local scale = device:get_field(constants.TEMPERATURE_SCALE)
  local value = command.args.setpoint
  if (scale == ThermostatSetpoint.scale.FAHRENHEIT) then
    value = utils.c_to_f(value) -- the device has reported using F, so set using F
  end

  local set = ThermostatSetpoint:Set({
    setpoint_type = ThermostatSetpoint.setpoint_type.COOLING_1,
    scale = scale,
    value = value
  })
  device:send(set)

  local follow_up_poll = function()
    device:send(ThermostatSetpoint:Get({setpoint_type = ThermostatSetpoint.setpoint_type.COOLING_1}))
  end

  device.thread:call_with_delay(1, follow_up_poll)
end

--- @class st.zwave.defaults.thermostatCoolingSetpoint
--- @alias thermostat_cooling_setpoint_defaults
--- @field public zwave_handlers table
--- @field public capability_handlers table
local thermostat_cooling_setpoint_defaults = {
  zwave_handlers = {
    [cc.THERMOSTAT_SETPOINT] = {
      [ThermostatSetpoint.REPORT] = thermostat_setpoint_report_cooling_handler
    }
  },
  capability_handlers = {
    [capabilities.thermostatCoolingSetpoint.commands.setCoolingSetpoint] = set_cooling_setpoint,
  }
}

return thermostat_cooling_setpoint_defaults
