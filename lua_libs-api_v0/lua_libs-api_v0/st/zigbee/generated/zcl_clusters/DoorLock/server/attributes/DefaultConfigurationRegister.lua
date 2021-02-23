local cluster_base = require "st.zigbee.cluster_base"
local data_types = require "st.zigbee.data_types"

-- DO NOT EDIT: this code is automatically generated by tools/zigbee-lib_generator/generate_clusters_from_xml.py
-- Script version: b'2cda4a8ebeb3328f48b89dd179d4e8623e7ad8f1'
-- ZCL XML version: 7.2

--- @class st.zigbee.zcl.clusters.DoorLock.DefaultConfigurationRegister
--- @alias DefaultConfigurationRegister
---
--- @field public ID number 0x0027 the ID of this attribute
--- @field public NAME string "DefaultConfigurationRegister" the name of this attribute
--- @field public data_type Bitmap16 the data type of this attribute
--- @field public DEFAULT_ENABLE_LOCAL_PROGRAMMING_ATTRIBUTE_IS_ENABLED number 1
--- @field public DEFAULT_KEYPAD_INTERFACE_IS_ENABLED number 2
--- @field public DEFAULT_RF_INTERFACE_IS_ENABLED number 4
--- @field public DEFAULT_SOUND_VOLUME_IS_ENABLED number 32
--- @field public DEFAULT_AUTO_RELOCK_TIME_IS_ENABLED number 64
--- @field public DEFAULT_LED_SETTINGS_IS_ENABLED number 128
local DefaultConfigurationRegister = {
  ID = 0x0027,
  NAME = "DefaultConfigurationRegister",
  base_type = data_types.Bitmap16,
}

DefaultConfigurationRegister.BASE_MASK                                             = 0xFFFF
DefaultConfigurationRegister.DEFAULT_ENABLE_LOCAL_PROGRAMMING_ATTRIBUTE_IS_ENABLED = 0x0001
DefaultConfigurationRegister.DEFAULT_KEYPAD_INTERFACE_IS_ENABLED                   = 0x0002
DefaultConfigurationRegister.DEFAULT_RF_INTERFACE_IS_ENABLED                       = 0x0004
DefaultConfigurationRegister.DEFAULT_SOUND_VOLUME_IS_ENABLED                       = 0x0020
DefaultConfigurationRegister.DEFAULT_AUTO_RELOCK_TIME_IS_ENABLED                   = 0x0040
DefaultConfigurationRegister.DEFAULT_LED_SETTINGS_IS_ENABLED                       = 0x0080


DefaultConfigurationRegister.mask_fields = {
  BASE_MASK = 0xFFFF,
  DEFAULT_ENABLE_LOCAL_PROGRAMMING_ATTRIBUTE_IS_ENABLED = 0x0001,
  DEFAULT_KEYPAD_INTERFACE_IS_ENABLED = 0x0002,
  DEFAULT_RF_INTERFACE_IS_ENABLED = 0x0004,
  DEFAULT_SOUND_VOLUME_IS_ENABLED = 0x0020,
  DEFAULT_AUTO_RELOCK_TIME_IS_ENABLED = 0x0040,
  DEFAULT_LED_SETTINGS_IS_ENABLED = 0x0080,
}


--- @function DefaultConfigurationRegister:is_default_enable_local_programming_attribute_is_enabled_set
--- @return boolean True if the value of DEFAULT_ENABLE_LOCAL_PROGRAMMING_ATTRIBUTE_IS_ENABLED is non-zero
DefaultConfigurationRegister.is_default_enable_local_programming_attribute_is_enabled_set = function(self)
  return (self.value & self.DEFAULT_ENABLE_LOCAL_PROGRAMMING_ATTRIBUTE_IS_ENABLED) ~= 0
end
 
--- @function DefaultConfigurationRegister:set_default_enable_local_programming_attribute_is_enabled
--- Set the value of the bit in the DEFAULT_ENABLE_LOCAL_PROGRAMMING_ATTRIBUTE_IS_ENABLED field to 1
DefaultConfigurationRegister.set_default_enable_local_programming_attribute_is_enabled = function(self)
  self.value = self.value | self.DEFAULT_ENABLE_LOCAL_PROGRAMMING_ATTRIBUTE_IS_ENABLED
