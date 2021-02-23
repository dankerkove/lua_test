local cluster_base = require "st.zigbee.cluster_base"
local data_types = require "st.zigbee.data_types"

-- DO NOT EDIT: this code is automatically generated by tools/zigbee-lib_generator/generate_clusters_from_xml.py
-- Script version: b'2cda4a8ebeb3328f48b89dd179d4e8623e7ad8f1'
-- ZCL XML version: 7.2

--- @class st.zigbee.zcl.clusters.Time.ValidUntilTime
--- @alias ValidUntilTime
---
--- @field public ID number 0x0009 the ID of this attribute
--- @field public NAME string "ValidUntilTime" the name of this attribute
--- @field public data_type UtcTime the data type of this attribute
local ValidUntilTime = {
  ID = 0x0009,
  NAME = "ValidUntilTime",
  base_type = data_types.UtcTime,
}

function ValidUntilTime:augment_type(base_type_obj)
  -- Is there a better way to handle this?
  if base_type_obj.NAME ~= self.base_type.NAME then
    setmetatable(base_type_obj, getmetatable(self.base_type))
  end
  base_type_obj.field_name = self.NAME
end

function ValidUntilTime.pretty_print(value_obj)
  ValidUntilTime.base_type.pretty_print(value_obj)
end

--- @function ValidUntilTime:build_test_attr_report
---
--- Build a Rx Zigbee message as if a device reported this attribute
--- @param device ZigbeeDevice
--- @param data UtcTime the attribute value
--- @return ZigbeeMessageRx containing an AttributeReport body
ValidUntilTime.build_test_attr_report = cluster_base.build_test_attr_report

--- @function ValidUntilTime:build_test_read_attr_response
---
--- Build a Rx Zigbee message as if a device sent a read response for this attribute
--- @param device ZigbeeDevice
--- @param data UtcTime the attribute value
--- @return ZigbeeMessageRx containing an ReadAttributeResponse body
ValidUntilTime.build_test_read_attr_response = cluster_base.build_test_read_attr_response

--- Create a UtcTime object of this attribute with any additional features provided for the attribute
---
--- This is also usable with the ValidUntilTime(...) syntax
---
--- @param ... vararg the values needed to construct a UtcTime
--- @return UtcTime
function ValidUntilTime:new_value(...)
    local o = self.base_type(table.unpack({...}))
    self:augment_type(o)
    return o
end

--- Construct a ZigbeeMessageTx to read this attribute from a device
---
--- @param device ZigbeeDevice
--- @return ZigbeeMessageTx containing a ReadAttribute body
function ValidUntilTime:read(device)
    return cluster_base.read_attribute(device, data_types.ClusterId(self._cluster.ID), data_types.AttributeId(self.ID))
end

--- Construct a ZigbeeMessageTx to configure this attribute for reporting on a device
---
--- @param device ZigbeeDevice
--- @param min_rep_int number|Uint16 the minimum interval allowed between reports of this attribute
--- @param max_rep_int number|Uint16 the maximum interval allowed between reports of this attribute
--- @param rep_change UtcTime The amount of change of the attribute to trigger a report
--- @return ZigbeeMessageTx containing a ConfigureReporting body
function ValidUntilTime:configure_reporting(device, min_rep_int, max_rep_int, rep_change)
  local min = data_types.validate_or_build_type(min_rep_int, data_types.Uint16, "minimum_reporting_interval")
  local max = data_types.validate_or_build_type(max_rep_int, data_types.Uint16, "maximum_reporting_interval")
  if type(rep_change) ~= "table" or rep_change.ID ~= self.base_type.ID then
    error(self.NAME .. " is of complex type " .. self.base_type.NAME .. " and should be built before passing in.")
  end
  return cluster_base.configure_reporting(device, data_types.ClusterId(self._cluster.ID), data_types.AttributeId(self.ID), data_types.ZigbeeDataType(self.base_type.ID), min, max, rep_change)
end

--- Write a value to this attribute on a device
---
--- @param device ZigbeeDevice
--- @param value UtcTime the value to write
function ValidUntilTime:write(device, value)
  if type(value) ~= "table" or value.ID ~= self.base_type.ID then
    error(self.NAME .. " is of complex type " .. self.base_type.NAME .. " and should be built before passing in.")
  end
  self:augment_type(value)
  return cluster_base.write_attribute(device, data_types.ClusterId(self._cluster.ID), data_types.AttributeId(self.ID), value)
end

function ValidUntilTime:set_parent_cluster(cluster)
  self._cluster = cluster
  return self
end

setmetatable(ValidUntilTime, {__call = ValidUntilTime.new_value})
return ValidUntilTime
