local IntABC = require "st.zigbee.data_types.base_defs.IntABC"

--- @class Int16: IntABC
--- @field public ID number 0x29
--- @field public NAME string "Int16"
--- @field public byte_length number 1
--- @field public value number This is the actual value of the instance of the data type
local Int16 = {}
setmetatable(Int16, IntABC.new_mt({ NAME = "Int16", ID = 0x29 }, 2))

return Int16
