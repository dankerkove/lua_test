local BitmapABC = require "st.zigbee.data_types.base_defs.BitmapABC"

--- @class Bitmap48: BitmapABC
--- @field public ID number 0x1D
--- @field public NAME string "Bitmap48"
--- @field public byte_length number 6
--- @field public value number This is the actual value of the instance of the data type
local Bitmap48 = {}
setmetatable(Bitmap48, BitmapABC.new_mt({ NAME = "Bitmap48", ID = 0x1D }, 6))

return Bitmap48
