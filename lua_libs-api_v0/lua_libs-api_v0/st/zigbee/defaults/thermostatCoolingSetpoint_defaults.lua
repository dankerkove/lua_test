local zcl_clusters = require "st.zigbee.zcl.clusters"
local capabilities = require "st.capabilities"

--- @class st.zigbee.defaults.thermostatCoolingSetpoint
--- @field public zigbee_handlers table
--- @field public attribute_configurations table
--- @field public capability_handlers table
local tcs_defaults = {}

--- Default handler for the occupied cooling setpoint value attribute on the thermostat cluster
---
--- This converts the Int16 value of the occupied cooling setpoint attribute on the thermostat cluster to
--- ThermostatCoolingSetpoint.coolingSetpoint
---
--- @param driver Driver The current driver running containing necessary context for execution
--- @param device ZigbeeDevice The device this message was received from containing identifying information
--- @param value Int16 the thermostat occupied cooling setpoint value
--- @param zb_rx ZigbeeMessageRx the full message this report came in
function tcs_defaults.thermostat_cooling_setpoint_handler(driver, device, value, zb_rx)
  local raw_temp = value.value
  local celc_temp = raw_temp / 100.0
  local temp_scale = "C"
  device:emit_event_for_endpoint(zb_rx.address_header.src_endpoint.value, capabilities.thermostatCoolingSetpoint.coolingSetpoint({value = celc_temp, unit = temp_scale }))
end

--- Default handler for the ThermostatCoolingSetpoint.setCoolingSetpoint command
---
--- This will send a write to the occupied cooling setpoint attribute in the thermostat cluster,
--- followed by a delayed read of the same attribute to confirm
---
--- @param driver Driver The current driver running containing necessary context for execution
--- @param device Device The device this message was received from containing identifying information
--- @param command CapabilityCommand The capability command table
function tcs_defaults.set_cooling_setpoint(driver, device, command)
  device:send_to_component(command.component, zcl_clusters.Thermostat.attributes.OccupiedCoolingSetpoint:write(device, command.args.setpoint*100))

  device.thread:call_with_delay(2, function(d)
    device:send_to_component(command.component, zcl_clusters.Thermostat.attributes.OccupiedCoolingSetpoint:read(device))
  end)
end

tcs_defaults.zigbee_handlers = {
  global = {},
  cluster = {},
  attr = {
    [zcl_clusters.Thermostat] = {
      [zcl_clusters.Thermostat.attributes.OccupiedCoolingSetpoint] = tcs_defaults.thermostat_cooling_setpoint_handler,
    }
  }
}
tcs_defaults.capability_handlers = {
  [capabilities.thermostatCoolingSetpoint.commands.setCoolingSetpoint] = tcs_defaults.set_cooling_setpoint,
}

return tcs_defaults
