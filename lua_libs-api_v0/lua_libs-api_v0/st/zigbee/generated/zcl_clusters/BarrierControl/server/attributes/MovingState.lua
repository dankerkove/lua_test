local cluster_base = require "st.zigbee.cluster_base"
local data_types = require "st.zigbee.data_types"

-- DO NOT EDIT: this code is automatically generated by tools/zigbee-lib_generator/generate_clusters_from_xml.py
-- Script version: b'2cda4a8ebeb3328f48b89dd179d4e8623e7ad8f1'
-- ZCL XML version: 7.2

--- @class st.zigbee.zcl.clusters.BarrierControl.MovingState
--- @alias MovingState
---
--- @field public ID number 0x0001 the ID of this attribute
--- @field public NAME string "MovingState" the name of this attribute
--- @field public data_type Enum8 the data type of this attribute
--- @field public STOPPED number 0
--- @field public CLOSING number 1
--- @field public OPENING number 2
local MovingState = {
  ID = 0x0001,
  NAME = "MovingState",
  base_type = data_types.Enum8,
}

MovingState.STOPPED = 0x00
MovingState.CLOSING = 0x01
MovingState.OPENING = 0x02


MovingState.enum_fields = {
    [MovingState.STOPPED] = "STOPPED",
    [MovingState.CLOSING] = "CLOSING",
    [MovingState.OPENING] = "OPENING",
}

--- Add additional functionality to the base type object
---
--- @param base_type_obj Enum8 the base data type object to add functionality to
function MovingState:augment_type(base_type_obj)
  for value, key in pairs(self.enum_fields) do
    base_type_obj[key] = value
  end
  base_type_obj.field_name = self.NAME
  base_type_obj.pretty_print = self.pretty_print
end

function MovingState.pretty_print(value_obj)
  return string.format("%s: %s[%s]", value_obj.field_name or value_obj.NAME, MovingState.NAME, MovingState.enum_fields[value_obj.value])
end

--- @function MovingState:build_test_attr_report
---
--- Build a Rx Zigbee message as if a device reported this attribute
--- @param device ZigbeeDevice
--- @param data Enum8 the attribute value
--- @return ZigbeeMessageRx containing an AttributeReport body
MovingState.build_test_attr_report = cluster_base.build_test_attr_report

--- @function MovingState:build_test_read_attr_response
---
--- Build a Rx Zigbee message as if a device sent a read response for this attribute
--- @param device ZigbeeDevice
--- @param data Enum8 the attribute value
--- @return ZigbeeMessageRx containing an ReadAttributeResponse body
MovingState.build_test_read_attr_response = cluster_base.build_test_read_attr_response

--- Create a Enum8 object of this attribute with any additional features provided for the attribute
---
--- This is also usable with the MovingState(...) syntax
---
--- @param ... vararg the values needed to construct a Enum8
--- @return Enum8
function MovingState:new_value(...)
    local o = self.base_type(table.unpack({...}))
    self:augment_type(o)
    return o
end

--- Construct a ZigbeeMessageTx to read this attribute from a device
---
--- @param device ZigbeeDevice
--- @return ZigbeeMessageTx containing a ReadAttribute body
function MovingState:read(device)
    return cluster_base.read_attribute(device, data_types.ClusterId(self._cluster.ID), data_types.AttributeId(self.ID))
end

--- Construct a ZigbeeMessageTx to configure this attribute for reporting on a device
---
--- @param device ZigbeeDevice
--- @param min_rep_int number|Uint16 the minimum interval allowed between reports of this attribute
--- @param max_rep_int number|Uint16 the maximum interval allowed between reports of this attribute
--- @return ZigbeeMessageTx containing a ConfigureReporting body
function MovingState:configure_reporting(device, min_rep_int, max_rep_int)
  local min = data_types.validate_or_build_type(min_rep_int, data_types.Uint16, "minimum_reporting_interval")
  local max = data_types.validate_or_build_type(max_rep_int, data_types.Uint16, "maximum_reporting_interval")
  local rep_change = nil
  return cluster_base.configure_reporting(device, data_types.ClusterId(self._cluster.ID), data_types.AttributeId(self.ID), data_types.ZigbeeDataType(self.base_type.ID), min, max, rep_change)
end

function MovingState:set_parent_cluster(cluster)
  self._cluster = cluster
  return self
end

setmetatable(MovingState, {__call = MovingState.new_value})
return MovingState
