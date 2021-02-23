local BitmapABC = require "st.zigbee.data_types.base_defs.BitmapABC"

--- @class Bitmap32: BitmapABC
--- @field public ID number 0x1B
--- @field public NAME string "Bitmap32"
--- @field public byte_length number 4
--- @field public value number This is the actual value of the instance of the data type
local Bitmap32 = {}
setmetatable(Bitmap32, BitmapABC.new_mt({ NAME = "Bitmap32", ID = 0x1B }, 4))

return Bitmap32
