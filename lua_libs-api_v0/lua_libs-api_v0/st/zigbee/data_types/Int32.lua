local IntABC = require "st.zigbee.data_types.base_defs.IntABC"

--- @class Int32: IntABC
--- @field public ID number 0x2B
--- @field public NAME string "Int32"
--- @field public byte_length number 4
--- @field public value number This is the actual value of the instance of the data type
local Int32 = {}
setmetatable(Int32, IntABC.new_mt({ NAME = "Int32", ID = 0x2B }, 4))

return Int32