end

--- @function DefaultConfigurationRegister:unset_default_enable_local_programming_attribute_is_enabled
--- Set the value of the bits in the DEFAULT_ENABLE_LOCAL_PROGRAMMING_ATTRIBUTE_IS_ENABLED field to 0
DefaultConfigurationRegister.unset_default_enable_local_programming_attribute_is_enabled = function(self)
  self.value = self.value & (~self.DEFAULT_ENABLE_LOCAL_PROGRAMMING_ATTRIBUTE_IS_ENABLED & self.BASE_MASK)
end

--- @function DefaultConfigurationRegister:is_default_keypad_interface_is_enabled_set
--- @return boolean True if the value of DEFAULT_KEYPAD_INTERFACE_IS_ENABLED is non-zero
DefaultConfigurationRegister.is_default_keypad_interface_is_enabled_set = function(self)
  return (self.value & self.DEFAULT_KEYPAD_INTERFACE_IS_ENABLED) ~= 0
end
 
--- @function DefaultConfigurationRegister:set_default_keypad_interface_is_enabled
--- Set the value of the bit in the DEFAULT_KEYPAD_INTERFACE_IS_ENABLED field to 1
DefaultConfigurationRegister.set_default_keypad_interface_is_enabled = function(self)
  self.value = self.value | self.DEFAULT_KEYPAD_INTERFACE_IS_ENABLED
end

--- @function DefaultConfigurationRegister:unset_default_keypad_interface_is_enabled
--- Set the value of the bits in the DEFAULT_KEYPAD_INTERFACE_IS_ENABLED field to 0
DefaultConfigurationRegister.unset_default_keypad_interface_is_enabled = function(self)
  self.value = self.value & (~self.DEFAULT_KEYPAD_INTERFACE_IS_ENABLED & self.BASE_MASK)
end

--- @function DefaultConfigurationRegister:is_default_rf_interface_is_enabled_set
--- @return boolean True if the value of DEFAULT_RF_INTERFACE_IS_ENABLED is non-zero
DefaultConfigurationRegister.is_default_rf_interface_is_enabled_set = function(self)
  return (self.value & self.DEFAULT_RF_INTERFACE_IS_ENABLED) ~= 0
end
 
--- @function DefaultConfigurationRegister:set_default_rf_interface_is_enabled
--- Set the value of the bit in the DEFAULT_RF_INTERFACE_IS_ENABLED field to 1
DefaultConfigurationRegister.set_default_rf_interface_is_enabled = function(self)
  self.value = self.value | self.DEFAULT_RF_INTERFACE_IS_ENABLED
end

--- @function DefaultConfigurationRegister:unset_default_rf_interface_is_enabled
--- Set the value of the bits in the DEFAULT_RF_INTERFACE_IS_ENABLED field to 0
DefaultConfigurationRegister.unset_default_rf_interface_is_enabled = function(self)
  self.value = self.value & (~self.DEFAULT_RF_INTERFACE_IS_ENABLED & self.BASE_MASK)
end

--- @function DefaultConfigurationRegister:is_default_sound_volume_is_enabled_set
--- @return boolean True if the value of DEFAULT_SOUND_VOLUME_IS_ENABLED is non-zero
DefaultConfigurationRegister.is_default_sound_volume_is_enabled_set = function(self)
  return (self.value & self.DEFAULT_SOUND_VOLUME_IS_ENABLED) ~= 0
end
 
--- @function DefaultConfigurationRegister:set_default_sound_volume_is_enabled
--- Set the value of the bit in the DEFAULT_SOUND_VOLUME_IS_ENABLED field to 1
DefaultConfigurationRegister.set_default_sound_volume_is_enabled = function(self)
  self.value = self.value | self.DEFAULT_SOUND_VOLUME_IS_ENABLED
end

--- @function DefaultConfigurationRegister:unset_default_sound_volume_is_enabled
--- Set the value of the bits in the DEFAULT_SOUND_VOLUME_IS_ENABLED field to 0
DefaultConfigurationRegister.unset_default_sound_volume_is_enabled = function(self)
  self.value = self.value & (~self.DEFAULT_SOUND_VOLUME_IS_ENABLED & self.BASE_MASK)
end

