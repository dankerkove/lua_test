local cluster_base = require "st.zigbee.cluster_base"
local WindowCoveringClientAttributes = require "st.zigbee.generated.zcl_clusters.WindowCovering.client.attributes" 
local WindowCoveringServerAttributes = require "st.zigbee.generated.zcl_clusters.WindowCovering.server.attributes" 
local WindowCoveringClientCommands = require "st.zigbee.generated.zcl_clusters.WindowCovering.client.commands"
local WindowCoveringServerCommands = require "st.zigbee.generated.zcl_clusters.WindowCovering.server.commands"
local WindowCoveringTypes = require "st.zigbee.generated.zcl_clusters.WindowCovering.types"

-- DO NOT EDIT: this code is automatically generated by tools/zigbee-lib_generator/generate_clusters_from_xml.py
-- Script version: b'2cda4a8ebeb3328f48b89dd179d4e8623e7ad8f1'
-- ZCL XML version: 7.2

--- @class st.zigbee.zcl.clusters.WindowCovering
--- @alias WindowCovering
---
--- @field public ID number 0x0102 the ID of this cluster
--- @field public NAME string "WindowCovering" the name of this cluster
--- @field public attributes st.zigbee.zcl.clusters.WindowCoveringServerAttributes | st.zigbee.zcl.clusters.WindowCoveringClientAttributes
--- @field public commands st.zigbee.zcl.clusters.WindowCoveringServerCommands | st.zigbee.zcl.clusters.WindowCoveringClientCommands
--- @field public types st.zigbee.zcl.clusters.WindowCoveringTypes
local WindowCovering = {}

WindowCovering.ID = 0x0102
WindowCovering.NAME = "WindowCovering"
WindowCovering.server = {}
WindowCovering.client = {}
WindowCovering.server.attributes = WindowCoveringServerAttributes:set_parent_cluster(WindowCovering) 
WindowCovering.client.attributes = WindowCoveringClientAttributes:set_parent_cluster(WindowCovering) 
WindowCovering.server.commands = WindowCoveringServerCommands:set_parent_cluster(WindowCovering)
WindowCovering.client.commands = WindowCoveringClientCommands:set_parent_cluster(WindowCovering)
WindowCovering.types = WindowCoveringTypes

--- Find an attribute by id
---
--- @param command_id number
function WindowCovering:get_attribute_by_id(attr_id)
  local attr_id_map = {
    [0x0000] = "WindowCoveringType",
    [0x0001] = "PhysicalClosedLimitLift",
    [0x0002] = "PhysicalClosedLimitTilt",
    [0x0003] = "CurrentPositionLift",
    [0x0004] = "CurrentPositionTilt",
    [0x0005] = "NumberOfActuationsLift",
    [0x0006] = "NumberOfActuationsTilt",
    [0x0007] = "ConfigOrStatus",
    [0x0008] = "CurrentPositionLiftPercentage",
    [0x0009] = "CurrentPositionTiltPercentage",
    [0x0010] = "InstalledOpenLimitLift",
    [0x0011] = "InstalledClosedLimitLift",
    [0x0012] = "InstalledOpenLimitTilt",
    [0x0013] = "InstalledClosedLimitTilt",
    [0x0014] = "VelocityLift",
    [0x0015] = "AccelerationTimeLift",
    [0x0016] = "DecelerationTimeLift",
    [0x0017] = "Mode",
    [0x0018] = "IntermediateSetpointsLift",
    [0x0019] = "IntermediateSetpointsTilt",
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
function WindowCovering:get_server_command_by_id(command_id)
  local server_id_map = {
    [0x00] = "UpOrOpen",
    [0x01] = "DownOrClose",
    [0x02] = "Stop",
    [0x04] = "GoToLiftValue",
    [0x05] = "GoToLiftPercentage",
    [0x07] = "GoToTiltValue",
    [0x08] = "GoToTiltPercentage",
  }
  if server_id_map[command_id] ~= nil then
    return self.server.commands[server_id_map[command_id]]
  end
  return nil
end

--- Find a client command by id
---
--- @param command_id number
function WindowCovering:get_client_command_by_id(command_id)
  local client_id_map = {
  }
  if client_id_map[command_id] ~= nil then
    return self.client.commands[client_id_map[command_id]]
  end
  return nil
end

WindowCovering.attribute_direction_map = {
  ["WindowCoveringType"] = "server",
  ["PhysicalClosedLimitLift"] = "server",
  ["PhysicalClosedLimitTilt"] = "server",
  ["CurrentPositionLift"] = "server",
  ["CurrentPositionTilt"] = "server",
  ["NumberOfActuationsLift"] = "server",
  ["NumberOfActuationsTilt"] = "server",
  ["ConfigOrStatus"] = "server",
  ["CurrentPositionLiftPercentage"] = "server",
  ["CurrentPositionTiltPercentage"] = "server",
  ["InstalledOpenLimitLift"] = "server",
  ["InstalledClosedLimitLift"] = "server",
  ["InstalledOpenLimitTilt"] = "server",
  ["InstalledClosedLimitTilt"] = "server",
  ["VelocityLift"] = "server",
  ["AccelerationTimeLift"] = "server",
  ["DecelerationTimeLift"] = "server",
  ["Mode"] = "server",
  ["IntermediateSetpointsLift"] = "server",
  ["IntermediateSetpointsTilt"] = "server",
}
WindowCovering.command_direction_map = {
  ["UpOrOpen"] = "server",
  ["DownOrClose"] = "server",
  ["Stop"] = "server",
  ["GoToLiftValue"] = "server",
  ["GoToLiftPercentage"] = "server",
  ["GoToTiltValue"] = "server",
  ["GoToTiltPercentage"] = "server",
}

local attribute_helper_mt = {}
attribute_helper_mt.__index = function(self, key)
  local direction = WindowCovering.attribute_direction_map[key]
  if direction == nil then
    error(string.format("Referenced unknown attribute %s on cluster %s", key, WindowCovering.NAME))
  end
  return WindowCovering[direction].attributes[key] 
end
WindowCovering.attributes = {}
setmetatable(WindowCovering.attributes, attribute_helper_mt)

local command_helper_mt = {}
command_helper_mt.__index = function(self, key)
  local direction = WindowCovering.command_direction_map[key]
  if direction == nil then
    error(string.format("Referenced unknown command %s on cluster %s", key, WindowCovering.NAME))
  end
  return WindowCovering[direction].commands[key] 
end
WindowCovering.commands = {}
setmetatable(WindowCovering.commands, command_helper_mt)

setmetatable(WindowCovering, {__index = cluster_base})

return WindowCovering
