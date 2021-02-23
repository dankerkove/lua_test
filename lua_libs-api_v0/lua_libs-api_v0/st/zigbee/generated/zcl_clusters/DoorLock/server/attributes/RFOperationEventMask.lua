local cluster_base = require "st.zigbee.cluster_base"
local data_types = require "st.zigbee.data_types"

-- DO NOT EDIT: this code is automatically generated by tools/zigbee-lib_generator/generate_clusters_from_xml.py
-- Script version: b'2cda4a8ebeb3328f48b89dd179d4e8623e7ad8f1'
-- ZCL XML version: 7.2

--- @class st.zigbee.zcl.clusters.DoorLock.RFOperationEventMask
--- @alias RFOperationEventMask
---
--- @field public ID number 0x0042 the ID of this attribute
--- @field public NAME string "RFOperationEventMask" the name of this attribute
--- @field public data_type Bitmap16 the data type of this attribute
--- @field public RF_OP_UNKNOWN_OR_MS number 1
--- @field public RF_OP_LOCK number 2
--- @field public RF_OP_UNLOCK number 4
--- @field public RF_OP_LOCK_ERROR_INVALID_CODE number 8
--- @field public RF_OP_LOCK_ERROR_INVALID_SCHEDULE number 16
--- @field public RF_OP_UNLOCK_INVALID_CODE number 32
--- @field public RF_OP_UNLOCK_INVALID_SCHEDULE number 64
local RFOperationEventMask = {
  ID = 0x0042,
  NAME = "RFOperationEventMask",
  base_type = data_types.Bitmap16,
}

RFOperationEventMask.BASE_MASK                         = 0xFFFF
RFOperationEventMask.RF_OP_UNKNOWN_OR_MS               = 0x0001
RFOperationEventMask.RF_OP_LOCK                        = 0x0002
RFOperationEventMask.RF_OP_UNLOCK                      = 0x0004
RFOperationEventMask.RF_OP_LOCK_ERROR_INVALID_CODE     = 0x0008
RFOperationEventMask.RF_OP_LOCK_ERROR_INVALID_SCHEDULE = 0x0010
RFOperationEventMask.RF_OP_UNLOCK_INVALID_CODE         = 0x0020
RFOperationEventMask.RF_OP_UNLOCK_INVALID_SCHEDULE     = 0x0040


RFOperationEventMask.mask_fields = {
  BASE_MASK = 0xFFFF,
  RF_OP_UNKNOWN_OR_MS = 0x0001,
  RF_OP_LOCK = 0x0002,
  RF_OP_UNLOCK = 0x0004,
  RF_OP_LOCK_ERROR_INVALID_CODE = 0x0008,
  RF_OP_LOCK_ERROR_INVALID_SCHEDULE = 0x0010,
  RF_OP_UNLOCK_INVALID_CODE = 0x0020,
  RF_OP_UNLOCK_INVALID_SCHEDULE = 0x0040,
}


--- @function RFOperationEventMask:is_rf_op_unknown_or_ms_set
--- @return boolean True if the value of RF_OP_UNKNOWN_OR_MS is non-zero
RFOperationEventMask.is_rf_op_unknown_or_ms_set = function(self)
  return (self.value & self.RF_OP_UNKNOWN_OR_MS) ~= 0
end
 
--- @function RFOperationEventMask:set_rf_op_unknown_or_ms
--- Set the value of the bit in the RF_OP_UNKNOWN_OR_MS field to 1
RFOperationEventMask.set_rf_op_unknown_or_ms = function(self)
  self.value = self.value | self.RF_OP_UNKNOWN_OR_MS
end

--- @function RFOperationEventMask:unset_rf_op_unknown_or_ms
--- Set the value of the bits in the RF_OP_UNKNOWN_OR_MS field to 0
RFOperationEventMask.unset_rf_op_unknown_or_ms = function(self)
  self.value = self.value & (~self.RF_OP_UNKNOWN_OR_MS & self.BASE_MASK)
end

--- @function RFOperationEventMask:is_rf_op_lock_set
--- @return boolean True if the value of RF_OP_LOCK is non-zero
RFOperationEventMask.is_rf_op_lock_set = function(self)
  return (self.value & self.RF_OP_LOCK) ~= 0
