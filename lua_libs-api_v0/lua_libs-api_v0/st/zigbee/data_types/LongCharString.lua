local StringABC = require "st.zigbee.data_types.base_defs.StringABC"

--- @class LongCharString: StringABC
--- @field public ID number 0x44
--- @field public NAME string "LongCharString"
--- @field public length_byte_length number 2 (This is the number of bytes the length description takes)
--- @field public byte_length number the length of this string (not including the length bytes)
--- @field public value string The string representation of this field (note this does not include the length bytes)
local LongCharString = {}
setmetatable(LongCharString, StringABC.new_mt({NAME = "LongCharString", ID = 0x44}, 2))

return LongCharString
