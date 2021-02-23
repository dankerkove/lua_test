local StringABC = require "st.zigbee.data_types.base_defs.StringABC"

--- @class OctetString: StringABC
--- @field public ID number 0x41
--- @field public NAME string "OctetString"
--- @field public length_byte_length number 1 (This is the number of bytes the length description takes)
--- @field public byte_length number the length of this string (not including the length bytes)
--- @field public value string The string representation of this field (note this does not include the length bytes)
local OctetString = {}
setmetatable(OctetString, StringABC.new_mt({NAME = "OctetString", ID = 0x41}, 1))

return OctetString
