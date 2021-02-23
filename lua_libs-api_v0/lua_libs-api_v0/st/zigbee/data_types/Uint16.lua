local UintABC = require "st.zigbee.data_types.base_defs.UintABC"

--- @class Uint16: UintABC
--- @field public ID number 0x21
--- @field public NAME string "Uint16"
--- @field public byte_length number 2
--- @field public value number This is the actual value of the instance of the data type
local Uint16 = {}
setmetatable(Uint16, UintABC.new_mt({ NAME = "Uint16", ID = 0x21 }, 2))

return Uint16
