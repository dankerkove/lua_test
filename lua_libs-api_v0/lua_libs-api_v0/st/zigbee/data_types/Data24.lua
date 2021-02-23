local DataABC = require "st.zigbee.data_types.base_defs.DataABC"

--- @class Data24: DataABC
--- @field public ID number 0x0A
--- @field public NAME string "Data24"
--- @field public byte_length number 3
--- @field public value string The raw bytes of this data field
local Data24 = {}
setmetatable(Data24, DataABC.new_mt({ NAME = "Data24", ID = 0x0A }, 3))

return Data24
