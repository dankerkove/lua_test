local UintABC = require "st.zigbee.data_types.base_defs.UintABC"

--- @class Uint40: UintABC
--- @field public ID number 0x24
--- @field public NAME string "Uint40"
--- @field public byte_length number 5
--- @field public value number This is the actual value of the instance of the data type
local Uint40 = {}
setmetatable(Uint40, UintABC.new_mt({ NAME = "Uint40", ID = 0x24 }, 5))

return Uint40
