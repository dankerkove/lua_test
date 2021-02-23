local IntABC = require "st.zigbee.data_types.base_defs.IntABC"

--- @class Int8: IntABC
--- @field public ID number 0x28
--- @field public NAME string "Int8"
--- @field public byte_length number 1
--- @field public value number This is the actual value of the instance of the data type
local Int8 = {}
setmetatable(Int8, IntABC.new_mt({ NAME = "Int8", ID = 0x28 }, 1))

return Int8
