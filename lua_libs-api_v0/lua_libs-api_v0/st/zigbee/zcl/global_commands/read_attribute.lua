local data_types = require "st.zigbee.data_types"
local utils = require "st.zigbee.utils"

--- @module read_attr
local read_attr = {}

read_attr.READ_ATTRIBUTE_ID = 0x00

--- @class ReadAttribute
---
--- A ZCL message body representing a read attribute command
local ReadAttribute = {
  NAME = "ReadAttribute",
  ID = read_attr.READ_ATTRIBUTE_ID,
}
ReadAttribute.__index = ReadAttribute

--- create a ReadAttribute body from a byte string
--- @param buf Reader the bufto parse from
--- @return ReadAttribute the parsed instance
function ReadAttribute.deserialize(buf)
  local self = {}
  setmetatable(self, ReadAttribute)
  self.attr_ids = {}
  while buf:remain() > 0 do
    self.attr_ids[#self.attr_ids + 1] = data_types.AttributeId.deserialize(buf)
  end
  return self
end

--- A helper function used by common code to get all the component pieces of this message frame
---@return table An array formatted table with each component field in the order their bytes should be serialized
function ReadAttribute:get_fields()
  return self.attr_ids
end

--- @function ReadAttribute:get_length
--- @return number the length of this read attribute body in bytes
ReadAttribute.get_length = utils.length_from_fields

--- @function ReadAttribute:serialize
--- @return string this ReadAttribute serialized
ReadAttribute.serialize = utils.serialize_from_fields

--- @function ReadAttribute:pretty_print
--- @return string this ReadAttribute as a human readable string
ReadAttribute.pretty_print = utils.print_from_fields
ReadAttribute.__tostring = ReadAttribute.pretty_print

--- This is a function to build an read attribute from its individual components
--- @param orig table UNUSED This is the AddressHeader object when called with the syntax AddressHeader(...)
--- @param attr_ids AttributeId[] A list of the AttributeIds to be read
--- @return ReadAttribute the constructed read attribute command body
function ReadAttribute.init(orig, attr_ids)
  local self = {}
  setmetatable(self, ReadAttribute)
  local attrs = {}
  for _, v in ipairs(attr_ids) do
    if type(v) == "table" and v.ID ~= data_types.AttributeId.ID then
      error({ code = 1, msg = "Read Attributes should be a list of AttributeIds" }, 2)
    else
      attrs[#attrs + 1] = data_types.validate_or_build_type(v, data_types.AttributeId, "AttributeId")
    end
  end
  self.attr_ids = attrs
  return self
end

setmetatable(ReadAttribute, { __call = ReadAttribute.init } )

read_attr.ReadAttribute = ReadAttribute

return read_attr
