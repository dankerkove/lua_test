local cluster_base = require "st.zigbee.cluster_base"
local data_types = require "st.zigbee.data_types"

-- DO NOT EDIT: this code is automatically generated by tools/zigbee-lib_generator/generate_clusters_from_xml.py
-- Script version: b'2cda4a8ebeb3328f48b89dd179d4e8623e7ad8f1'
-- ZCL XML version: 7.2

--- @class st.zigbee.zcl.clusters.DoorLock.SupportedOperatingModes
--- @alias SupportedOperatingModes
---
--- @field public ID number 0x0026 the ID of this attribute
--- @field public NAME string "SupportedOperatingModes" the name of this attribute
--- @field public data_type Bitmap16 the data type of this attribute
--- @field public NORMAL_MODE_SUPPORTED number 1
--- @field public VACATION_MODE_SUPPORTED number 2
--- @field public PRIVACY_MODE_SUPPORTED number 4
--- @field public NO_RF_LOCK_OR_UNLOCK_MODE_SUPPORTED number 8
--- @field public PASSAGE_MODE_SUPPORTED number 16
local SupportedOperatingModes = {
  ID = 0x0026,
  NAME = "SupportedOperatingModes",
  base_type = data_types.Bitmap16,
}

SupportedOperatingModes.BASE_MASK                           = 0xFFFF
SupportedOperatingModes.NORMAL_MODE_SUPPORTED               = 0x0001
SupportedOperatingModes.VACATION_MODE_SUPPORTED             = 0x0002
SupportedOperatingModes.PRIVACY_MODE_SUPPORTED              = 0x0004
SupportedOperatingModes.NO_RF_LOCK_OR_UNLOCK_MODE_SUPPORTED = 0x0008
SupportedOperatingModes.PASSAGE_MODE_SUPPORTED              = 0x0010


SupportedOperatingModes.mask_fields = {
  BASE_MASK = 0xFFFF,
  NORMAL_MODE_SUPPORTED = 0x0001,
  VACATION_MODE_SUPPORTED = 0x0002,
  PRIVACY_MODE_SUPPORTED = 0x0004,
  NO_RF_LOCK_OR_UNLOCK_MODE_SUPPORTED = 0x0008,
  PASSAGE_MODE_SUPPORTED = 0x0010,
}


--- @function SupportedOperatingModes:is_normal_mode_supported_set
--- @return boolean True if the value of NORMAL_MODE_SUPPORTED is non-zero
SupportedOperatingModes.is_normal_mode_supported_set = function(self)
  return (self.value & self.NORMAL_MODE_SUPPORTED) ~= 0
end
 
--- @function SupportedOperatingModes:set_normal_mode_supported
--- Set the value of the bit in the NORMAL_MODE_SUPPORTED field to 1
SupportedOperatingModes.set_normal_mode_supported = function(self)
  self.value = self.value | self.NORMAL_MODE_SUPPORTED
end

--- @function SupportedOperatingModes:unset_normal_mode_supported
--- Set the value of the bits in the NORMAL_MODE_SUPPORTED field to 0
SupportedOperatingModes.unset_normal_mode_supported = function(self)
  self.value = self.value & (~self.NORMAL_MODE_SUPPORTED & self.BASE_MASK)
end

--- @function SupportedOperatingModes:is_vacation_mode_supported_set
--- @return boolean True if the value of VACATION_MODE_SUPPORTED is non-zero
SupportedOperatingModes.is_vacation_mode_supported_set = function(self)
  return (self.value & self.VACATION_MODE_SUPPORTED) ~= 0
end
 
--- @function SupportedOperatingModes:set_vacation_mode_supported
--- Set the value of the bit in the VACATION_MODE_SUPPORTED field to 1
SupportedOperatingModes.set_vacation_mode_supported = function(self)
  self.value = self.value | self.VACATION_MODE_SUPPORTED
end

--- @function SupportedOperatingModes:unset_vacation_mode_supported
--- Set the value of the bits in the VACATION_MODE_SUPPORTED field to 0
SupportedOperatingModes.unset_vacation_mode_supported = function(self)
  self.value = self.value & (~self.VACATION_MODE_SUPPORTED & self.BASE_MASK)
end

