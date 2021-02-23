local cluster_base = require "st.zigbee.cluster_base"
local data_types = require "st.zigbee.data_types"

-- DO NOT EDIT: this code is automatically generated by tools/zigbee-lib_generator/generate_clusters_from_xml.py
-- Script version: b'2cda4a8ebeb3328f48b89dd179d4e8623e7ad8f1'
-- ZCL XML version: 7.2

--- @class st.zigbee.zcl.clusters.ThermostatUserInterfaceConfiguration.TemperatureDisplayMode
--- @alias TemperatureDisplayMode
---
--- @field public ID number 0x0000 the ID of this attribute
--- @field public NAME string "TemperatureDisplayMode" the name of this attribute
--- @field public data_type Enum8 the data type of this attribute
--- @field public CELSIUS number 0
--- @field public FAHRENHEIT number 1
local TemperatureDisplayMode = {
  ID = 0x0000,
  NAME = "TemperatureDisplayMode",
  base_type = data_types.Enum8,
}

TemperatureDisplayMode.CELSIUS    = 0x00
TemperatureDisplayMode.FAHRENHEIT = 0x01


TemperatureDisplayMode.enum_fields = {
    [TemperatureDisplayMode.CELSIUS]    = "CELSIUS",
    [TemperatureDisplayMode.FAHRENHEIT] = "FAHRENHEIT",
}

--- Add additional functionality to the base type object
---
--- @param base_type_obj Enum8 the base data type object to add functionality to
function TemperatureDisplayMode:augment_type(base_type_obj)
  for value, key in pairs(self.enum_fields) do
    base_type_obj[key] = value
  end
  base_type_obj.field_name = self.NAME
  base_type_obj.pretty_print = self.pretty_print
end

function TemperatureDisplayMode.pretty_print(value_obj)
  return string.format("%s: %s[%s]", value_obj.field_name or value_obj.NAME, TemperatureDisplayMode.NAME, TemperatureDisplayMode.enum_fields[value_obj.value])
end

--- @function TemperatureDisplayMode:build_test_attr_report
---
--- Build a Rx Zigbee message as if a device reported this attribute
--- @param device ZigbeeDevice
--- @param data Enum8 the attribute value
--- @return ZigbeeMessageRx containing an AttributeReport body
TemperatureDisplayMode.build_test_attr_report = cluster_base.build_test_attr_report

--- @function TemperatureDisplayMode:build_test_read_attr_response
---
--- Build a Rx Zigbee message as if a device sent a read response for this attribute
--- @param device ZigbeeDevice
--- @param data Enum8 the attribute value
--- @return ZigbeeMessageRx containing an ReadAttributeResponse body
TemperatureDisplayMode.build_test_read_attr_response = cluster_base.build_test_read_attr_response

--- Create a Enum8 object of this attribute with any additional features provided for the attribute
---
--- This is also usable with the TemperatureDisplayMode(...) syntax
---
--- @param ... vararg the values needed to construct a Enum8
--- @return Enum8
function TemperatureDisplayMode:new_value(...)
    local o = self.base_type(table.unpack({...}))
    self:augment_type(o)
    return o
end

--- Construct a ZigbeeMessageTx to read this attribute from a device
---
--- @param device ZigbeeDevice
--- @return ZigbeeMessageTx containing a ReadAttribute body
function TemperatureDisplayMode:read(device)
    return cluster_base.read_attribute(device, data_types.ClusterId(self._cluster.ID), data_types.AttributeId(self.ID))
end

--- Construct a ZigbeeMessageTx to configure this attribute for reporting on a device
---
--- @param device ZigbeeDevice
--- @param min_rep_int number|Uint16 the minimum interval allowed between reports of this attribute
--- @param max_rep_int number|Uint16 the maximum interval allowed between reports of this attribute
--- @return ZigbeeMessageTx containing a ConfigureReporting body
function TemperatureDisplayMode:configure_reporting(device, min_rep_int, max_rep_int)
  local min = data_types.validate_or_build_type(min_rep_int, data_types.Uint16, "minimum_reporting_interval")
  local max = data_types.validate_or_build_type(max_rep_int, data_types.Uint16, "maximum_reporting_interval")
  local rep_change = nil
  return cluster_base.configure_reporting(device, data_types.ClusterId(self._cluster.ID), data_types.AttributeId(self.ID), data_types.ZigbeeDataType(self.base_type.ID), min, max, rep_change)
end

--- Write a value to this attribute on a device
---
--- @param device ZigbeeDevice
--- @param value Enum8 the value to write
function TemperatureDisplayMode:write(device, value)
  local data = data_types.validate_or_build_type(value, self.base_type)
  self:augment_type(data)
  return cluster_base.write_attribute(device, data_types.ClusterId(self._cluster.ID), data_types.AttributeId(self.ID), data)
end

function TemperatureDisplayMode:set_parent_cluster(cluster)
  self._cluster = cluster
  return self
end

setmetatable(TemperatureDisplayMode, {__call = TemperatureDisplayMode.new_value})
return TemperatureDisplayMode
