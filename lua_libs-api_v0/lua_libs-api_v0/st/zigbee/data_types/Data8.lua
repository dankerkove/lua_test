local DataABC = require "st.zigbee.data_types.base_defs.DataABC"

--- @class Data8: DataABC
--- @field public ID number 0x08
--- @field public NAME string "Data8"
--- @field public byte_length number 1
--- @field public value string The raw bytes of this data field
local Data8 = {}
setmetatable(Data8, DataABC.new_mt({ NAME = "Data8", ID = 0x08 }, 1))

return Data8
