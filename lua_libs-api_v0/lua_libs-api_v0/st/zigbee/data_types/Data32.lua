local DataABC = require "st.zigbee.data_types.base_defs.DataABC"

--- @class Data32: DataABC
--- @field public ID number 0x0B
--- @field public NAME string "Data32"
--- @field public byte_length number 4
--- @field public value string The raw bytes of this data field
local Data32 = {}
setmetatable(Data32, DataABC.new_mt({ NAME = "Data32", ID = 0x0B }, 4))

return Data32
