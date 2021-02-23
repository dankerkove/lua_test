local IntABC = require "st.zigbee.data_types.base_defs.IntABC"

--- @class Int56: IntABC
--- @field public ID number 0x2E
--- @field public NAME string "Int56"
--- @field public byte_length number 7
--- @field public value number This is the actual value of the instance of the data type
local Int56 = {}
setmetatable(Int56, IntABC.new_mt({ NAME = "Int56", ID = 0x2E }, 7))

return Int56
