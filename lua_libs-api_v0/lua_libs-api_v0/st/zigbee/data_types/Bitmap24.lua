local BitmapABC = require "st.zigbee.data_types.base_defs.BitmapABC"

--- @class Bitmap24: BitmapABC
--- @field public ID number 0x1A
--- @field public NAME string "Bitmap24"
--- @field public byte_length number 3
--- @field public value number This is the actual value of the instance of the data type
local Bitmap24 = {}
setmetatable(Bitmap24, BitmapABC.new_mt({ NAME = "Bitmap24", ID = 0x1A }, 3))

return Bitmap24