--- @function DefaultConfigurationRegister:is_default_auto_relock_time_is_enabled_set
--- @return boolean True if the value of DEFAULT_AUTO_RELOCK_TIME_IS_ENABLED is non-zero
DefaultConfigurationRegister.is_default_auto_relock_time_is_enabled_set = function(self)
  return (self.value & self.DEFAULT_AUTO_RELOCK_TIME_IS_ENABLED) ~= 0
end
 
--- @function DefaultConfigurationRegister:set_default_auto_relock_time_is_enabled
--- Set the value of the bit in the DEFAULT_AUTO_RELOCK_TIME_IS_ENABLED field to 1
DefaultConfigurationRegister.set_default_auto_relock_time_is_enabled = function(self)
  self.value = self.value | self.DEFAULT_AUTO_RELOCK_TIME_IS_ENABLED
end

--- @function DefaultConfigurationRegister:unset_default_auto_relock_time_is_enabled
--- Set the value of the bits in the DEFAULT_AUTO_RELOCK_TIME_IS_ENABLED field to 0
DefaultConfigurationRegister.unset_default_auto_relock_time_is_enabled = function(self)
  self.value = self.value & (~self.DEFAULT_AUTO_RELOCK_TIME_IS_ENABLED & self.BASE_MASK)
end

--- @function DefaultConfigurationRegister:is_default_led_settings_is_enabled_set
--- @return boolean True if the value of DEFAULT_LED_SETTINGS_IS_ENABLED is non-zero
DefaultConfigurationRegister.is_default_led_settings_is_enabled_set = function(self)
  return (self.value & self.DEFAULT_LED_SETTINGS_IS_ENABLED) ~= 0
end
 
--- @function DefaultConfigurationRegister:set_default_led_settings_is_enabled
--- Set the value of the bit in the DEFAULT_LED_SETTINGS_IS_ENABLED field to 1
DefaultConfigurationRegister.set_default_led_settings_is_enabled = function(self)
  self.value = self.value | self.DEFAULT_LED_SETTINGS_IS_ENABLED
end

--- @function DefaultConfigurationRegister:unset_default_led_settings_is_enabled
--- Set the value of the bits in the DEFAULT_LED_SETTINGS_IS_ENABLED field to 0
DefaultConfigurationRegister.unset_default_led_settings_is_enabled = function(self)
  self.value = self.value & (~self.DEFAULT_LED_SETTINGS_IS_ENABLED & self.BASE_MASK)
end


DefaultConfigurationRegister.mask_methods = {
  is_default_enable_local_programming_attribute_is_enabled_set = DefaultConfigurationRegister.is_default_enable_local_programming_attribute_is_enabled_set,
  set_default_enable_local_programming_attribute_is_enabled = DefaultConfigurationRegister.set_default_enable_local_programming_attribute_is_enabled,
  unset_default_enable_local_programming_attribute_is_enabled = DefaultConfigurationRegister.unset_default_enable_local_programming_attribute_is_enabled,
  is_default_keypad_interface_is_enabled_set = DefaultConfigurationRegister.is_default_keypad_interface_is_enabled_set,
  set_default_keypad_interface_is_enabled = DefaultConfigurationRegister.set_default_keypad_interface_is_enabled,
  unset_default_keypad_interface_is_enabled = DefaultConfigurationRegister.unset_default_keypad_interface_is_enabled,
  is_default_rf_interface_is_enabled_set = DefaultConfigurationRegister.is_default_rf_interface_is_enabled_set,
  set_default_rf_interface_is_enabled = DefaultConfigurationRegister.set_default_rf_interface_is_enabled,
  unset_default_rf_interface_is_enabled = DefaultConfigurationRegister.unset_default_rf_interface_is_enabled,
  is_default_sound_volume_is_enabled_set = DefaultConfigurationRegister.is_default_sound_volume_is_enabled_set,
  set_default_sound_volume_is_enabled = DefaultConfigurationRegister.set_default_sound_volume_is_enabled,
  unset_default_sound_volume_is_enabled = DefaultConfigurationRegister.unset_default_sound_volume_is_enabled,
  is_default_auto_relock_time_is_enabled_set = DefaultConfigurationRegister.is_default_auto_relock_time_is_enabled_set,
  set_default_auto_relock_time_is_enabled = DefaultConfigurationRegister.set_default_auto_relock_time_is_enabled,
  unset_default_auto_relock_time_is_enabled = DefaultConfigurationRegister.unset_default_auto_relock_time_is_enabled,
  is_default_led_settings_is_enabled_set = DefaultConfigurationRegister.is_default_led_settings_is_enabled_set,
  set_default_led_settings_is_enabled = DefaultConfigurationRegister.set_default_led_settings_is_enabled,
  unset_default_led_settings_is_enabled = DefaultConfigurationRegister.unset_default_led_settings_is_enabled,
}

