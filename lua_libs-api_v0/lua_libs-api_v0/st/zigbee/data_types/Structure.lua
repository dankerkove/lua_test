local StructureABC = require "st.zigbee.data_types.base_defs.StructureABC"

--- @class Structure: StructureABC
--- @field public ID number 0x4C
--- @field public NAME string "Structure"
--- @field public value table the list of elements in this structure
local Structure = {}
setmetatable(Structure, StructureABC.new_mt({ NAME = "Structure", ID = 0x4C }))

return Structure
