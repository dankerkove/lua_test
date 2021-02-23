local zcl_clusters = require "st.zigbee.zcl.clusters"
local capabilities = require "st.capabilities"

--- @class st.zigbee.defaults.soundSensor
--- @field public zigbee_handlers table
--- @field public attribute_configurations table
--- @field public default_ias_zone_configuration st.zigbee.defaults.soundSensor.IASZoneConfiguration
local soundSensor_defaults = {}

local generate_event_from_zone_status = function(driver, device, zone_status, zb_rx)
    device:emit_event_for_endpoint(
      zb_rx.address_header.src_endpoint.value,
      (zone_status:is_alarm1_set() or zone_status:is_alarm2_set()) and capabilities.soundSensor.sound.detected() or capabilities.soundSensor.sound.not_detected())
end

--- Default handler for zoneStatus attribute on the IAS Zone cluster
---
--- This converts the 2 byte bitmap value to soundSensor.sound."detected" or soundSensor.sound."not detected"
---
--- @param driver ZigbeeDriver The current driver running containing necessary context for execution
--- @param device ZigbeeDevice The device this message was received from containing identifying information
--- @param zone_status IasZoneStatusBitmap 2 byte bitmap zoneStatus attribute value of the IAS Zone cluster
--- @param zb_rx ZigbeeMessageRx the full message this report came in
function soundSensor_defaults.ias_zone_status_attr_handler(driver, device, zone_status, zb_rx)
    generate_event_from_zone_status(driver, device, zone_status, zb_rx)
end

--- Default handler for zoneStatus change handler
---
--- This converts the 2 byte bitmap value to soundSensor.sound."detected" or soundSensor.sound."not detected"
---
--- @param driver ZigbeeDriver The current driver running containing necessary context for execution
--- @param device ZigbeeDevice The device this message was received from containing identifying information
--- @param zb_rx ZigbeeMessageRx the full message containing the ZoneStatusChangeNotification cluster command as the zb_rx.body.zcl_body
function soundSensor_defaults.ias_zone_status_change_handler(driver, device, zb_rx)
    generate_event_from_zone_status(driver, device, zb_rx.body.zcl_body.zone_status, zb_rx)
end

soundSensor_defaults.zigbee_handlers = {
    cluster = {
      [zcl_clusters.IASZone.ID] = {
        [zcl_clusters.IASZone.client.commands.ZoneStatusChangeNotification.ID] = soundSensor_defaults.ias_zone_status_change_handler
      }
    },
    attr = {
      [zcl_clusters.IASZone.ID] = {
        [zcl_clusters.IASZone.attributes.ZoneStatus.ID] = soundSensor_defaults.ias_zone_status_attr_handler
      }
    }
}

--- @class st.zigbee.defaults.soundSensor.IASZoneConfiguration
--- @field public cluster number IASZone ID 0x0500
--- @field public attribute number ZoneStatus ID 0x0002
--- @field public minimum_interval number 30 seconds
--- @field public maximum_interval number 300 seconds (5 min)
--- @field public data_type st.zigbee.zcl.types.IasZoneStatus the ZoneStatus type class
local ias_zone_configuration = {
  cluster = zcl_clusters.IASZone.ID,
  attribute = zcl_clusters.IASZone.attributes.ZoneStatus.ID,
  minimum_interval = 30,
  maximum_interval = 300,
  data_type = zcl_clusters.IASZone.attributes.ZoneStatus.base_type,
}

soundSensor_defaults.default_ias_zone_configuration = ias_zone_configuration

soundSensor_defaults.attribute_configurations = {
  ias_zone_configuration
}

return soundSensor_defaults