--- Add additional functionality to the base type object
---
--- @param base_type_obj Bitmap16 the base data type object to add functionality to
function DefaultConfigurationRegister:augment_type(base_type_obj)
  for k, v in pairs(self.mask_fields) do
    base_type_obj[k] = v
  end
  for k, v in pairs(self.mask_methods) do
    base_type_obj[k] = v
  end
  
  base_type_obj.field_name = self.NAME
  base_type_obj.pretty_print = self.pretty_print
end

function DefaultConfigurationRegister.pretty_print(value_obj)
  local zb_utils = require "st.zigbee.utils" 
  local pattern = ">I" .. value_obj.byte_length
  return string.format("%s: %s[0x]", value_obj.field_name or value_obj.NAME, DefaultConfigurationRegister.NAME, zb_utils.pretty_print_hex_str(string.pack(pattern, value_obj.value)))
end

--- @function DefaultConfigurationRegister:build_test_attr_report
---
--- Build a Rx Zigbee message as if a device reported this attribute
--- @param device ZigbeeDevice
--- @param data Bitmap16 the attribute value
--- @return ZigbeeMessageRx containing an AttributeReport body
DefaultConfigurationRegister.build_test_attr_report = cluster_base.build_test_attr_report

--- @function DefaultConfigurationRegister:build_test_read_attr_response
---
--- Build a Rx Zigbee message as if a device sent a read response for this attribute
--- @param device ZigbeeDevice
--- @param data Bitmap16 the attribute value
--- @return ZigbeeMessageRx containing an ReadAttributeResponse body
DefaultConfigurationRegister.build_test_read_attr_response = cluster_base.build_test_read_attr_response

--- Create a Bitmap16 object of this attribute with any additional features provided for the attribute
---
--- This is also usable with the DefaultConfigurationRegister(...) syntax
---
--- @param ... vararg the values needed to construct a Bitmap16
--- @return Bitmap16
function DefaultConfigurationRegister:new_value(...)
    local o = self.base_type(table.unpack({...}))
    self:augment_type(o)
    return o
end

--- Construct a ZigbeeMessageTx to read this attribute from a device
---
--- @param device ZigbeeDevice
--- @return ZigbeeMessageTx containing a ReadAttribute body
function DefaultConfigurationRegister:read(device)
    return cluster_base.read_attribute(device, data_types.ClusterId(self._cluster.ID), data_types.AttributeId(self.ID))
end

--- Construct a ZigbeeMessageTx to configure this attribute for reporting on a device
---
--- @param device ZigbeeDevice
--- @param min_rep_int number|Uint16 the minimum interval allowed between reports of this attribute
--- @param max_rep_int number|Uint16 the maximum interval allowed between reports of this attribute
--- @return ZigbeeMessageTx containing a ConfigureReporting body
function DefaultConfigurationRegister:configure_reporting(device, min_rep_int, max_rep_int)
  local min = data_types.validate_or_build_type(min_rep_int, data_types.Uint16, "minimum_reporting_interval")
  local max = data_types.validate_or_build_type(max_rep_int, data_types.Uint16, "maximum_reporting_interval")
  local rep_change = nil
  return cluster_base.configure_reporting(device, data_types.ClusterId(self._cluster.ID), data_types.AttributeId(self.ID), data_types.ZigbeeDataType(self.base_type.ID), min, max, rep_change)
end

function DefaultConfigurationRegister:set_parent_cluster(cluster)
  self._cluster = cluster
  return self
end

setmetatable(DefaultConfigurationRegister, {__call = DefaultConfigurationRegister.new_value})
return DefaultConfigurationRegister