end
 
--- @function RFOperationEventMask:set_rf_op_lock
--- Set the value of the bit in the RF_OP_LOCK field to 1
RFOperationEventMask.set_rf_op_lock = function(self)
  self.value = self.value | self.RF_OP_LOCK
end

--- @function RFOperationEventMask:unset_rf_op_lock
--- Set the value of the bits in the RF_OP_LOCK field to 0
RFOperationEventMask.unset_rf_op_lock = function(self)
  self.value = self.value & (~self.RF_OP_LOCK & self.BASE_MASK)
end

--- @function RFOperationEventMask:is_rf_op_unlock_set
--- @return boolean True if the value of RF_OP_UNLOCK is non-zero
RFOperationEventMask.is_rf_op_unlock_set = function(self)
  return (self.value & self.RF_OP_UNLOCK) ~= 0
end
 
--- @function RFOperationEventMask:set_rf_op_unlock
--- Set the value of the bit in the RF_OP_UNLOCK field to 1
RFOperationEventMask.set_rf_op_unlock = function(self)
  self.value = self.value | self.RF_OP_UNLOCK
end

--- @function RFOperationEventMask:unset_rf_op_unlock
--- Set the value of the bits in the RF_OP_UNLOCK field to 0
RFOperationEventMask.unset_rf_op_unlock = function(self)
  self.value = self.value & (~self.RF_OP_UNLOCK & self.BASE_MASK)
end

--- @function RFOperationEventMask:is_rf_op_lock_error_invalid_code_set
--- @return boolean True if the value of RF_OP_LOCK_ERROR_INVALID_CODE is non-zero
RFOperationEventMask.is_rf_op_lock_error_invalid_code_set = function(self)
  return (self.value & self.RF_OP_LOCK_ERROR_INVALID_CODE) ~= 0
end
 
--- @function RFOperationEventMask:set_rf_op_lock_error_invalid_code
--- Set the value of the bit in the RF_OP_LOCK_ERROR_INVALID_CODE field to 1
RFOperationEventMask.set_rf_op_lock_error_invalid_code = function(self)
  self.value = self.value | self.RF_OP_LOCK_ERROR_INVALID_CODE
end

--- @function RFOperationEventMask:unset_rf_op_lock_error_invalid_code
--- Set the value of the bits in the RF_OP_LOCK_ERROR_INVALID_CODE field to 0
RFOperationEventMask.unset_rf_op_lock_error_invalid_code = function(self)
  self.value = self.value & (~self.RF_OP_LOCK_ERROR_INVALID_CODE & self.BASE_MASK)
end

--- @function RFOperationEventMask:is_rf_op_lock_error_invalid_schedule_set
--- @return boolean True if the value of RF_OP_LOCK_ERROR_INVALID_SCHEDULE is non-zero
RFOperationEventMask.is_rf_op_lock_error_invalid_schedule_set = function(self)
  return (self.value & self.RF_OP_LOCK_ERROR_INVALID_SCHEDULE) ~= 0
end
 
--- @function RFOperationEventMask:set_rf_op_lock_error_invalid_schedule
--- Set the value of the bit in the RF_OP_LOCK_ERROR_INVALID_SCHEDULE field to 1
RFOperationEventMask.set_rf_op_lock_error_invalid_schedule = function(self)
  self.value = self.value | self.RF_OP_LOCK_ERROR_INVALID_SCHEDULE
end

--- @function RFOperationEventMask:unset_rf_op_lock_error_invalid_schedule
--- Set the value of the bits in the RF_OP_LOCK_ERROR_INVALID_SCHEDULE field to 0
RFOperationEventMask.unset_rf_op_lock_error_invalid_schedule = function(self)
  self.value = self.value & (~self.RF_OP_LOCK_ERROR_INVALID_SCHEDULE & self.BASE_MASK)
end

--- @function RFOperationEventMask:is_rf_op_unlock_invalid_code_set
--- @return boolean True if the value of RF_OP_UNLOCK_INVALID_CODE is non-zero
RFOperationEventMask.is_rf_op_unlock_invalid_code_set = function(self)
  return (self.value & self.RF_OP_UNLOCK_INVALID_CODE) ~= 0
