local DataABC = require "st.zigbee.data_types.base_defs.DataABC"

--- @class Data48: DataABC
--- @field public ID number 0x0D
--- @field public NAME string "Data48"
--- @field public byte_length number 6
--- @field public value string The raw bytes of this data field
local Data48 = {}
setmetatable(Data48, DataABC.new_mt({ NAME = "Data48", ID = 0x0D }, 6))

return Data48
