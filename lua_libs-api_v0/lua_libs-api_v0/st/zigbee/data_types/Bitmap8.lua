local BitmapABC = require "st.zigbee.data_types.base_defs.BitmapABC"

--- @class Bitmap8: BitmapABC
--- @field public ID number 0x18
--- @field public NAME string "Bitmap8"
--- @field public byte_length number 1
--- @field public value number This is the actual value of the instance of the data type
local Bitmap8 = {}
setmetatable(Bitmap8, BitmapABC.new_mt({ NAME = "Bitmap8", ID = 0x18 }, 1))

return Bitmap8
