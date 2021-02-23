local zcl_clusters = require "st.zigbee.zcl.clusters"
local constants = require "st.zigbee.constants"
local capabilities = require "st.capabilities"

--- @class st.zigbee.defaults.energyMeter
--- @field public zigbee_handlers table
--- @field public attribute_configurations table
--- @field public capability_handlers table
--- @field public default_instantaneous_demand_configuration st.zigbee.defaults.energyMeter.InstantaneousDemandConfiguration
local energyMeter_defaults = {}


--- Default handler for InstantaneousDemand attribute on SimpleMetering cluster
---
--- This converts the Int24 instantaneous demand into the energyMeter.energy capability event.  This will
--- check the device for values set in the constants.ZIGBEE_DEVICE_ENERGY_MULTIPLIER and
--- constants.ZIGBEE_DEVICE_ENERGY_DIVISOR to convert the raw value to the correctly scaled values.  These
--- fields should be set by reading the values from the same cluster
---
--- @param driver ZigbeeDriver The current driver running containing necessary context for execution
--- @param device ZigbeeDevice The device this message was received from containing identifying information
--- @param value Int24 the value of the instantaneous demand
--- @param zb_rx ZigbeeMessageRx the full message this report came in
function energyMeter_defaults.energy_meter_handler(driver, device, value, zb_rx)
  local raw_value = value.value
  --- demand = demand received * Multipler/Divisor
  local multiplier = device:get_field(constants.ZIGBEE_DEVICE_ENERGY_MULTIPLIER) or 1
  local divisor = device:get_field(constants.ZIGBEE_DEVICE_ENERGY_DIVISOR) or 1
  raw_value = raw_value * multiplier/divisor
  device:emit_event_for_endpoint(zb_rx.address_header.src_endpoint.value, capabilities.energyMeter.energy({value = raw_value, unit = "kWh" }))
end

--- Default handler for Divisor attribute on SimpleMetering cluster
---
--- This will take the Int24 value of the Divisor on the SimpleMetering cluster and set the devices field
---constants.ZIGBEE_DEVICE_ENERGY_DIVISOR to the value.  This will then be used in the default handling of the
---InstantaneousDemand attribute
---
--- @param driver ZigbeeDriver The current driver running containing necessary context for execution
--- @param device ZigbeeDevice The device this message was received from containing identifying information
--- @param divisor Int24 the value of the Divisor
--- @param zb_rx ZigbeeMessageRx the full message this report came in
function energyMeter_defaults.energy_meter_divisor_handler(driver, device, divisor, zb_rx)
  local raw_value = divisor.value
  device:set_field(constants.ZIGBEE_DEVICE_ENERGY_DIVISOR, raw_value, {persist = true})
end

--- Default handler for Multiplier attribute on SimpleMetering cluster
---
--- This will take the Int24 value of the Multiplier on the SimpleMetering cluster and set the devices field
---constants.ZIGBEE_DEVICE_ENERGY_MULTIPLIER to the value.  This will then be used in the default handling of the
---InstantaneousDemand attribute
---
--- @param driver ZigbeeDriver The current driver running containing necessary context for execution
--- @param device ZigbeeDevice The device this message was received from containing identifying information
--- @param multiplier Int24 the value of the Multiplier
--- @param zb_rx ZigbeeMessageRx the full message this report came in
function energyMeter_defaults.energy_meter_multiplier_handler(driver, device, multiplier, zb_rx)
  local raw_value = multiplier.value
  device:set_field(constants.ZIGBEE_DEVICE_ENERGY_MULTIPLIER, raw_value, {persist = true})
end

energyMeter_defaults.zigbee_handlers = {
  global = {},
  cluster = {},
  attr = {
    [zcl_clusters.SimpleMetering] = {
      [zcl_clusters.SimpleMetering.attributes.InstantaneousDemand] = energyMeter_defaults.energy_meter_handler,
      [zcl_clusters.SimpleMetering.attributes.Multiplier] = energyMeter_defaults.energy_meter_multiplier_handler,
      [zcl_clusters.SimpleMetering.attributes.Divisor] = energyMeter_defaults.energy_meter_divisor_handler,
    }
  }
}

energyMeter_defaults.capability_handlers = {}

--- @class st.zigbee.defaults.energyMeter.InstantaneousDemandConfiguration
--- @field public cluster number SimpleMetering ID 0x0702
--- @field public attribute number InstantaneousDemand ID 0x0400
--- @field public minimum_interval number 5 seconds
--- @field public maximum_interval number 3600 seconds (1 hour)
--- @field public data_type Int24 the Int24 class
--- @field public reportable_change number 5 (some amount of kWh, dependent on multiplier and divisor)
local instantaneous_demand_default_config = {
  cluster = zcl_clusters.SimpleMetering.ID,
  attribute = zcl_clusters.SimpleMetering.attributes.InstantaneousDemand.ID,
  minimum_interval = 5,
  maximum_interval = 3600,
  data_type = zcl_clusters.SimpleMetering.attributes.InstantaneousDemand.base_type,
  reportable_change = 1
}

energyMeter_defaults.default_instantaneous_demand_configuration = instantaneous_demand_default_config

energyMeter_defaults.attribute_configurations = {
  instantaneous_demand_default_config
}

return energyMeter_defaults