--- @function SupportedOperatingModes:is_privacy_mode_supported_set
--- @return boolean True if the value of PRIVACY_MODE_SUPPORTED is non-zero
SupportedOperatingModes.is_privacy_mode_supported_set = function(self)
  return (self.value & self.PRIVACY_MODE_SUPPORTED) ~= 0
end
 
--- @function SupportedOperatingModes:set_privacy_mode_supported
--- Set the value of the bit in the PRIVACY_MODE_SUPPORTED field to 1
SupportedOperatingModes.set_privacy_mode_supported = function(self)
  self.value = self.value | self.PRIVACY_MODE_SUPPORTED
end

--- @function SupportedOperatingModes:unset_privacy_mode_supported
--- Set the value of the bits in the PRIVACY_MODE_SUPPORTED field to 0
SupportedOperatingModes.unset_privacy_mode_supported = function(self)
  self.value = self.value & (~self.PRIVACY_MODE_SUPPORTED & self.BASE_MASK)
end

--- @function SupportedOperatingModes:is_no_rf_lock_or_unlock_mode_supported_set
--- @return boolean True if the value of NO_RF_LOCK_OR_UNLOCK_MODE_SUPPORTED is non-zero
SupportedOperatingModes.is_no_rf_lock_or_unlock_mode_supported_set = function(self)
  return (self.value & self.NO_RF_LOCK_OR_UNLOCK_MODE_SUPPORTED) ~= 0
end
 
--- @function SupportedOperatingModes:set_no_rf_lock_or_unlock_mode_supported
--- Set the value of the bit in the NO_RF_LOCK_OR_UNLOCK_MODE_SUPPORTED field to 1
SupportedOperatingModes.set_no_rf_lock_or_unlock_mode_supported = function(self)
  self.value = self.value | self.NO_RF_LOCK_OR_UNLOCK_MODE_SUPPORTED
end

--- @function SupportedOperatingModes:unset_no_rf_lock_or_unlock_mode_supported
--- Set the value of the bits in the NO_RF_LOCK_OR_UNLOCK_MODE_SUPPORTED field to 0
SupportedOperatingModes.unset_no_rf_lock_or_unlock_mode_supported = function(self)
  self.value = self.value & (~self.NO_RF_LOCK_OR_UNLOCK_MODE_SUPPORTED & self.BASE_MASK)
end

--- @function SupportedOperatingModes:is_passage_mode_supported_set
--- @return boolean True if the value of PASSAGE_MODE_SUPPORTED is non-zero
SupportedOperatingModes.is_passage_mode_supported_set = function(self)
  return (self.value & self.PASSAGE_MODE_SUPPORTED) ~= 0
end
 
--- @function SupportedOperatingModes:set_passage_mode_supported
--- Set the value of the bit in the PASSAGE_MODE_SUPPORTED field to 1
SupportedOperatingModes.set_passage_mode_supported = function(self)
  self.value = self.value | self.PASSAGE_MODE_SUPPORTED
end

--- @function SupportedOperatingModes:unset_passage_mode_supported
--- Set the value of the bits in the PASSAGE_MODE_SUPPORTED field to 0
SupportedOperatingModes.unset_passage_mode_supported = function(self)
  self.value = self.value & (~self.PASSAGE_MODE_SUPPORTED & self.BASE_MASK)
end


SupportedOperatingModes.mask_methods = {
  is_normal_mode_supported_set = SupportedOperatingModes.is_normal_mode_supported_set,
  set_normal_mode_supported = SupportedOperatingModes.set_normal_mode_supported,
  unset_normal_mode_supported = SupportedOperatingModes.unset_normal_mode_supported,
  is_vacation_mode_supported_set = SupportedOperatingModes.is_vacation_mode_supported_set,
  set_vacation_mode_supported = SupportedOperatingModes.set_vacation_mode_supported,
  unset_vacation_mode_supported = SupportedOperatingModes.unset_vacation_mode_supported,
  is_privacy_mode_supported_set = SupportedOperatingModes.is_privacy_mode_supported_set,
  set_privacy_mode_supported = SupportedOperatingModes.set_privacy_mode_supported,
  unset_privacy_mode_supported = SupportedOperatingModes.unset_privacy_mode_supported,
  is_no_rf_lock_or_unlock_mode_supported_set = SupportedOperatingModes.is_no_rf_lock_or_unlock_mode_supported_set,
  set_no_rf_lock_or_unlock_mode_supported = SupportedOperatingModes.set_no_rf_lock_or_unlock_mode_supported,
  unset_no_rf_lock_or_unlock_mode_supported = SupportedOperatingModes.unset_no_rf_lock_or_unlock_mode_supported,
  is_passage_mode_supported_set = SupportedOperatingModes.is_passage_mode_supported_set,
  set_passage_mode_supported = SupportedOperatingModes.set_passage_mode_supported,
  unset_passage_mode_supported = SupportedOperatingModes.unset_passage_mode_supported,
}

