local DataABC = require "st.zigbee.data_types.base_defs.DataABC"

--- @class Uint64: DataABC
--- Because lua only supports 64 bit numbers it is not possible to natively store a number that is
--- 64 bits long and unsigned.  So we actually inherit from the Data zigbee type and store the bytes
--- of the number directly. Thus usage of this will be different
--- @field public ID number 0x27
--- @field public NAME string "Uint64"
--- @field public byte_length number 8
--- @field public value string This is the actual value of the instance of the data type
local Uint64 = {}
setmetatable(Uint64, DataABC.new_mt({ NAME = "Uint64", ID = 0x27 }, 8))

return Uint64
