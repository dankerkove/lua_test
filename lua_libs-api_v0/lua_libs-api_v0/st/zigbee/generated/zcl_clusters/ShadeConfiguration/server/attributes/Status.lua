local cluster_base = require "st.zigbee.cluster_base"
local data_types = require "st.zigbee.data_types"

-- DO NOT EDIT: this code is automatically generated by tools/zigbee-lib_generator/generate_clusters_from_xml.py
-- Script version: b'2cda4a8ebeb3328f48b89dd179d4e8623e7ad8f1'
-- ZCL XML version: 7.2

--- @class st.zigbee.zcl.clusters.ShadeConfiguration.Status
--- @alias Status
---
--- @field public ID number 0x0002 the ID of this attribute
--- @field public NAME string "Status" the name of this attribute
--- @field public data_type Bitmap8 the data type of this attribute
--- @field public SHADE_OPERATIONAL number 1
--- @field public SHADE_ADJUSTING number 2
--- @field public SHADE_DIRECTION number 4
--- @field public FORWARD_DIRECTION_OF_MOTOR number 8
local Status = {
  ID = 0x0002,
  NAME = "Status",
  base_type = data_types.Bitmap8,
}

Status.BASE_MASK                  = 0xFF
Status.SHADE_OPERATIONAL          = 0x01
Status.SHADE_ADJUSTING            = 0x02
Status.SHADE_DIRECTION            = 0x04
Status.FORWARD_DIRECTION_OF_MOTOR = 0x08


Status.mask_fields = {
  BASE_MASK = 0xFF,
  SHADE_OPERATIONAL = 0x01,
  SHADE_ADJUSTING = 0x02,
  SHADE_DIRECTION = 0x04,
  FORWARD_DIRECTION_OF_MOTOR = 0x08,
}


--- @function Status:is_shade_operational_set
--- @return boolean True if the value of SHADE_OPERATIONAL is non-zero
Status.is_shade_operational_set = function(self)
  return (self.value & self.SHADE_OPERATIONAL) ~= 0
end
 
--- @function Status:set_shade_operational
--- Set the value of the bit in the SHADE_OPERATIONAL field to 1
Status.set_shade_operational = function(self)
  self.value = self.value | self.SHADE_OPERATIONAL
end

--- @function Status:unset_shade_operational
--- Set the value of the bits in the SHADE_OPERATIONAL field to 0
Status.unset_shade_operational = function(self)
  self.value = self.value & (~self.SHADE_OPERATIONAL & self.BASE_MASK)
end

--- @function Status:is_shade_adjusting_set
--- @return boolean True if the value of SHADE_ADJUSTING is non-zero
Status.is_shade_adjusting_set = function(self)
  return (self.value & self.SHADE_ADJUSTING) ~= 0
end
 
--- @function Status:set_shade_adjusting
--- Set the value of the bit in the SHADE_ADJUSTING field to 1
Status.set_shade_adjusting = function(self)
  self.value = self.value | self.SHADE_ADJUSTING
end

--- @function Status:unset_shade_adjusting
--- Set the value of the bits in the SHADE_ADJUSTING field to 0
Status.unset_shade_adjusting = function(self)
  self.value = self.value & (~self.SHADE_ADJUSTING & self.BASE_MASK)
end

--- @function Status:is_shade_direction_set
--- @return boolean True if the value of SHADE_DIRECTION is non-zero
Status.is_shade_direction_set = function(self)
  return (self.value & self.SHADE_DIRECTION) ~= 0
end
 
--- @function Status:set_shade_direction
--- Set the value of the bit in the SHADE_DIRECTION field to 1
Status.set_shade_direction = function(self)
  self.value = self.value | self.SHADE_DIRECTION
end

--- @function Status:unset_shade_direction
--- Set the value of the bits in the SHADE_DIRECTION field to 0
Status.unset_shade_direction = function(self)
  self.value = self.value & (~self.SHADE_DIRECTION & self.BASE_MASK)
end

--- @function Status:is_forward_direction_of_motor_set
--- @return boolean True if the value of FORWARD_DIRECTION_OF_MOTOR is non-zero
Status.is_forward_direction_of_motor_set = function(self)
  return (self.value & self.FORWARD_DIRECTION_OF_MOTOR) ~= 0
end
 
--- @function Status:set_forward_direction_of_motor
--- Set the value of the bit in the FORWARD_DIRECTION_OF_MOTOR field to 1
Status.set_forward_direction_of_motor = function(self)
  self.value = self.value | self.FORWARD_DIRECTION_OF_MOTOR
end

