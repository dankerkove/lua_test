local UintABC = require "st.zigbee.data_types.base_defs.UintABC"

--- @class Uint8: UintABC
--- @field public ID number 0x20
--- @field public NAME string "Uint8"
--- @field public byte_length number 1
--- @field public value number This is the actual value of the instance of the data type
local Uint8 = {}
setmetatable(Uint8, UintABC.new_mt({ NAME = "Uint8", ID = 0x20 }, 1))

return Uint8
