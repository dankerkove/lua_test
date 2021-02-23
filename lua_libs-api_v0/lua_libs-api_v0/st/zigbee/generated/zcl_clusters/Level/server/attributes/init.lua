-- DO NOT EDIT: this code is automatically generated by tools/zigbee-lib_generator/generate_clusters_from_xml.py
-- Script version: b'2cda4a8ebeb3328f48b89dd179d4e8623e7ad8f1'
-- ZCL XML version: 7.2

local attr_mt = {}
attr_mt.__attr_cache = {}
attr_mt.__index = function(self, key)
  if attr_mt.__attr_cache[key] == nil then
    local req_loc = string.format("st.zigbee.generated.zcl_clusters.Level.server.attributes.%s", key)
    local raw_def = require(req_loc)
    local cluster = rawget(self, "_cluster")
    raw_def:set_parent_cluster(cluster)
    attr_mt.__attr_cache[key] = raw_def 
  end
  return attr_mt.__attr_cache[key]
end


--- @class st.zigbee.zcl.clusters.LevelServerAttributes
---
--- @field public CurrentLevel st.zigbee.zcl.clusters.Level.CurrentLevel
--- @field public RemainingTime st.zigbee.zcl.clusters.Level.RemainingTime
--- @field public MinLevel st.zigbee.zcl.clusters.Level.MinLevel
--- @field public MaxLevel st.zigbee.zcl.clusters.Level.MaxLevel
--- @field public CurrentFrequency st.zigbee.zcl.clusters.Level.CurrentFrequency
--- @field public MinFrequency st.zigbee.zcl.clusters.Level.MinFrequency
--- @field public MaxFrequency st.zigbee.zcl.clusters.Level.MaxFrequency
--- @field public OnOffTransitionTime st.zigbee.zcl.clusters.Level.OnOffTransitionTime
--- @field public OnLevel st.zigbee.zcl.clusters.Level.OnLevel
--- @field public OnTransitionTime st.zigbee.zcl.clusters.Level.OnTransitionTime
--- @field public OffTransitionTime st.zigbee.zcl.clusters.Level.OffTransitionTime
--- @field public DefaultMoveRate st.zigbee.zcl.clusters.Level.DefaultMoveRate
--- @field public Options st.zigbee.zcl.clusters.Level.Options
--- @field public StartUpCurrentLevel st.zigbee.zcl.clusters.Level.StartUpCurrentLevel

local LevelServerAttributes = {}

function LevelServerAttributes:set_parent_cluster(cluster)
  self._cluster = cluster
  return self
end

setmetatable(LevelServerAttributes, attr_mt)

return LevelServerAttributes
