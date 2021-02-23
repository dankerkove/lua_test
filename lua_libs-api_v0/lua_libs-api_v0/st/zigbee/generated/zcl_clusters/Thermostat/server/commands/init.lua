-- DO NOT EDIT: this code is automatically generated by tools/zigbee-lib_generator/generate_clusters_from_xml.py
-- Script version: b'2cda4a8ebeb3328f48b89dd179d4e8623e7ad8f1'
-- ZCL XML version: 7.2

local command_mt = {}
command_mt.__command_cache = {}
command_mt.__index = function(self, key)
  if command_mt.__command_cache[key] == nil then
    local req_loc = string.format("st.zigbee.generated.zcl_clusters.Thermostat.server.commands.%s", key)
    local raw_def = require(req_loc)
    local cluster = rawget(self, "_cluster")
    command_mt.__command_cache[key] = raw_def:set_parent_cluster(cluster)
  end
  return command_mt.__command_cache[key]
end
--- @class st.zigbee.zcl.clusters.ThermostatServerCommands
---
--- @field public SetpointRaiseOrLower st.zigbee.zcl.clusters.Thermostat.SetpointRaiseOrLower
--- @field public SetWeeklySchedule st.zigbee.zcl.clusters.Thermostat.SetWeeklySchedule
--- @field public GetWeeklySchedule st.zigbee.zcl.clusters.Thermostat.GetWeeklySchedule
--- @field public ClearWeeklySchedule st.zigbee.zcl.clusters.Thermostat.ClearWeeklySchedule
--- @field public GetRelayStatusLog st.zigbee.zcl.clusters.Thermostat.GetRelayStatusLog
local ThermostatServerCommands = {}

function ThermostatServerCommands:set_parent_cluster(cluster)
  self._cluster = cluster
  return self
end

setmetatable(ThermostatServerCommands, command_mt)

return ThermostatServerCommands
