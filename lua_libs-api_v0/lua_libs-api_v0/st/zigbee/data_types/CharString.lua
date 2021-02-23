local StringABC = require "st.zigbee.data_types.base_defs.StringABC"

--- @class CharString: StringABC
--- @field public ID number 0x42
--- @field public NAME string "CharString"
--- @field public length_byte_length number 1 (This is the number of bytes the length description takes)
--- @field public byte_length number the length of this string (not including the length bytes)
--- @field public value string The string representation of this field (note this does not include the length bytes)
local CharString = {}
setmetatable(CharString, StringABC.new_mt({NAME = "CharString", ID = 0x42}, 1))

return CharString
