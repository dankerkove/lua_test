-- DO NOT EDIT: this code is automatically generated by tools/zigbee-lib_generator/generate_clusters_from_xml.py
-- Script version: b'2cda4a8ebeb3328f48b89dd179d4e8623e7ad8f1'
-- ZCL XML version: 7.2

local attr_mt = {}
attr_mt.__attr_cache = {}
attr_mt.__index = function(self, key)
  if attr_mt.__attr_cache[key] == nil then
    local req_loc = string.format("st.zigbee.generated.zcl_clusters.IASACE.client.attributes.%s", key)
    local raw_def = require(req_loc)
    local cluster = rawget(self, "_cluster")
    raw_def:set_parent_cluster(cluster)
    attr_mt.__attr_cache[key] = raw_def 
  end
  return attr_mt.__attr_cache[key]
end


--- @class st.zigbee.zcl.clusters.IASACEClientAttributes
---

local IASACEClientAttributes = {}

function IASACEClientAttributes:set_parent_cluster(cluster)
  self._cluster = cluster
  return self
end

setmetatable(IASACEClientAttributes, attr_mt)

return IASACEClientAttributes