end
 
--- @function RFOperationEventMask:set_rf_op_unlock_invalid_code
--- Set the value of the bit in the RF_OP_UNLOCK_INVALID_CODE field to 1
RFOperationEventMask.set_rf_op_unlock_invalid_code = function(self)
  self.value = self.value | self.RF_OP_UNLOCK_INVALID_CODE
end

--- @function RFOperationEventMask:unset_rf_op_unlock_invalid_code
--- Set the value of the bits in the RF_OP_UNLOCK_INVALID_CODE field to 0
RFOperationEventMask.unset_rf_op_unlock_invalid_code = function(self)
  self.value = self.value & (~self.RF_OP_UNLOCK_INVALID_CODE & self.BASE_MASK)
end

--- @function RFOperationEventMask:is_rf_op_unlock_invalid_schedule_set
--- @return boolean True if the value of RF_OP_UNLOCK_INVALID_SCHEDULE is non-zero
RFOperationEventMask.is_rf_op_unlock_invalid_schedule_set = function(self)
  return (self.value & self.RF_OP_UNLOCK_INVALID_SCHEDULE) ~= 0
end
 
--- @function RFOperationEventMask:set_rf_op_unlock_invalid_schedule
--- Set the value of the bit in the RF_OP_UNLOCK_INVALID_SCHEDULE field to 1
RFOperationEventMask.set_rf_op_unlock_invalid_schedule = function(self)
  self.value = self.value | self.RF_OP_UNLOCK_INVALID_SCHEDULE
end

--- @function RFOperationEventMask:unset_rf_op_unlock_invalid_schedule
--- Set the value of the bits in the RF_OP_UNLOCK_INVALID_SCHEDULE field to 0
RFOperationEventMask.unset_rf_op_unlock_invalid_schedule = function(self)
  self.value = self.value & (~self.RF_OP_UNLOCK_INVALID_SCHEDULE & self.BASE_MASK)
end


RFOperationEventMask.mask_methods = {
  is_rf_op_unknown_or_ms_set = RFOperationEventMask.is_rf_op_unknown_or_ms_set,
  set_rf_op_unknown_or_ms = RFOperationEventMask.set_rf_op_unknown_or_ms,
  unset_rf_op_unknown_or_ms = RFOperationEventMask.unset_rf_op_unknown_or_ms,
  is_rf_op_lock_set = RFOperationEventMask.is_rf_op_lock_set,
  set_rf_op_lock = RFOperationEventMask.set_rf_op_lock,
  unset_rf_op_lock = RFOperationEventMask.unset_rf_op_lock,
  is_rf_op_unlock_set = RFOperationEventMask.is_rf_op_unlock_set,
  set_rf_op_unlock = RFOperationEventMask.set_rf_op_unlock,
  unset_rf_op_unlock = RFOperationEventMask.unset_rf_op_unlock,
  is_rf_op_lock_error_invalid_code_set = RFOperationEventMask.is_rf_op_lock_error_invalid_code_set,
  set_rf_op_lock_error_invalid_code = RFOperationEventMask.set_rf_op_lock_error_invalid_code,
  unset_rf_op_lock_error_invalid_code = RFOperationEventMask.unset_rf_op_lock_error_invalid_code,
  is_rf_op_lock_error_invalid_schedule_set = RFOperationEventMask.is_rf_op_lock_error_invalid_schedule_set,
  set_rf_op_lock_error_invalid_schedule = RFOperationEventMask.set_rf_op_lock_error_invalid_schedule,
  unset_rf_op_lock_error_invalid_schedule = RFOperationEventMask.unset_rf_op_lock_error_invalid_schedule,
  is_rf_op_unlock_invalid_code_set = RFOperationEventMask.is_rf_op_unlock_invalid_code_set,
  set_rf_op_unlock_invalid_code = RFOperationEventMask.set_rf_op_unlock_invalid_code,
  unset_rf_op_unlock_invalid_code = RFOperationEventMask.unset_rf_op_unlock_invalid_code,
  is_rf_op_unlock_invalid_schedule_set = RFOperationEventMask.is_rf_op_unlock_invalid_schedule_set,
  set_rf_op_unlock_invalid_schedule = RFOperationEventMask.set_rf_op_unlock_invalid_schedule,
  unset_rf_op_unlock_invalid_schedule = RFOperationEventMask.unset_rf_op_unlock_invalid_schedule,
}

