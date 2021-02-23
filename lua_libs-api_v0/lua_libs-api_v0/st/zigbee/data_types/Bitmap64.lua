local DataABC = require "st.zigbee.data_types.base_defs.DataABC"

--- @class Bitmap64: DataABC
--- @field public ID number 0x1F
--- @field public NAME string "Bitmap64"
--- @field public byte_length number 8
--- @field public value string These are the bytes of this field
local Bitmap64 = {}
setmetatable(Bitmap64, DataABC.new_mt({ NAME = "Bitmap64", ID = 0x1F }, 8))

return Bitmap64