--- Add additional functionality to the base type object
---
--- @param base_type_obj Bitmap16 the base data type object to add functionality to
function SupportedOperatingModes:augment_type(base_type_obj)
  for k, v in pairs(self.mask_fields) do
    base_type_obj[k] = v
  end
  for k, v in pairs(self.mask_methods) do
    base_type_obj[k] = v
  end
  
  base_type_obj.field_name = self.NAME
  base_type_obj.pretty_print = self.pretty_print
end

function SupportedOperatingModes.pretty_print(value_obj)
  local zb_utils = require "st.zigbee.utils" 
  local pattern = ">I" .. value_obj.byte_length
  return string.format("%s: %s[0x]", value_obj.field_name or value_obj.NAME, SupportedOperatingModes.NAME, zb_utils.pretty_print_hex_str(string.pack(pattern, value_obj.value)))
end

--- @function SupportedOperatingModes:build_test_attr_report
---
--- Build a Rx Zigbee message as if a device reported this attribute
--- @param device ZigbeeDevice
--- @param data Bitmap16 the attribute value
--- @return ZigbeeMessageRx containing an AttributeReport body
SupportedOperatingModes.build_test_attr_report = cluster_base.build_test_attr_report

--- @function SupportedOperatingModes:build_test_read_attr_response
---
--- Build a Rx Zigbee message as if a device sent a read response for this attribute
--- @param device ZigbeeDevice
--- @param data Bitmap16 the attribute value
--- @return ZigbeeMessageRx containing an ReadAttributeResponse body
SupportedOperatingModes.build_test_read_attr_response = cluster_base.build_test_read_attr_response

--- Create a Bitmap16 object of this attribute with any additional features provided for the attribute
---
--- This is also usable with the SupportedOperatingModes(...) syntax
---
--- @param ... vararg the values needed to construct a Bitmap16
--- @return Bitmap16
function SupportedOperatingModes:new_value(...)
    local o = self.base_type(table.unpack({...}))
    self:augment_type(o)
    return o
end

--- Construct a ZigbeeMessageTx to read this attribute from a device
---
--- @param device ZigbeeDevice
--- @return ZigbeeMessageTx containing a ReadAttribute body
function SupportedOperatingModes:read(device)
    return cluster_base.read_attribute(device, data_types.ClusterId(self._cluster.ID), data_types.AttributeId(self.ID))
end

--- Construct a ZigbeeMessageTx to configure this attribute for reporting on a device
---
--- @param device ZigbeeDevice
--- @param min_rep_int number|Uint16 the minimum interval allowed between reports of this attribute
--- @param max_rep_int number|Uint16 the maximum interval allowed between reports of this attribute
--- @return ZigbeeMessageTx containing a ConfigureReporting body
function SupportedOperatingModes:configure_reporting(device, min_rep_int, max_rep_int)
  local min = data_types.validate_or_build_type(min_rep_int, data_types.Uint16, "minimum_reporting_interval")
  local max = data_types.validate_or_build_type(max_rep_int, data_types.Uint16, "maximum_reporting_interval")
  local rep_change = nil
  return cluster_base.configure_reporting(device, data_types.ClusterId(self._cluster.ID), data_types.AttributeId(self.ID), data_types.ZigbeeDataType(self.base_type.ID), min, max, rep_change)
end

function SupportedOperatingModes:set_parent_cluster(cluster)
  self._cluster = cluster
  return self
end

setmetatable(SupportedOperatingModes, {__call = SupportedOperatingModes.new_value})
return SupportedOperatingModes
