local NoDataABC = require "st.zigbee.data_types.base_defs.NoDataABC"

--- @class NoData: NoDataABC
--- @field public ID number 0x00
--- @field public NAME string "NoData"
--- @field public value nil this data type has no body
local NoData = {}
setmetatable(NoData, NoDataABC.new_mt({NAME = "NoData", ID = 0x00}))

return NoData
