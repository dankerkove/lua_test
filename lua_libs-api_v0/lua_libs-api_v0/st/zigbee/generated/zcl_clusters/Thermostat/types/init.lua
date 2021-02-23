-- DO NOT EDIT: this code is automatically generated by tools/zigbee-lib_generator/generate_clusters_from_xml.py
-- Script version: b'2cda4a8ebeb3328f48b89dd179d4e8623e7ad8f1'
-- ZCL XML version: 7.2

local types_mt = {}
types_mt.__types_cache = {}
types_mt.__index = function(self, key)
  if types_mt.__types_cache[key] == nil then
    local req_loc = string.format("st.zigbee.generated.zcl_clusters.Thermostat.types.%s", key)
    local cluster_type = require(req_loc)
    types_mt.__types_cache[key] = cluster_type
  end
  return types_mt.__types_cache[key]
end


--- @class st.zigbee.zcl.clusters.ThermostatTypes
---
--- @field public TransitionType st.zigbee.zcl.clusters.Thermostat.types.TransitionType
--- @field public Day Of Week st.zigbee.zcl.clusters.Thermostat.types.Day Of Week
--- @field public ScheduleMode st.zigbee.zcl.clusters.Thermostat.types.ScheduleMode
--- @field public Mode st.zigbee.zcl.clusters.Thermostat.types.Mode

local ThermostatTypes = {}

setmetatable(ThermostatTypes, types_mt)

return ThermostatTypes
