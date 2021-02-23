local BitmapABC = require "st.zigbee.data_types.base_defs.BitmapABC"

--- @class Bitmap16: BitmapABC
--- @field public ID number 0x19
--- @field public NAME string "Bitmap16"
--- @field public byte_length number 2
--- @field public value number This is the actual value of the instance of the data type
local Bitmap16 = {}
setmetatable(Bitmap16, BitmapABC.new_mt({ NAME = "Bitmap16", ID = 0x19 }, 2))

return Bitmap16
