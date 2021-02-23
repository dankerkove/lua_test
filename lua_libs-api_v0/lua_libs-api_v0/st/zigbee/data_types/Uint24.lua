local UintABC = require "st.zigbee.data_types.base_defs.UintABC"

--- @class Uint24: UintABC
--- @field public ID number 0x22
--- @field public NAME string "Uint24"
--- @field public byte_length number 3
--- @field public value number This is the actual value of the instance of the data type
local Uint24 = {}
setmetatable(Uint24, UintABC.new_mt({ NAME = "Uint24", ID = 0x22 }, 3))

return Uint24
