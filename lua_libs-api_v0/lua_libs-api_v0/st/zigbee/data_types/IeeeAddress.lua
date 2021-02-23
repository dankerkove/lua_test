local DataABC = require "st.zigbee.data_types.base_defs.DataABC"

--- @class IeeeAddress: DataABC
--- @field public ID number 0xF0
--- @field public NAME string "IEEEAddress"
--- @field public byte_length number 8
--- @field public value string The bytes of this IEEEAddress
local IeeeAddress = {}
setmetatable(IeeeAddress, DataABC.new_mt({ NAME = "IEEEAddress", ID = 0xF0 }, 8))
return IeeeAddress
