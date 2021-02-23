local zcl_clusters = require "st.zigbee.zcl.clusters"
local capabilities = require "st.capabilities"

--- @class st.zigbee.defaults.illuminanceMeasurement
--- @field public zigbee_handlers table
--- @field public attribute_configurations table
--- @field public capability_handlers table
local illuminance_measurement_defaults = {}

--- Default handler for illuminance attribute on the illuminance measurement cluster
---
--- This converts the Uint16 value to IlluminanceMeasurement.illuminance
---
--- @param driver Driver The current driver running containing necessary context for execution
--- @param device ZigbeeDevice The device this message was received from containing identifying information
--- @param value Uint16 the value of the illuminance attribute on the illuminance measurement cluster
--- @param zb_rx ZigbeeMessageRx the full message this report came in
function illuminance_measurement_defaults.illuminance_attr_handler(driver, device, value, zb_rx)
  device:emit_event_for_endpoint(zb_rx.address_header.src_endpoint.value, capabilities.illuminanceMeasurement.illuminance(value.value))
end

illuminance_measurement_defaults.zigbee_handlers = {
  global = {},
  cluster = {},
  attr = {
    [zcl_clusters.IllumMeasurementCluster] = {
      [zcl_clusters.IllumMeasurementCluster.attributes.IllumMeasuredValue] = illuminance_measurement_defaults.illuminance_attr_handler,
    }
  }
}

illuminance_measurement_defaults.capability_handlers = {}

return illuminance_measurement_defaults
