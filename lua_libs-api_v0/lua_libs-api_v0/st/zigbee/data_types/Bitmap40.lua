local BitmapABC = require "st.zigbee.data_types.base_defs.BitmapABC"

--- @class Bitmap40: BitmapABC
--- @field public ID number 0x1C
--- @field public NAME string "Bitmap40"
--- @field public byte_length number 5
--- @field public value number This is the actual value of the instance of the data type
local Bitmap40 = {}
setmetatable(Bitmap40, BitmapABC.new_mt({ NAME = "Bitmap40", ID = 0x1C }, 5))

return Bitmap40
