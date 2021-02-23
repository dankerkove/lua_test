local zcl_clusters = require "st.zigbee.zcl.clusters"
local capabilities = require "st.capabilities"

--- @class st.zigbee.defaults.valve
--- @field public zigbee_handlers table
--- @field public attribute_configurations table
--- @field public capability_handlers table
--- @field public default_on_off_configuration st.zigbee.defaults.valve.OnOffConfiguration
local valve_defaults = {}

--- Default handler for on off attribute on the on off cluster
---
--- This converts the boolean value from true -> Valve.valve.on and false to Valve.valve.off.
---
--- @param driver ZigbeeDriver The current driver running containing necessary context for execution
--- @param device ZigbeeDevice The device this message was received from containing identifying information
--- @param value Boolean the value of the On Off cluster On Off attribute
--- @param zb_rx ZigbeeMessageRx the full message this report came in
function valve_defaults.on_off_attr_handler(driver, device, value, zb_rx)
  local attr = capabilities.valve.valve
  device:emit_event_for_endpoint(zb_rx.address_header.src_endpoint.value, value.value and attr.open() or attr.closed())
end

--- Default handler for the Valve.open command
---
--- This will send the on command to the on off cluster
---
--- @param driver ZigbeeDriver The current driver running containing necessary context for execution
--- @param device ZigbeeDevice The device this message was received from containing identifying information
--- @param command table The capability command table
function valve_defaults.open(driver, device, command)
  device:send_to_component(command.component, zcl_clusters.OnOff.server.commands.On(device))
end

--- Default handler for the Valve.close command
---
--- This will send the on command to the on off cluster
---
--- @param driver ZigbeeDriver The current driver running containing necessary context for execution
--- @param device ZigbeeDevice The device this message was received from containing identifying information
--- @param command table The capability command table
function valve_defaults.close(driver, device, command)
  device:send_to_component(command.component, zcl_clusters.OnOff.server.commands.Off(device))
end

valve_defaults.zigbee_handlers = {
  attr = {
    [zcl_clusters.OnOff.ID] = {
      [zcl_clusters.OnOff.attributes.OnOff.ID] = valve_defaults.on_off_attr_handler
    }
  }
}

valve_defaults.capability_handlers = {
  [capabilities.valve.commands.open] = valve_defaults.open,
  [capabilities.valve.commands.close] = valve_defaults.close
}

--- @class st.zigbee.defaults.valve.OnOffConfiguration
--- @field public cluster number OnOff cluster ID 0x0006
--- @field public attribute number OnOff attribute ID 0x0000
--- @field public minimum_interval number 0 seconds
--- @field public maximum_interval number 600 seconds (10 min)
--- @field public data_type Boolean the Boolean class
local on_off_configuration =   {
  cluster = zcl_clusters.OnOff.ID,
  attribute = zcl_clusters.OnOff.attributes.OnOff.ID,
  minimum_interval = 0,
  maximum_interval = 600,
  data_type = zcl_clusters.OnOff.attributes.OnOff.base_type,
}

valve_defaults.default_on_off_configuration = on_off_configuration

valve_defaults.attribute_configurations = {
  on_off_configuration
}

return valve_defaults
