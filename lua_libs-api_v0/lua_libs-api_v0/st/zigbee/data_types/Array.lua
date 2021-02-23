local ArrayABC = require "st.zigbee.data_types.base_defs.ArrayABC"

--- @class Array: ArrayABC
--- @field public ID number 0x48
--- @field public NAME string "Array"
--- @field public value table the list of elements in this array
local Array = {}
setmetatable(Array, ArrayABC.new_mt({ NAME = "Array", ID = 0x48 }))

return Array
