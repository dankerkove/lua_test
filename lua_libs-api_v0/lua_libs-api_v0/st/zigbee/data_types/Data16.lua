local DataABC = require "st.zigbee.data_types.base_defs.DataABC"

--- @class Data16: DataABC
--- @field public ID number 0x09
--- @field public NAME string "Data16"
--- @field public byte_length number 2
--- @field public value string The raw bytes of this data field
local Data16 = {}
setmetatable(Data16, DataABC.new_mt({ NAME = "Data16", ID = 0x09 }, 2))

return Data16
