local UintABC = require "st.zigbee.data_types.base_defs.UintABC"

--- @class Uint56: UintABC
--- @field public ID number 0x26
--- @field public NAME string "Uint56"
--- @field public byte_length number 7
--- @field public value number This is the actual value of the instance of the data type
local Uint56 = {}
setmetatable(Uint56, UintABC.new_mt({ NAME = "Uint56", ID = 0x26 }, 7))

return Uint56
