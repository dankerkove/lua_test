local cluster_base = require "st.zigbee.cluster_base"
local DeviceTemperatureConfigurationClientAttributes = require "st.zigbee.generated.zcl_clusters.DeviceTemperatureConfiguration.client.attributes" 
local DeviceTemperatureConfigurationServerAttributes = require "st.zigbee.generated.zcl_clusters.DeviceTemperatureConfiguration.server.attributes" 
local DeviceTemperatureConfigurationClientCommands = require "st.zigbee.generated.zcl_clusters.DeviceTemperatureConfiguration.client.commands"
local DeviceTemperatureConfigurationServerCommands = require "st.zigbee.generated.zcl_clusters.DeviceTemperatureConfiguration.server.commands"
local DeviceTemperatureConfigurationTypes = require "st.zigbee.generated.zcl_clusters.DeviceTemperatureConfiguration.types"

-- DO NOT EDIT: this code is automatically generated by tools/zigbee-lib_generator/generate_clusters_from_xml.py
-- Script version: b'2cda4a8ebeb3328f48b89dd179d4e8623e7ad8f1'
-- ZCL XML version: 7.2

--- @class st.zigbee.zcl.clusters.DeviceTemperatureConfiguration
--- @alias DeviceTemperatureConfiguration
---
--- @field public ID number 0x0002 the ID of this cluster
--- @field public NAME string "DeviceTemperatureConfiguration" the name of this cluster
--- @field public attributes st.zigbee.zcl.clusters.DeviceTemperatureConfigurationServerAttributes | st.zigbee.zcl.clusters.DeviceTemperatureConfigurationClientAttributes
--- @field public commands st.zigbee.zcl.clusters.DeviceTemperatureConfigurationServerCommands | st.zigbee.zcl.clusters.DeviceTemperatureConfigurationClientCommands
--- @field public types st.zigbee.zcl.clusters.DeviceTemperatureConfigurationTypes
local DeviceTemperatureConfiguration = {}

DeviceTemperatureConfiguration.ID = 0x0002
DeviceTemperatureConfiguration.NAME = "DeviceTemperatureConfiguration"
DeviceTemperatureConfiguration.server = {}
DeviceTemperatureConfiguration.client = {}
DeviceTemperatureConfiguration.server.attributes = DeviceTemperatureConfigurationServerAttributes:set_parent_cluster(DeviceTemperatureConfiguration) 
DeviceTemperatureConfiguration.client.attributes = DeviceTemperatureConfigurationClientAttributes:set_parent_cluster(DeviceTemperatureConfiguration) 
DeviceTemperatureConfiguration.server.commands = DeviceTemperatureConfigurationServerCommands:set_parent_cluster(DeviceTemperatureConfiguration)
DeviceTemperatureConfiguration.client.commands = DeviceTemperatureConfigurationClientCommands:set_parent_cluster(DeviceTemperatureConfiguration)
DeviceTemperatureConfiguration.types = DeviceTemperatureConfigurationTypes

--- Find an attribute by id
---
--- @param command_id number
function DeviceTemperatureConfiguration:get_attribute_by_id(attr_id)
  local attr_id_map = {
    [0x0000] = "CurrentTemperature",
    [0x0001] = "MinTempExperienced",
    [0x0002] = "MaxTempExperienced",
    [0x0003] = "OverTempTotalDwell",
    [0x0010] = "DeviceTempAlarmMask",
    [0x0011] = "LowTempThreshold",
    [0x0012] = "HighTempThreshold",
    [0x0013] = "LowTempDwellTripPoint",
    [0x0014] = "HighTempDwellTripPoint",
  }
  local attr_name = attr_id_map[attr_id]
  if attr_name ~= nil then
    return self.attributes[attr_name]
  end
  return nil
end
  
--- Find a server command by id
---
--- @param command_id number
function DeviceTemperatureConfiguration:get_server_command_by_id(command_id)
  local server_id_map = {
  }
  if server_id_map[command_id] ~= nil then
    return self.server.commands[server_id_map[command_id]]
  end
  return nil
end

--- Find a client command by id
---
--- @param command_id number
function DeviceTemperatureConfiguration:get_client_command_by_id(command_id)
  local client_id_map = {
  }
  if client_id_map[command_id] ~= nil then
    return self.client.commands[client_id_map[command_id]]
  end
  return nil
end

DeviceTemperatureConfiguration.attribute_direction_map = {
  ["CurrentTemperature"] = "server",
  ["MinTempExperienced"] = "server",
  ["MaxTempExperienced"] = "server",
  ["OverTempTotalDwell"] = "server",
  ["DeviceTempAlarmMask"] = "server",
  ["LowTempThreshold"] = "server",
  ["HighTempThreshold"] = "server",
  ["LowTempDwellTripPoint"] = "server",
  ["HighTempDwellTripPoint"] = "server",
}
DeviceTemperatureConfiguration.command_direction_map = {}

local attribute_helper_mt = {}
attribute_helper_mt.__index = function(self, key)
  local direction = DeviceTemperatureConfiguration.attribute_direction_map[key]
  if direction == nil then
    error(string.format("Referenced unknown attribute %s on cluster %s", key, DeviceTemperatureConfiguration.NAME))
  end
  return DeviceTemperatureConfiguration[direction].attributes[key] 
end
DeviceTemperatureConfiguration.attributes = {}
setmetatable(DeviceTemperatureConfiguration.attributes, attribute_helper_mt)

local command_helper_mt = {}
command_helper_mt.__index = function(self, key)
  local direction = DeviceTemperatureConfiguration.command_direction_map[key]
  if direction == nil then
    error(string.format("Referenced unknown command %s on cluster %s", key, DeviceTemperatureConfiguration.NAME))
  end
  return DeviceTemperatureConfiguration[direction].commands[key] 
end
DeviceTemperatureConfiguration.commands = {}
setmetatable(DeviceTemperatureConfiguration.commands, command_helper_mt)

setmetatable(DeviceTemperatureConfiguration, {__index = cluster_base})

return DeviceTemperatureConfiguration
