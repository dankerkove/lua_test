--- @type data_types
local data_types = require "st.zigbee.data_types"
local utils = require "st.zigbee.utils"

--- @module write_attr
local write_attr = {}

write_attr.WRITE_ATTRIBUTE_ID = 0x02

--- @class WriteAttributeAttributeRecord
---
--- A representation of the record of a single attributes write record
--- @field public NAME string "AttributeRecord"
--- @field public attr_id AttributeId the attribute ID for this record
--- @field public data_type ZigbeeDataType The data type of this attribute
--- @field public data DataType the parsed Zigbee data type of the ID represented by the data_type field
local WriteAttributeAttributeRecord = {
  NAME = "AttributeRecord",
}
WriteAttributeAttributeRecord.__index = WriteAttributeAttributeRecord
write_attr.WriteAttributeAttributeRecord = WriteAttributeAttributeRecord

--- Parse a WriteAttributeAttributeRecord from a byte string
--- @param buf Reader the buf to parse the record from
--- @return WriteAttributeAttributeRecord the parsed attribute record
function WriteAttributeAttributeRecord.deserialize(buf)
  local self = {}
  setmetatable(self, WriteAttributeAttributeRecord)
  self.attr_id = data_types.AttributeId.deserialize(buf)
  self.data_type = data_types.ZigbeeDataType.deserialize(buf)
  self.data = data_types.parse_data_type(self.data_type.value, buf, "data")
  return self
end

--- A helper function used by common code to get all the component pieces of this message frame
---@return table An array formatted table with each component field in the order their bytes should be serialized
function WriteAttributeAttributeRecord:get_fields()
  local out = {}
  out[#out + 1] = self.attr_id
  out[#out + 1] = self.data_type
  out[#out + 1] = self.data
  return out
end

--- @function WriteAttributeAttributeRecord:get_length
--- @return number the length of this WriteAttributeAttributeRecord in bytes
WriteAttributeAttributeRecord.get_length = utils.length_from_fields

--- @function WriteAttributeAttributeRecord:serialize
--- @return string this WriteAttributeAttributeRecord serialized
WriteAttributeAttributeRecord.serialize = utils.serialize_from_fields

--- @function WriteAttributeAttributeRecord:pretty_print
--- @return string this WriteAttributeAttributeRecord as a human readable string
WriteAttributeAttributeRecord.pretty_print = utils.print_from_fields
WriteAttributeAttributeRecord.__tostring = WriteAttributeAttributeRecord

--- Build a WriteAttributeAttributeRecord from its individual components
--- @param cls table UNUSED This is the class table when creating using class(...) syntax
--- @param attr_id AttributeId This can be either an AttributeId already built or just a number
--- @param data_type ZigbeeDataType This can be either a ZigbeeDataType already built or just a number
--- @param data DataType This can be either a built DataType or the value needed to build one
--- @return WriteAttributeAttributeRecord the constructed WriteAttributeAttributeRecord
function WriteAttributeAttributeRecord.init(cls, attr_id, data_type, data)
  local out = {}
  out.attr_id = data_types.validate_or_build_type(attr_id, data_types.AttributeId, "attr_id")
  out.data_type = data_types.validate_or_build_type(data_type, data_types.ZigbeeDataType, "data_type")
  out.data = data_types.validate_or_build_type(data, data_types.get_data_type_by_id(out.data_type.value), "data")
  setmetatable(out, WriteAttributeAttributeRecord)
  return out
end

setmetatable(write_attr.WriteAttributeAttributeRecord, {
  __call = WriteAttributeAttributeRecord.init
})

--- @class WriteAttribute
---
--- @field public NAME string "WriteAttribute"
--- @field public ID number 0x02 The ID of the WriteAttribute ZCL command
--- @field public attr_records WriteAttributeAttributeRecord[] the list of attribute records in this write command
local WriteAttribute = {
  ID = write_attr.WRITE_ATTRIBUTE_ID,
  NAME = "WriteAttribute",
  AttributeRecord = write_attr.WriteAttributeAttributeRecord
}
WriteAttribute.__index = WriteAttribute
write_attr.WriteAttribute = WriteAttribute

--- Parse a WriteAttribute command body from a byte string
--- @param buf Reader the buf to parse the record from
--- @return WriteAttribute the parsed write attribute command body
function WriteAttribute.deserialize(buf)
  local self = {}
  setmetatable(self, WriteAttribute)
  self.attr_records = {}
  while buf:remain() > 0 do
    self.attr_records[#self.attr_records + 1] = write_attr.WriteAttributeAttributeRecord.deserialize(buf)
  end
  return self
end

--- A helper function used by common code to get all the component pieces of this message frame
---@return table An array formatted table with each component field in the order their bytes should be serialized
function WriteAttribute:get_fields()
  return self.attr_records
end

--- @function WriteAttribute:get_length
--- @return number the length of this write attribute attribute record in bytes
WriteAttribute.get_length = utils.length_from_fields

--- @function WriteAttribute:serialize
--- @return string this WriteAttribute serialized
WriteAttribute.serialize = utils.serialize_from_fields

--- @function WriteAttribute:pretty_print
--- @return string this WriteAttribute as a human readable string
WriteAttribute.pretty_print = utils.print_from_fields
WriteAttribute.__tostring = WriteAttribute.pretty_print

--- Build a WriteAttribute command from its individual components
--- @param cls table UNUSED This is the class table when creating using class(...) syntax
--- @param attr_records WriteAttributeAttributeRecord[] A list of the WriteAttributeAttributeRecords to write
--- @return WriteAttribute the constructed write attribute command body
function WriteAttribute.init(cls, attr_records)
  local out = {}
  setmetatable(out, WriteAttribute)
  for _, v in ipairs(attr_records) do
    if v.attr_id == nil or v.data_type == nil or v.data == nil then
      error("Write attribute records must be valid")
    end
  end
  out.attr_records = attr_records
  return out
end

setmetatable(write_attr.WriteAttribute, {
  __call = WriteAttribute.init
})
return write_attr
