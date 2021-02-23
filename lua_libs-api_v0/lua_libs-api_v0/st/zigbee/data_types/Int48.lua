local IntABC = require "st.zigbee.data_types.base_defs.IntABC"

--- @class Int48: IntABC
--- @field public ID number 0x2D
--- @field public NAME string "Int48"
--- @field public byte_length number 6
--- @field public value number This is the actual value of the instance of the data type
local Int48 = {}
setmetatable(Int48, IntABC.new_mt({ NAME = "Int48", ID = 0x2D }, 6))

return Int48