--- @function Status:unset_forward_direction_of_motor
--- Set the value of the bits in the FORWARD_DIRECTION_OF_MOTOR field to 0
Status.unset_forward_direction_of_motor = function(self)
  self.value = self.value & (~self.FORWARD_DIRECTION_OF_MOTOR & self.BASE_MASK)
end


Status.mask_methods = {
  is_shade_operational_set = Status.is_shade_operational_set,
  set_shade_operational = Status.set_shade_operational,
  unset_shade_operational = Status.unset_shade_operational,
  is_shade_adjusting_set = Status.is_shade_adjusting_set,
  set_shade_adjusting = Status.set_shade_adjusting,
  unset_shade_adjusting = Status.unset_shade_adjusting,
  is_shade_direction_set = Status.is_shade_direction_set,
  set_shade_direction = Status.set_shade_direction,
  unset_shade_direction = Status.unset_shade_direction,
  is_forward_direction_of_motor_set = Status.is_forward_direction_of_motor_set,
  set_forward_direction_of_motor = Status.set_forward_direction_of_motor,
  unset_forward_direction_of_motor = Status.unset_forward_direction_of_motor,
}

--- Add additional functionality to the base type object
---
--- @param base_type_obj Bitmap8 the base data type object to add functionality to
function Status:augment_type(base_type_obj)
  for k, v in pairs(self.mask_fields) do
    base_type_obj[k] = v
  end
  for k, v in pairs(self.mask_methods) do
    base_type_obj[k] = v
  end
  
  base_type_obj.field_name = self.NAME
  base_type_obj.pretty_print = self.pretty_print
end

function Status.pretty_print(value_obj)
  local zb_utils = require "st.zigbee.utils" 
  local pattern = ">I" .. value_obj.byte_length
  return string.format("%s: %s[0x]", value_obj.field_name or value_obj.NAME, Status.NAME, zb_utils.pretty_print_hex_str(string.pack(pattern, value_obj.value)))
end

--- @function Status:build_test_attr_report
---
--- Build a Rx Zigbee message as if a device reported this attribute
--- @param device ZigbeeDevice
--- @param data Bitmap8 the attribute value
--- @return ZigbeeMessageRx containing an AttributeReport body
Status.build_test_attr_report = cluster_base.build_test_attr_report

--- @function Status:build_test_read_attr_response
---
--- Build a Rx Zigbee message as if a device sent a read response for this attribute
--- @param device ZigbeeDevice
--- @param data Bitmap8 the attribute value
--- @return ZigbeeMessageRx containing an ReadAttributeResponse body
Status.build_test_read_attr_response = cluster_base.build_test_read_attr_response

--- Create a Bitmap8 object of this attribute with any additional features provided for the attribute
---
--- This is also usable with the Status(...) syntax
---
--- @param ... vararg the values needed to construct a Bitmap8
--- @return Bitmap8
function Status:new_value(...)
    local o = self.base_type(table.unpack({...}))
    self:augment_type(o)
    return o
end

--- Construct a ZigbeeMessageTx to read this attribute from a device
---
--- @param device ZigbeeDevice
--- @return ZigbeeMessageTx containing a ReadAttribute body
function Status:read(device)
    return cluster_base.read_attribute(device, data_types.ClusterId(self._cluster.ID), data_types.AttributeId(self.ID))
end

--- Construct a ZigbeeMessageTx to configure this attribute for reporting on a device
---
--- @param device ZigbeeDevice
--- @param min_rep_int number|Uint16 the minimum interval allowed between reports of this attribute
--- @param max_rep_int number|Uint16 the maximum interval allowed between reports of this attribute
--- @return ZigbeeMessageTx containing a ConfigureReporting body
function Status:configure_reporting(device, min_rep_int, max_rep_int)
  local min = data_types.validate_or_build_type(min_rep_int, data_types.Uint16, "minimum_reporting_interval")
  local max = data_types.validate_or_build_type(max_rep_int, data_types.Uint16, "maximum_reporting_interval")
  local rep_change = nil
  return cluster_base.configure_reporting(device, data_types.ClusterId(self._cluster.ID), data_types.AttributeId(self.ID), data_types.ZigbeeDataType(self.base_type.ID), min, max, rep_change)
end

--- Write a value to this attribute on a device
---
--- @param device ZigbeeDevice
--- @param value Bitmap8 the value to write
function Status:write(device, value)
  local data = data_types.validate_or_build_type(value, self.base_type)
  self:augment_type(data)
  return cluster_base.write_attribute(device, data_types.ClusterId(self._cluster.ID), data_types.AttributeId(self.ID), data)
end

function Status:set_parent_cluster(cluster)
  self._cluster = cluster
  return self
end

setmetatable(Status, {__call = Status.new_value})
return Status
