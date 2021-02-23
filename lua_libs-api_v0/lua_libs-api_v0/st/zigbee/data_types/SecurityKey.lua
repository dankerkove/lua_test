local DataABC = require "st.zigbee.data_types.base_defs.DataABC"

--- @class SecurityKey: DataABC
--- @field public ID number 0xF1
--- @field public NAME string "SecurityKey"
--- @field public byte_length number 16
--- @field public value string The bytes of this SecurityKey
local SecurityKey = {}
setmetatable(SecurityKey, DataABC.new_mt({ NAME = "SecurityKey", ID = 0xF1 }, 16))

