local DataABC = require "st.zigbee.data_types.base_defs.DataABC"

--- @class Data56: DataABC
--- @field public ID number 0x0E
--- @field public NAME string "Data56"
--- @field public byte_length number 7
--- @field public value string The raw bytes of this data field
local Data56 = {}
setmetatable(Data56, DataABC.new_mt({ NAME = "Data56", ID = 0x0E }, 7))

return Data56
