local UintABC = require "st.zigbee.data_types.base_defs.UintABC"

--- @class AttributeId: UintABC
--- @field public ID number 0xE9
--- @field public NAME string "AttributeId"
--- @field public byte_length number 2
--- @field public value number The attribute ID this represents
local AttributeId = {}
setmetatable(AttributeId, UintABC.new_mt({ NAME = "AttributeId", ID = 0xE9, is_discrete = true }, 2))

return AttributeId
