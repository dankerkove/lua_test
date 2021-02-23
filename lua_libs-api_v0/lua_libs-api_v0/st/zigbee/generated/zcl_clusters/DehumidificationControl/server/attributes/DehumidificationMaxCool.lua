local cluster_base = require "st.zigbee.cluster_base"
local data_types = require "st.zigbee.data_types"

-- DO NOT EDIT: this code is automatically generated by tools/zigbee-lib_generator/generate_clusters_from_xml.py
-- Script version: b'2cda4a8ebeb3328f48b89dd179d4e8623e7ad8f1'
-- ZCL XML version: 7.2

--- @class st.zigbee.zcl.clusters.DehumidificationControl.DehumidificationMaxCool
--- @alias DehumidificationMaxCool
---
--- @field public ID number 0x0014 the ID of this attribute
--- @field public NAME string "DehumidificationMaxCool" the name of this attribute
--- @field public data_type Uint8 the data type of this attribute
local DehumidificationMaxCool = {
  ID = 0x0014,
  NAME = "DehumidificationMaxCool",
  base_type = data_types.Uint8,
}

function DehumidificationMaxCool:augment_type(base_type_obj)
  -- Is there a better way to handle this?
  if base_type_obj.NAME ~= self.base_type.NAME then
    setmetatable(base_type_obj, getmetatable(self.base_type))
  end
  base_type_obj.field_name = self.NAME
end

function DehumidificationMaxCool.pretty_print(value_obj)
  DehumidificationMaxCool.base_type.pretty_print(value_obj)
end

--- @function DehumidificationMaxCool:build_test_attr_report
---
--- Build a Rx Zigbee message as if a device reported this attribute
--- @param device ZigbeeDevice
--- @param data Uint8 the attribute value
--- @return ZigbeeMessageRx containing an AttributeReport body
DehumidificationMaxCool.build_test_attr_report = cluster_base.build_test_attr_report

--- @function DehumidificationMaxCool:build_test_read_attr_response
---
--- Build a Rx Zigbee message as if a device sent a read response for this attribute
--- @param device ZigbeeDevice
--- @param data Uint8 the attribute value
--- @return ZigbeeMessageRx containing an ReadAttributeResponse body
DehumidificationMaxCool.build_test_read_attr_response = cluster_base.build_test_read_attr_response

--- Create a Uint8 object of this attribute with any additional features provided for the attribute
---
--- This is also usable with the DehumidificationMaxCool(...) syntax
---
--- @param ... vararg the values needed to construct a Uint8
--- @return Uint8
function DehumidificationMaxCool:new_value(...)
    local o = self.base_type(table.unpack({...}))
    self:augment_type(o)
    return o
end

--- Construct a ZigbeeMessageTx to read this attribute from a device
---
--- @param device ZigbeeDevice
--- @return ZigbeeMessageTx containing a ReadAttribute body
function DehumidificationMaxCool:read(device)
    return cluster_base.read_attribute(device, data_types.ClusterId(self._cluster.ID), data_types.AttributeId(self.ID))
end

--- Construct a ZigbeeMessageTx to configure this attribute for reporting on a device
---
--- @param device ZigbeeDevice
--- @param min_rep_int number|Uint16 the minimum interval allowed between reports of this attribute
--- @param max_rep_int number|Uint16 the maximum interval allowed between reports of this attribute
--- @param rep_change Uint8 The amount of change of the attribute to trigger a report
--- @return ZigbeeMessageTx containing a ConfigureReporting body
function DehumidificationMaxCool:configure_reporting(device, min_rep_int, max_rep_int, rep_change)
  local min = data_types.validate_or_build_type(min_rep_int, data_types.Uint16, "minimum_reporting_interval")
  local max = data_types.validate_or_build_type(max_rep_int, data_types.Uint16, "maximum_reporting_interval")
  rep_change = data_types.validate_or_build_type(rep_change, self.base_type, "reportable_change")
  return cluster_base.configure_reporting(device, data_types.ClusterId(self._cluster.ID), data_types.AttributeId(self.ID), data_types.ZigbeeDataType(self.base_type.ID), min, max, rep_change)
end

--- Write a value to this attribute on a device
---
--- @param device ZigbeeDevice
--- @param value Uint8 the value to write
function DehumidificationMaxCool:write(device, value)
  local data = data_types.validate_or_build_type(value, self.base_type)
  self:augment_type(data)
  return cluster_base.write_attribute(device, data_types.ClusterId(self._cluster.ID), data_types.AttributeId(self.ID), data)
end

function DehumidificationMaxCool:set_parent_cluster(cluster)
  self._cluster = cluster
  return self
end

setmetatable(DehumidificationMaxCool, {__call = DehumidificationMaxCool.new_value})
return DehumidificationMaxCool
