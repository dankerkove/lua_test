local zcl_clusters = require "st.zigbee.zcl.clusters"
local capabilities = require "st.capabilities"
local switch_defaults = require "st.zigbee.defaults.switch_defaults"
local data_types = require "st.zigbee.data_types"

--- @class st.zigbee.defaults.colorTemperature
--- @field public zigbee_handlers table
--- @field public attribute_configurations table
--- @field public capability_handlers table
--- @field public default_color_temp_config st.zigbee.defaults.colorTemperature.ColorTemperatureConfiguration
local color_temperature_defaults = {}

--- Default handler for the color temperature attribute on the color control cluster
---
--- This converts the Uint16 value of the color temperature attribute on the color control cluster to
--- ColorTemperature.colorTemperature
---
--- @param driver ZigbeeDriver The current driver running containing necessary context for execution
--- @param device ZigbeeDevice The device this message was received from containing identifying information
--- @param value Uint16 the color temperature value
--- @param zb_rx ZigbeeMessageRx the full message this report came in
function color_temperature_defaults.color_temperature_handler(driver, device, value, zb_rx)
  local temp_in_mired = value.value
  local temp_in_kelvin = 1000000 / temp_in_mired
  device:emit_event_for_endpoint(zb_rx.address_header.src_endpoint.value, capabilities.colorTemperature.colorTemperature(math.floor(temp_in_kelvin)))
end

--- Default handler for the ColorTemperature.setColorTemperature command
---
--- This will send the move to color temperature command to the color control cluster
---
--- @param driver ZigbeeDriver The current driver running containing necessary context for execution
--- @param device ZigbeeDevice The device this message was received from containing identifying information
--- @param command CapabilityCommand The capability command table
function color_temperature_defaults.set_color_temperature(driver, device, command)
  switch_defaults.on(driver, device, command)
  local temp_in_mired = math.floor(1000000 / command.args.temperature)
  device:send_to_component(command.component, zcl_clusters.ColorControl.server.commands.MoveToColorTemperature(device, temp_in_mired, 0x0000))
end

color_temperature_defaults.zigbee_handlers = {
  global = {},
  cluster = {},
  attr = {
    [zcl_clusters.ColorControl] = {
      [zcl_clusters.ColorControl.attributes.ColorTemperatureMireds] = color_temperature_defaults.color_temperature_handler
    }
  }
}
color_temperature_defaults.capability_handlers = {
  [capabilities.colorTemperature.commands.setColorTemperature] = color_temperature_defaults.set_color_temperature
}

--- @class st.zigbee.defaults.colorTemperature.ColorTemperatureConfiguration
--- @field public cluster number ColorControl ID 0x0300
--- @field public attribute number ColorTemperatureMireds ID 0x0020
--- @field public minimum_interval number 1 second
--- @field public maximum_interval number 3600 seconds (1 hour)
--- @field public data_type Uint16 the data type class of this attribute
--- @field public reportable_change number 16 ()
local default_color_temp_config = {
  cluster = zcl_clusters.ColorControl.ID,
  attribute = zcl_clusters.ColorControl.attributes.ColorTemperatureMireds.ID,
  minimum_interval = 1,
  maximum_interval = 3600,
  data_type = data_types.Uint16,
  reportable_change = 16
}

color_temperature_defaults.default_color_temp_config = default_color_temp_config

color_temperature_defaults.attribute_configurations = {
  default_color_temp_config
}

return color_temperature_defaults
