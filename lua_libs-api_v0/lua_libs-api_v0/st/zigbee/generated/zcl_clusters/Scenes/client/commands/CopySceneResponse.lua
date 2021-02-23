local data_types = require "st.zigbee.data_types"
local utils = require "st.zigbee.utils"
local ZclStatus = require "st.zigbee.generated.types.ZclStatus"
--- @type SGroupId
--- @alias SGroupIdType
local SGroupIdType = require "st.zigbee.generated.zcl_clusters.Scenes.types.SGroupId"

-- DO NOT EDIT: this code is automatically generated by tools/zigbee-lib_generator/generate_clusters_from_xml.py
-- Script version: b'2cda4a8ebeb3328f48b89dd179d4e8623e7ad8f1'
-- ZCL XML version: 7.2

-----------------------------------------------------------
-- Scenes command CopySceneResponse
-----------------------------------------------------------

--- @class st.zigbee.zcl.clusters.Scenes.CopySceneResponse
--- @alias CopySceneResponse
---
--- @field public ID number 0x42 the ID of this command
--- @field public NAME string "CopySceneResponse" the name of this command
--- @field public status ZclStatus
--- @field public group_identifier_from st.zigbee.zcl.clusters.Scenes.types.SGroupId
--- @field public scene_identifier_from Uint8
local CopySceneResponse = {}
CopySceneResponse.NAME = "CopySceneResponse"
CopySceneResponse.ID = 0x42
CopySceneResponse.args_def = {
  {
    name = "status",
    optional = false,
    data_type = ZclStatus,
    is_complex = false,
  },
  {
    name = "group_identifier_from",
    optional = false,
    data_type = SGroupIdType,
    is_complex = false,
    default = 0x0000,
  },
  {
    name = "scene_identifier_from",
    optional = false,
    data_type = data_types.Uint8,
    is_complex = false,
    default = 0x00,
  },
}

function CopySceneResponse:get_fields()
  local fields = {}
  for _, v in ipairs(self.args_def) do
    if self[v.name] ~= nil then
      fields[#fields + 1] = self[v.name]
    end
  end
  return fields
end

CopySceneResponse.get_length = utils.length_from_fields
CopySceneResponse.serialize = utils.serialize_from_fields
CopySceneResponse.pretty_print = utils.print_from_fields

--- Deserialize this command
---
--- @param buf buf the bytes of the command body
--- @return CopySceneResponse
function CopySceneResponse.deserialize(buf)
  local out = {}
  for _, v in ipairs(CopySceneResponse.args_def) do
    if not v.optional or buf:remain() > 0 then
      out[v.name] = v.data_type.deserialize(buf)
    end
  end
  setmetatable(out, {__index = CopySceneResponse})
  out:set_field_names()
  return out
end

function CopySceneResponse:set_field_names()
  for _, v in ipairs(self.args_def) do
    if self[v.name] ~= nil then
      self[v.name].field_name = v.name
    end
  end
end

--- Build a version of this message as if it came from the device
---
--- @param device ZigbeeDevice the device to build the message from
--- @param status ZclStatus
--- @param group_identifier_from st.zigbee.zcl.clusters.Scenes.types.SGroupId
--- @param scene_identifier_from Uint8
--- @return ZigbeeMessageRx The full Zigbee message containing this command body
function CopySceneResponse.build_test_rx(device, status, group_identifier_from, scene_identifier_from)
  local out = {}
  local args = {status, group_identifier_from, scene_identifier_from}
  for i,v in ipairs(CopySceneResponse.args_def) do
    if v.optional and args[i] == nil then
      out[v.name] = nil
    elseif not v.optional and args[i] == nil then
      out[v.name] = data_types.validate_or_build_type(v.default, v.data_type, v.name)   
    else
      out[v.name] = data_types.validate_or_build_type(args[i], v.data_type, v.name)
    end
  end
  setmetatable(out, {__index = CopySceneResponse})
  out:set_field_names()
  return CopySceneResponse._cluster:build_test_rx_cluster_specific_command(device, out, "client")
end

--- Initialize the CopySceneResponse command
---
--- @param self CopySceneResponse the template class for this command
--- @param device ZigbeeDevice the device to build this message to
--- @param status ZclStatus
--- @param group_identifier_from st.zigbee.zcl.clusters.Scenes.types.SGroupId
--- @param scene_identifier_from Uint8
--- @return ZigbeeMessageTx the full command addressed to the device
function CopySceneResponse:init(device, status, group_identifier_from, scene_identifier_from)
  local out = {}
  local args = {status, group_identifier_from, scene_identifier_from}
  if #args > #self.args_def then
    error(self.NAME .. " received too many arguments")
  end
  for i,v in ipairs(self.args_def) do
    if v.optional and args[i] == nil then
      out[v.name] = nil
    elseif not v.optional and args[i] == nil then
      out[v.name] = data_types.validate_or_build_type(v.default, v.data_type, v.name)   
    else
      out[v.name] = data_types.validate_or_build_type(args[i], v.data_type, v.name)
    end
  end
  setmetatable(out, {
    __index = CopySceneResponse,
    __tostring = CopySceneResponse.pretty_print
  })
  out:set_field_names()
  return self._cluster:build_cluster_specific_command(device, out, "client")
end

function CopySceneResponse:set_parent_cluster(cluster)
  self._cluster = cluster
  return self
end

setmetatable(CopySceneResponse, {__call = CopySceneResponse.init})

return CopySceneResponse
