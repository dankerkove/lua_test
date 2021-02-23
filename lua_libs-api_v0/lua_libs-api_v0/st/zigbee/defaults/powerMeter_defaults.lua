local zcl_clusters = require "st.zigbee.zcl.clusters"
local capabilities = require "st.capabilities"
local constants = require "st.zigbee.constants"

--- @class st.zigbee.defaults.powerMeter
--- @field public zigbee_handlers table
--- @field public attribute_configurations table
--- @field public capability_handlers table
--- @field public default_active_power_configuration st.zigbee.defaults.powerMeter.ActivePowerConfiguration
local powerMeter_defaults = {}

--- Default handler for ACPowerDivisor attribute on ElectricalMeasurement cluster
---
--- This will take the Uint16 value of the ACPowerDivisor on the ElectricalMeasurement cluster and set the devices field
---constants.ZIGBEE_DEVICE_POWER_DIVISOR to the value.  This will then be used in the default handling of the
--- ActivePower attribute
---
--- @param driver ZigbeeDriver The current driver running containing necessary context for execution
--- @param device ZigbeeDevice The device this message was received from containing identifying information
--- @param divisor Uint16 the value of the Divisor
--- @param zb_rx ZigbeeMessageRx the full message this report came in
function powerMeter_defaults.power_meter_divisor_handler(driver, device, divisor, zb_rx)
  local raw_value = divisor.value
  device:set_field(constants.ZIGBEE_DEVICE_POWER_DIVISOR, raw_value, {persist = true})
end

--- Default handler for ACPowerMultiplier attribute on ElectricalMeasurement cluster
---
--- This will take the Uint16 value of the ACPowerMultiplier on the ElectricalMeasurement cluster and set the devices field
---constants.ZIGBEE_DEVICE_POWER_MULTIPLIER to the value.  This will then be used in the default handling of the
--- ActivePower attribute
---
--- @param driver ZigbeeDriver The current driver running containing necessary context for execution
--- @param device ZigbeeDevice The device this message was received from containing identifying information
--- @param multiplier Uint16 the value of the Divisor
--- @param zb_rx ZigbeeMessageRx the full message this report came in
function powerMeter_defaults.power_meter_multiplier_handler(driver, device, multiplier, zb_rx)
  local raw_value = multiplier.value
  device:set_field(constants.ZIGBEE_DEVICE_POWER_MULTIPLIER, raw_value, {persist = true})
end

--- Default handler for ActivePower attribute on ElectricalMeasurement cluster
---
--- This converts the Int16 instantaneous demand into the powerMeter.power capability event.  This will
--- check the device for values set in the constants.ZIGBEE_DEVICE_POWER_MULTIPLIER and
--- constants.ZIGBEE_DEVICE_POWER_DIVISOR to convert the raw value to the correctly scaled values.  These
--- fields should be set by reading the values from the same cluster
---
--- @param driver ZigbeeDriver The current driver running containing necessary context for execution
--- @param device ZigbeeDevice The device this message was received from containing identifying information
--- @param value Int16 the value of the ActivePower
--- @param zb_rx ZigbeeMessageRx the full message this report came in
function powerMeter_defaults.power_meter_handler(driver, device, value, zb_rx)
  local raw_value = value.value
  -- By default emit raw value
  local multiplier = device:get_field(constants.ZIGBEE_DEVICE_POWER_MULTIPLIER) or 1
  local divisor = device:get_field(constants.ZIGBEE_DEVICE_POWER_DIVISOR) or 1
  raw_value = raw_value * multiplier/divisor
  device:emit_event_for_endpoint(zb_rx.address_header.src_endpoint.value, capabilities.powerMeter.power({value = raw_value, unit = "W" }))
end

powerMeter_defaults.zigbee_handlers = {
  global = {},
  cluster = {},
  attr = {
    [zcl_clusters.ElectricalMeasurement] = {
      [zcl_clusters.ElectricalMeasurement.attributes.ActivePower] = powerMeter_defaults.power_meter_handler,
      [zcl_clusters.ElectricalMeasurement.attributes.ACPowerDivisor.ID] = powerMeter_defaults.power_meter_divisor_handler,
      [zcl_clusters.ElectricalMeasurement.attributes.ACPowerMultiplier.ID] = powerMeter_defaults.power_meter_multiplier_handler,
    }
  }
}
powerMeter_defaults.capability_handlers = {}

--- @class st.zigbee.defaults.powerMeter.ActivePowerConfiguration
--- @field public cluster number SimpleMetering ID 0x0B04
--- @field public attribute number InstantaneousDemand ID 0x050B
--- @field public minimum_interval number 1 seconds
--- @field public maximum_interval number 3600 seconds (1 hour)
--- @field public data_type Int16 the Int16 class
--- @field public reportable_change number 1 (some amount of W, dependent on multiplier and divisor)
local active_power_configuration = {
  cluster = zcl_clusters.ElectricalMeasurement.ID,
  attribute = zcl_clusters.ElectricalMeasurement.attributes.ActivePower.ID,
  minimum_interval = 1,
  maximum_interval = 3600,
  data_type = zcl_clusters.ElectricalMeasurement.attributes.ActivePower.base_type,
  reportable_change = 1
}

powerMeter_defaults.default_active_power_configuration = active_power_configuration

powerMeter_defaults.attribute_configurations = {
  active_power_configuration
}

return powerMeter_defaults
