local IntABC = require "st.zigbee.data_types.base_defs.IntABC"

--- @class Int24: IntABC
--- @field public ID number 0x2A
--- @field public NAME string "Int24"
--- @field public byte_length number 3
--- @field public value number This is the actual value of the instance of the data type
local Int24 = {}
setmetatable(Int24, IntABC.new_mt({ NAME = "Int24", ID = 0x2A }, 3))

return Int24
