-- DO NOT EDIT: this code is automatically generated by tools/zigbee-lib_generator/generate_clusters_from_xml.py
-- Script version: b'2cda4a8ebeb3328f48b89dd179d4e8623e7ad8f1'
-- ZCL XML version: 7.2

local command_mt = {}
command_mt.__command_cache = {}
command_mt.__index = function(self, key)
  if command_mt.__command_cache[key] == nil then
    local req_loc = string.format("st.zigbee.generated.zcl_clusters.Scenes.client.commands.%s", key)
    local raw_def = require(req_loc)
    local cluster = rawget(self, "_cluster")
    command_mt.__command_cache[key] = raw_def:set_parent_cluster(cluster)
  end
  return command_mt.__command_cache[key]
end
--- @class st.zigbee.zcl.clusters.ScenesClientCommands
---
--- @field public AddSceneResponse st.zigbee.zcl.clusters.Scenes.AddSceneResponse
--- @field public ViewSceneResponse st.zigbee.zcl.clusters.Scenes.ViewSceneResponse
--- @field public RemoveSceneResponse st.zigbee.zcl.clusters.Scenes.RemoveSceneResponse
--- @field public RemoveAllScenesResponse st.zigbee.zcl.clusters.Scenes.RemoveAllScenesResponse
--- @field public StoreSceneResponse st.zigbee.zcl.clusters.Scenes.StoreSceneResponse
--- @field public GetSceneMembershipResponse st.zigbee.zcl.clusters.Scenes.GetSceneMembershipResponse
--- @field public EnhancedAddSceneResponse st.zigbee.zcl.clusters.Scenes.EnhancedAddSceneResponse
--- @field public EnhancedViewSceneResponse st.zigbee.zcl.clusters.Scenes.EnhancedViewSceneResponse
--- @field public CopySceneResponse st.zigbee.zcl.clusters.Scenes.CopySceneResponse
local ScenesClientCommands = {}

function ScenesClientCommands:set_parent_cluster(cluster)
  self._cluster = cluster
  return self
end

setmetatable(ScenesClientCommands, command_mt)

return ScenesClientCommands
