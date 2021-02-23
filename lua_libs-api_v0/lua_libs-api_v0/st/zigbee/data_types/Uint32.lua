local UintABC = require "st.zigbee.data_types.base_defs.UintABC"

--- @class Uint32: UintABC
--- @field public ID number 0x23
--- @field public NAME string "Uint32"
--- @field public byte_length number 4
--- @field public value number This is the actual value of the instance of the data type
local Uint32 = {}
setmetatable(Uint32, UintABC.new_mt({ NAME = "Uint32", ID = 0x23 }, 4))

return Uint32
