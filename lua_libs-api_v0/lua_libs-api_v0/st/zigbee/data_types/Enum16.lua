local EnumABC = require "st.zigbee.data_types.base_defs.EnumABC"

--- @class Enum16: EnumABC
--- @field public ID number 0x31
--- @field public NAME string "Enum16"
--- @field public byte_length number 2
--- @field public value number This is the actual value of the instance of the data type
local Enum16 = {}
setmetatable(Enum16, EnumABC.new_mt({ NAME = "Enum16", ID = 0x31 }, 2))

return Enum16
