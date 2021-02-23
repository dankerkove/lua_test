local UintABC = require "st.zigbee.data_types.base_defs.UintABC"

--- @class BACNetOId: UintABC
--- @field public ID number 0xEA
--- @field public NAME string "BACNetOId"
--- @field public byte_length number 4
--- @field public value number The BACNetOId this represents
local BACNetOId = {}
setmetatable(BACNetOId, UintABC.new_mt({ NAME = "BACNetOId", ID = 0xEA, is_discrete = true }, 4))
