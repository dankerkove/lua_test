local zcl_clusters = require "st.zigbee.zcl.clusters"
local capabilities = require "st.capabilities"

--- @class st.zigbee.defaults.occupancySensor
--- @field public zigbee_handlers table
--- @field public attribute_configurations table
--- @field public capability_handlers table
local occupancy_sensor_defaults = {}

--- Default handler for occupancy attribute on the occupancy sensing cluster
---
--- This converts the Bitmap8 value of the occupancy attribute to OccupancySensor.occupancy occupied if bit 1 is set
--- unoccupied otherwise
---
--- @param driver ZigbeeDriver The current driver running containing necessary context for execution
--- @param device ZigbeeDevice The device this message was received from containing identifying information
--- @param value Bitmap8 the value of the occupancy attribute on the OccupancySensing cluster
--- @param zb_rx ZigbeeMessageRx the full message this report came in
function occupancy_sensor_defaults.occupancy_attr_handler(driver, device, value, zb_rx)
  local attr = capabilities.occupancySensor.occupancy
  device:emit_event_for_endpoint(zb_rx.address_header.src_endpoint.value, ((value.value & 0x01) ~= 0) and attr.occupied() or attr.unoccupied())
end

occupancy_sensor_defaults.zigbee_handlers = {
  global = {},
  cluster = {},
  attr = {
    [zcl_clusters.OccupancySensing] = {
      [zcl_clusters.OccupancySensing.attributes.Occupancy] = occupancy_sensor_defaults.occupancy_attr_handler,
    }
  }
}
occupancy_sensor_defaults.capability_handlers = {}

return occupancy_sensor_defaults
