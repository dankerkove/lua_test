local DataABC = require "st.zigbee.data_types.base_defs.DataABC"

--- @class Data40: DataABC
--- @field public ID number 0x0C
--- @field public NAME string "Data40"
--- @field public byte_length number 5
--- @field public value string The raw bytes of this data field
local Data40 = {}
setmetatable(Data40, DataABC.new_mt({ NAME = "Data40", ID = 0x0C }, 5))

return Data40