--- Add additional functionality to the base type object
---
--- @param base_type_obj Bitmap16 the base data type object to add functionality to
function RFOperationEventMask:augment_type(base_type_obj)
  for k, v in pairs(self.mask_fields) do
    base_type_obj[k] = v
  end
  for k, v in pairs(self.mask_methods) do
    base_type_obj[k] = v
  end
  
  base_type_obj.field_name = self.NAME
  base_type_obj.pretty_print = self.pretty_print
end

function RFOperationEventMask.pretty_print(value_obj)
  local zb_utils = require "st.zigbee.utils" 
  local pattern = ">I" .. value_obj.byte_length
  return string.format("%s: %s[0x]", value_obj.field_name or value_obj.NAME, RFOperationEventMask.NAME, zb_utils.pretty_print_hex_str(string.pack(pattern, value_obj.value)))
end

--- @function RFOperationEventMask:build_test_attr_report
---
--- Build a Rx Zigbee message as if a device reported this attribute
--- @param device ZigbeeDevice
--- @param data Bitmap16 the attribute value
--- @return ZigbeeMessageRx containing an AttributeReport body
RFOperationEventMask.build_test_attr_report = cluster_base.build_test_attr_report

--- @function RFOperationEventMask:build_test_read_attr_response
---
--- Build a Rx Zigbee message as if a device sent a read response for this attribute
--- @param device ZigbeeDevice
--- @param data Bitmap16 the attribute value
--- @return ZigbeeMessageRx containing an ReadAttributeResponse body
RFOperationEventMask.build_test_read_attr_response = cluster_base.build_test_read_attr_response

--- Create a Bitmap16 object of this attribute with any additional features provided for the attribute
---
--- This is also usable with the RFOperationEventMask(...) syntax
---
--- @param ... vararg the values needed to construct a Bitmap16
--- @return Bitmap16
function RFOperationEventMask:new_value(...)
    local o = self.base_type(table.unpack({...}))
    self:augment_type(o)
    return o
end

--- Construct a ZigbeeMessageTx to read this attribute from a device
---
--- @param device ZigbeeDevice
--- @return ZigbeeMessageTx containing a ReadAttribute body
function RFOperationEventMask:read(device)
    return cluster_base.read_attribute(device, data_types.ClusterId(self._cluster.ID), data_types.AttributeId(self.ID))
end

--- Construct a ZigbeeMessageTx to configure this attribute for reporting on a device
---
--- @param device ZigbeeDevice
--- @param min_rep_int number|Uint16 the minimum interval allowed between reports of this attribute
--- @param max_rep_int number|Uint16 the maximum interval allowed between reports of this attribute
--- @return ZigbeeMessageTx containing a ConfigureReporting body
function RFOperationEventMask:configure_reporting(device, min_rep_int, max_rep_int)
  local min = data_types.validate_or_build_type(min_rep_int, data_types.Uint16, "minimum_reporting_interval")
  local max = data_types.validate_or_build_type(max_rep_int, data_types.Uint16, "maximum_reporting_interval")
  local rep_change = nil
  return cluster_base.configure_reporting(device, data_types.ClusterId(self._cluster.ID), data_types.AttributeId(self.ID), data_types.ZigbeeDataType(self.base_type.ID), min, max, rep_change)
end

--- Write a value to this attribute on a device
---
--- @param device ZigbeeDevice
--- @param value Bitmap16 the value to write
function RFOperationEventMask:write(device, value)
  local data = data_types.validate_or_build_type(value, self.base_type)
  self:augment_type(data)
  return cluster_base.write_attribute(device, data_types.ClusterId(self._cluster.ID), data_types.AttributeId(self.ID), data)
end

function RFOperationEventMask:set_parent_cluster(cluster)
  self._cluster = cluster
  return self
end

setmetatable(RFOperationEventMask, {__call = RFOperationEventMask.new_value})
return RFOperationEventMask
