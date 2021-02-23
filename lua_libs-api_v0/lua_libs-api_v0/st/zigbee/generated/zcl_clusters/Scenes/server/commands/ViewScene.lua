local data_types = require "st.zigbee.data_types"
local utils = require "st.zigbee.utils"
--- @type SGroupId
--- @alias SGroupIdType
local SGroupIdType = require "st.zigbee.generated.zcl_clusters.Scenes.types.SGroupId"

-- DO NOT EDIT: this code is automatically generated by tools/zigbee-lib_generator/generate_clusters_from_xml.py
-- Script version: b'2cda4a8ebeb3328f48b89dd179d4e8623e7ad8f1'
-- ZCL XML version: 7.2

-----------------------------------------------------------
-- Scenes command ViewScene
-----------------------------------------------------------

--- @class st.zigbee.zcl.clusters.Scenes.ViewScene
--- @alias ViewScene
---
--- @field public ID number 0x01 the ID of this command
--- @field public NAME string "ViewScene" the name of this command
--- @field public group_id st.zigbee.zcl.clusters.Scenes.types.SGroupId
--- @field public scene_id Uint8
local ViewScene = {}
ViewScene.NAME = "ViewScene"
ViewScene.ID = 0x01
ViewScene.args_def = {
  {
    name = "group_id",
    optional = false,
    data_type = SGroupIdType,
    is_complex = false,
    default = 0x0000,
  },
  {
    name = "scene_id",
    optional = false,
    data_type = data_types.Uint8,
    is_complex = false,
    default = 0x00,
  },
}

function ViewScene:get_fields()
  local fields = {}
  for _, v in ipairs(self.args_def) do
    if self[v.name] ~= nil then
      fields[#fields + 1] = self[v.name]
    end
  end
  return fields
end

ViewScene.get_length = utils.length_from_fields
ViewScene.serialize = utils.serialize_from_fields
ViewScene.pretty_print = utils.print_from_fields

--- Deserialize this command
---
--- @param buf buf the bytes of the command body
--- @return ViewScene
function ViewScene.deserialize(buf)
  local out = {}
  for _, v in ipairs(ViewScene.args_def) do
    if not v.optional or buf:remain() > 0 then
      out[v.name] = v.data_type.deserialize(buf)
    end
  end
  setmetatable(out, {__index = ViewScene})
  out:set_field_names()
  return out
end

function ViewScene:set_field_names()
  for _, v in ipairs(self.args_def) do
    if self[v.name] ~= nil then
      self[v.name].field_name = v.name
    end
  end
end

--- Build a version of this message as if it came from the device
---
--- @param device ZigbeeDevice the device to build the message from
--- @param group_id st.zigbee.zcl.clusters.Scenes.types.SGroupId
--- @param scene_id Uint8
--- @return ZigbeeMessageRx The full Zigbee message containing this command body
function ViewScene.build_test_rx(device, group_id, scene_id)
  local out = {}
  local args = {group_id, scene_id}
  for i,v in ipairs(ViewScene.args_def) do
    if v.optional and args[i] == nil then
      out[v.name] = nil
    elseif not v.optional and args[i] == nil then
      out[v.name] = data_types.validate_or_build_type(v.default, v.data_type, v.name)   
    else
      out[v.name] = data_types.validate_or_build_type(args[i], v.data_type, v.name)
    end
  end
  setmetatable(out, {__index = ViewScene})
  out:set_field_names()
  return ViewScene._cluster:build_test_rx_cluster_specific_command(device, out, "server")
end

--- Initialize the ViewScene command
---
--- @param self ViewScene the template class for this command
--- @param device ZigbeeDevice the device to build this message to
--- @param group_id st.zigbee.zcl.clusters.Scenes.types.SGroupId
--- @param scene_id Uint8
--- @return ZigbeeMessageTx the full command addressed to the device
function ViewScene:init(device, group_id, scene_id)
  local out = {}
  local args = {group_id, scene_id}
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
    __index = ViewScene,
    __tostring = ViewScene.pretty_print
  })
  out:set_field_names()
  return self._cluster:build_cluster_specific_command(device, out, "server")
end

function ViewScene:set_parent_cluster(cluster)
  self._cluster = cluster
  return self
end

setmetatable(ViewScene, {__call = ViewScene.init})

return ViewScene
