local DataABC = require "st.zigbee.data_types.base_defs.DataABC"

--- @class Data64: DataABC
--- @field public ID number 0x0F
--- @field public NAME string "Data64"
--- @field public byte_length number 8
--- @field public value string The raw bytes of this data field
local Data64 = {}
setmetatable(Data64, DataABC.new_mt({ NAME = "Data64", ID = 0x0F }, 8))

return Data64
