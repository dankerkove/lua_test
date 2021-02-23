local cluster_base = require "st.zigbee.cluster_base"
local data_types = require "st.zigbee.data_types"

-- DO NOT EDIT: this code is automatically generated by tools/zigbee-lib_generator/generate_clusters_from_xml.py
-- Script version: b'2cda4a8ebeb3328f48b89dd179d4e8623e7ad8f1'
-- ZCL XML version: 7.2

--- @class st.zigbee.zcl.clusters.ElectricalMeasurement.MeasuredPhase11thHarmonicCurrent
--- @alias MeasuredPhase11thHarmonicCurrent
---
--- @field public ID number 0x0312 the ID of this attribute
--- @field public NAME string "MeasuredPhase11thHarmonicCurrent" the name of this attribute
--- @field public data_type Int16 the data type of this attribute
local MeasuredPhase11thHarmonicCurrent = {
  ID = 0x0312,
  NAME = "MeasuredPhase11thHarmonicCurrent",
  base_type = data_types.Int16,
}

function MeasuredPhase11thHarmonicCurrent:augment_type(base_type_obj)
  -- Is there a better way to handle this?
  if base_type_obj.NAME ~= self.base_type.NAME then
    setmetatable(base_type_obj, getmetatable(self.base_type))
  end
  base_type_obj.field_name = self.NAME
end

function MeasuredPhase11thHarmonicCurrent.pretty_print(value_obj)
  MeasuredPhase11thHarmonicCurrent.base_type.pretty_print(value_obj)
end

--- @function MeasuredPhase11thHarmonicCurrent:build_test_attr_report
---
--- Build a Rx Zigbee message as if a device reported this attribute
--- @param device ZigbeeDevice
--- @param data Int16 the attribute value
--- @return ZigbeeMessageRx containing an AttributeReport body
MeasuredPhase11thHarmonicCurrent.build_test_attr_report = cluster_base.build_test_attr_report

--- @function MeasuredPhase11thHarmonicCurrent:build_test_read_attr_response
---
--- Build a Rx Zigbee message as if a device sent a read response for this attribute
--- @param device ZigbeeDevice
--- @param data Int16 the attribute value
--- @return ZigbeeMessageRx containing an ReadAttributeResponse body
MeasuredPhase11thHarmonicCurrent.build_test_read_attr_response = cluster_base.build_test_read_attr_response

--- Create a Int16 object of this attribute with any additional features provided for the attribute
---
--- This is also usable with the MeasuredPhase11thHarmonicCurrent(...) syntax
---
--- @param ... vararg the values needed to construct a Int16
--- @return Int16
function MeasuredPhase11thHarmonicCurrent:new_value(...)
    local o = self.base_type(table.unpack({...}))
    self:augment_type(o)
    return o
end

--- Construct a ZigbeeMessageTx to read this attribute from a device
---
--- @param device ZigbeeDevice
--- @return ZigbeeMessageTx containing a ReadAttribute body
function MeasuredPhase11thHarmonicCurrent:read(device)
    return cluster_base.read_attribute(device, data_types.ClusterId(self._cluster.ID), data_types.AttributeId(self.ID))
end

--- Construct a ZigbeeMessageTx to configure this attribute for reporting on a device
---
--- @param device ZigbeeDevice
--- @param min_rep_int number|Uint16 the minimum interval allowed between reports of this attribute
--- @param max_rep_int number|Uint16 the maximum interval allowed between reports of this attribute
--- @param rep_change Int16 The amount of change of the attribute to trigger a report
--- @return ZigbeeMessageTx containing a ConfigureReporting body
function MeasuredPhase11thHarmonicCurrent:configure_reporting(device, min_rep_int, max_rep_int, rep_change)
  local min = data_types.validate_or_build_type(min_rep_int, data_types.Uint16, "minimum_reporting_interval")
  local max = data_types.validate_or_build_type(max_rep_int, data_types.Uint16, "maximum_reporting_interval")
  rep_change = data_types.validate_or_build_type(rep_change, self.base_type, "reportable_change")
  return cluster_base.configure_reporting(device, data_types.ClusterId(self._cluster.ID), data_types.AttributeId(self.ID), data_types.ZigbeeDataType(self.base_type.ID), min, max, rep_change)
end

function MeasuredPhase11thHarmonicCurrent:set_parent_cluster(cluster)
  self._cluster = cluster
  return self
end

setmetatable(MeasuredPhase11thHarmonicCurrent, {__call = MeasuredPhase11thHarmonicCurrent.new_value})
return MeasuredPhase11thHarmonicCurrent
