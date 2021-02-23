local IntABC = require "st.zigbee.data_types.base_defs.IntABC"

--- @class Int40: IntABC
--- @field public ID number 0x2C
--- @field public NAME string "Int40"
--- @field public byte_length number 5
--- @field public value number This is the actual value of the instance of the data type
local Int40 = {}
setmetatable(Int40, IntABC.new_mt({ NAME = "Int40", ID = 0x2C }, 5))

return Int40
