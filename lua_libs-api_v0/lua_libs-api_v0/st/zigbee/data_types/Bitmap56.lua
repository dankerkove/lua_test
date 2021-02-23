local BitmapABC = require "st.zigbee.data_types.base_defs.BitmapABC"

--- @class Bitmap56: BitmapABC
--- @field public ID number 0x1E
--- @field public NAME string "Bitmap56"
--- @field public byte_length number 7
--- @field public value number This is the actual value of the instance of the data type
local Bitmap56 = {}
setmetatable(Bitmap56, BitmapABC.new_mt({ NAME = "Bitmap56", ID = 0x1E }, 7))

return Bitmap56
