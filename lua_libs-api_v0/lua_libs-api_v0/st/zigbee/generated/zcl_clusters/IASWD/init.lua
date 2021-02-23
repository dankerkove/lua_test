local cluster_base = require "st.zigbee.cluster_base"
local IASWDClientAttributes = require "st.zigbee.generated.zcl_clusters.IASWD.client.attributes" 
local IASWDServerAttributes = require "st.zigbee.generated.zcl_clusters.IASWD.server.attributes" 
local IASWDClientCommands = require "st.zigbee.generated.zcl_clusters.IASWD.client.commands"
local IASWDServerCommands = require "st.zigbee.generated.zcl_clusters.IASWD.server.commands"
local IASWDTypes = require "st.zigbee.generated.zcl_clusters.IASWD.types"

-- DO NOT EDIT: this code is automatically generated by tools/zigbee-lib_generator/generate_clusters_from_xml.py
-- Script version: b'2cda4a8ebeb3328f48b89dd179d4e8623e7ad8f1'
-- ZCL XML version: 7.2

--- @class st.zigbee.zcl.clusters.IASWD
--- @alias IASWD
---
--- @field public ID number 0x0502 the ID of this cluster
--- @field public NAME string "IASWD" the name of this cluster
--- @field public attributes st.zigbee.zcl.clusters.IASWDServerAttributes | st.zigbee.zcl.clusters.IASWDClientAttributes
--- @field public commands st.zigbee.zcl.clusters.IASWDServerCommands | st.zigbee.zcl.clusters.IASWDClientCommands
--- @field public types st.zigbee.zcl.clusters.IASWDTypes
local IASWD = {}

IASWD.ID = 0x0502
IASWD.NAME = "IASWD"
IASWD.server = {}
IASWD.client = {}
IASWD.server.attributes = IASWDServerAttributes:set_parent_cluster(IASWD) 
IASWD.client.attributes = IASWDClientAttributes:set_parent_cluster(IASWD) 
IASWD.server.commands = IASWDServerCommands:set_parent_cluster(IASWD)
IASWD.client.commands = IASWDClientCommands:set_parent_cluster(IASWD)
IASWD.types = IASWDTypes

--- Find an attribute by id
---
--- @param command_id number
function IASWD:get_attribute_by_id(attr_id)
  local attr_id_map = {
    [0x0000] = "MaxDuration",
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
function IASWD:get_server_command_by_id(command_id)
  local server_id_map = {
    [0x00] = "StartWarning",
    [0x01] = "Squawk",
  }
  if server_id_map[command_id] ~= nil then
    return self.server.commands[server_id_map[command_id]]
  end
  return nil
end

--- Find a client command by id
---
--- @param command_id number
function IASWD:get_client_command_by_id(command_id)
  local client_id_map = {
  }
  if client_id_map[command_id] ~= nil then
    return self.client.commands[client_id_map[command_id]]
  end
  return nil
end

IASWD.attribute_direction_map = {
  ["MaxDuration"] = "server",
}
IASWD.command_direction_map = {
  ["StartWarning"] = "server",
  ["Squawk"] = "server",
}

local attribute_helper_mt = {}
attribute_helper_mt.__index = function(self, key)
  local direction = IASWD.attribute_direction_map[key]
  if direction == nil then
    error(string.format("Referenced unknown attribute %s on cluster %s", key, IASWD.NAME))
  end
  return IASWD[direction].attributes[key] 
end
IASWD.attributes = {}
setmetatable(IASWD.attributes, attribute_helper_mt)

local command_helper_mt = {}
command_helper_mt.__index = function(self, key)
  local direction = IASWD.command_direction_map[key]
  if direction == nil then
    error(string.format("Referenced unknown command %s on cluster %s", key, IASWD.NAME))
  end
  return IASWD[direction].commands[key] 
end
IASWD.commands = {}
setmetatable(IASWD.commands, command_helper_mt)

setmetatable(IASWD, {__index = cluster_base})

return IASWD
