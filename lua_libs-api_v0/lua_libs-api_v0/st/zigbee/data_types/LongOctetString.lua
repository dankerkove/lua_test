local StringABC = require "st.zigbee.data_types.base_defs.StringABC"

--- @class LongOctetString: StringABC
--- @field public ID number 0x43
--- @field public NAME string "LongOctetString"
--- @field public length_byte_length number 2 (This is the number of bytes the length description takes)
--- @field public byte_length number the length of this string (not including the length bytes)
--- @field public value string The string representation of this field (note this does not include the length bytes)
local LongOctetString = {}
setmetatable(LongOctetString, StringABC.new_mt({NAME = "LongOctetString", ID = 0x43}, 2))

return LongOctetString
