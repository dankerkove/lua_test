local zcl_clusters = require "st.zigbee.zcl.clusters"
local capabilities = require "st.capabilities"

--- @class st.zigbee.defaults.switch
--- @field public zigbee_handlers table
--- @field public attribute_configurations table
--- @field public capability_handlers table
--- @field public default_on_off_configuration st.zigbee.defaults.switch.OnOffConfiguration
local switch_defaults = {}

--- Default handler for on off attribute on the on off cluster
---
--- This converts the boolean value from true -> Switch.switch.on and false to Switch.switch.off.
---
--- @param driver ZigbeeDriver The current driver running containing necessary context for execution
--- @param device ZigbeeDevice The device this message was received from containing identifying information
--- @param value Boolean the value of the On Off cluster On Off attribute
--- @param zb_rx ZigbeeMessageRx the full message this report came in
function switch_defaults.on_off_attr_handler(driver, device, value, zb_rx)
  local attr = capabilities.switch.switch
  device:emit_event_for_endpoint(zb_rx.address_header.src_endpoint.value, value.value and attr.on() or attr.off())
end

--- Default handler for the Switch.on command
---
--- This will send the on command to the on off cluster
---
--- @param driver ZigbeeDriver The current driver running containing necessary context for execution
--- @param device ZigbeeDevice The device this message was received from containing identifying information
--- @param command CapabilityCommand The capability command table
function switch_defaults.on(driver, device, command)
  device:send_to_component(command.component, zcl_clusters.OnOff.server.commands.On(device))
end

--- Default handler for the Switch.off command
---
--- This will send the off command to the on off cluster
---
--- @param driver ZigbeeDriver The current driver running containing necessary context for execution
--- @param device ZigbeeDevice The device this message was received from containing identifying information
--- @param command CapabilityCommand The capability command table
function switch_defaults.off(driver, device, command)
  device:send_to_component(command.component, zcl_clusters.OnOff.server.commands.Off(device))
end


switch_defaults.zigbee_handlers = {
  global = {},
  cluster = {},
  attr = {
    [zcl_clusters.OnOff] = {
      [zcl_clusters.OnOff.attributes.OnOff] = switch_defaults.on_off_attr_handler
    }
  }
}
switch_defaults.capability_handlers = {
  [capabilities.switch.commands.on] = switch_defaults.on,
  [capabilities.switch.commands.off] = switch_defaults.off
}

--- @class st.zigbee.defaults.switch.OnOffConfiguration
--- @field public cluster number On/Off cluster ID 0x0006
--- @field public attribute number On/Off attribute ID 0x0000
--- @field public minimum_interval number 0 seconds
--- @field public maximum_interval number 300 seconds (5 mins)
--- @field public data_type Boolean the Boolean class
local on_off_configuration =   {
  cluster = zcl_clusters.OnOff.ID,
  attribute = zcl_clusters.OnOff.attributes.OnOff.ID,
  minimum_interval = 0,
  maximum_interval = 300,
  data_type = zcl_clusters.OnOff.attributes.OnOff.base_type
}

switch_defaults.default_on_off_configuration = on_off_configuration

switch_defaults.attribute_configurations = {
  on_off_configuration
}

return switch_defaults
