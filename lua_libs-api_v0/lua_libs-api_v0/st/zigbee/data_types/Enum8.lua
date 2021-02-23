local EnumABC = require "st.zigbee.data_types.base_defs.EnumABC"

--- @class Enum8: EnumABC
--- @field public ID number 0x30
--- @field public NAME string "Enum8"
--- @field public byte_length number 1
--- @field public value number This is the actual value of the instance of the data type
local Enum8 = {}
setmetatable(Enum8, EnumABC.new_mt({ NAME = "Enum8", ID = 0x30 }, 1))

return Enum8
