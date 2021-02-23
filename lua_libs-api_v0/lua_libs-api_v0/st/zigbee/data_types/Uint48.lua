local UintABC = require "st.zigbee.data_types.base_defs.UintABC"

--- @class Uint48: UintABC
--- @field public ID number 0x25
--- @field public NAME string "Uint48"
--- @field public byte_length number 6
--- @field public value number This is the actual value of the instance of the data type
local Uint48 = {}
setmetatable(Uint48, UintABC.new_mt({ NAME = "Uint48", ID = 0x25 }, 6))

return Uint48
