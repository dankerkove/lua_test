local BooleanABC = require "st.zigbee.data_types.base_defs.BooleanABC"

--- @class Boolean: BooleanABC
--- @field public ID number 0x10
--- @field public NAME string "Boolean"
--- @field public value boolean The value of this boolean data type
local Boolean = {}
setmetatable(Boolean, BooleanABC.new_mt({ NAME = "Boolean", ID = 0x10 }))

return Boolean
