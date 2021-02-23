-- DO NOT EDIT: this code is automatically generated by tools/zigbee-lib_generator/generate_clusters_from_xml.py
-- Script version: b'2cda4a8ebeb3328f48b89dd179d4e8623e7ad8f1'
-- ZCL XML version: 7.2

local attr_mt = {}
attr_mt.__attr_cache = {}
attr_mt.__index = function(self, key)
  if attr_mt.__attr_cache[key] == nil then
    local req_loc = string.format("st.zigbee.generated.zcl_clusters.PumpConfigurationAndControl.server.attributes.%s", key)
    local raw_def = require(req_loc)
    local cluster = rawget(self, "_cluster")
    raw_def:set_parent_cluster(cluster)
    attr_mt.__attr_cache[key] = raw_def 
  end
  return attr_mt.__attr_cache[key]
end


--- @class st.zigbee.zcl.clusters.PumpConfigurationAndControlServerAttributes
---
--- @field public MaxPressure st.zigbee.zcl.clusters.PumpConfigurationAndControl.MaxPressure
--- @field public MaxSpeed st.zigbee.zcl.clusters.PumpConfigurationAndControl.MaxSpeed
--- @field public MaxFlow st.zigbee.zcl.clusters.PumpConfigurationAndControl.MaxFlow
--- @field public MinConstPressure st.zigbee.zcl.clusters.PumpConfigurationAndControl.MinConstPressure
--- @field public MaxConstPressure st.zigbee.zcl.clusters.PumpConfigurationAndControl.MaxConstPressure
--- @field public MinCompPressure st.zigbee.zcl.clusters.PumpConfigurationAndControl.MinCompPressure
--- @field public MaxCompPressure st.zigbee.zcl.clusters.PumpConfigurationAndControl.MaxCompPressure
--- @field public MinConstSpeed st.zigbee.zcl.clusters.PumpConfigurationAndControl.MinConstSpeed
--- @field public MaxConstSpeed st.zigbee.zcl.clusters.PumpConfigurationAndControl.MaxConstSpeed
--- @field public MinConstFlow st.zigbee.zcl.clusters.PumpConfigurationAndControl.MinConstFlow
--- @field public MaxConstFlow st.zigbee.zcl.clusters.PumpConfigurationAndControl.MaxConstFlow
--- @field public MinConstTemp st.zigbee.zcl.clusters.PumpConfigurationAndControl.MinConstTemp
--- @field public MaxConstTemp st.zigbee.zcl.clusters.PumpConfigurationAndControl.MaxConstTemp
--- @field public PumpStatus st.zigbee.zcl.clusters.PumpConfigurationAndControl.PumpStatus
--- @field public EffectiveOperationMode st.zigbee.zcl.clusters.PumpConfigurationAndControl.EffectiveOperationMode
--- @field public EffectiveControlMode st.zigbee.zcl.clusters.PumpConfigurationAndControl.EffectiveControlMode
--- @field public Capacity st.zigbee.zcl.clusters.PumpConfigurationAndControl.Capacity
--- @field public Speed st.zigbee.zcl.clusters.PumpConfigurationAndControl.Speed
--- @field public LifetimeRunningHours st.zigbee.zcl.clusters.PumpConfigurationAndControl.LifetimeRunningHours
--- @field public Power st.zigbee.zcl.clusters.PumpConfigurationAndControl.Power
--- @field public LifetimeEnergyConsumed st.zigbee.zcl.clusters.PumpConfigurationAndControl.LifetimeEnergyConsumed
--- @field public OperationMode st.zigbee.zcl.clusters.PumpConfigurationAndControl.OperationMode
--- @field public ControlMode st.zigbee.zcl.clusters.PumpConfigurationAndControl.ControlMode
--- @field public AlarmMask st.zigbee.zcl.clusters.PumpConfigurationAndControl.AlarmMask

local PumpConfigurationAndControlServerAttributes = {}

function PumpConfigurationAndControlServerAttributes:set_parent_cluster(cluster)
  self._cluster = cluster
  return self
end

setmetatable(PumpConfigurationAndControlServerAttributes, attr_mt)

return PumpConfigurationAndControlServerAttributes
