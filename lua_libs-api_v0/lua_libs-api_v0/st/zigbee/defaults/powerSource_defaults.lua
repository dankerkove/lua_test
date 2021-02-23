local zcl_clusters = require "st.zigbee.zcl.clusters"
local capabilities = require "st.capabilities"

--- @class st.zigbee.defaults.powerSource
--- @field public zigbee_handlers table
--- @field public attribute_configurations table
--- @field public capability_handlers table
local powerSource_defaults = {}

--- Default handler for power source attribute on the basic cluster
---
--- This converts the power source value to the appropriate value
---
--- @param driver ZigbeeDriver The current driver running containing necessary context for execution
--- @param device ZigbeeDevice The device this message was received from containing identifying information
--- @param value st.zigbee.zcl.clusters.Basic.PowerSource  the value of the Basic cluster Power Source attribute
--- @param zb_rx ZigbeeMessageRx the full message this report came in
function powerSource_defaults.power_source_attr_handler(driver, device, value, zb_rx)
  local PowerSource = require "st.zigbee.generated.zcl_clusters.Basic.server.attributes.PowerSource"
  local POWER_SOURCE_MAP = {
    [PowerSource.UNKNOWN] =             capabilities.powerSource.powerSource.unknown,
    [PowerSource.SINGLE_PHASE_MAINS] =  capabilities.powerSource.powerSource.mains,
    [PowerSource.BATTERY] =             capabilities.powerSource.powerSource.battery,
    [PowerSource.DC_SOURCE] =           capabilities.powerSource.powerSource.dc
  }

  if POWER_SOURCE_MAP[value.value] then
    device:emit_event_for_endpoint(zb_rx.address_header.src_endpoint.value, POWER_SOURCE_MAP[value.value]())
  end
end

powerSource_defaults.zigbee_handlers = {
  global = {},
  cluster = {},
  attr = {
    [zcl_clusters.Basic.ID] = {
      [zcl_clusters.Basic.attributes.PowerSource.ID] = powerSource_defaults.power_source_attr_handler
    }
  }
}

return powerSource_defaults
