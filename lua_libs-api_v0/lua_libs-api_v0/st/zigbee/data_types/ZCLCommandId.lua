local UintABC = require "st.zigbee.data_types.base_defs.UintABC"

--- @class ZCLCommandId: UintABC
--- A representation of a field in a Zigbee message providing the ID of a Zigbee ZCL Command.  As this command
--- ID could represent a manufacturer/cluster specific command the value is not validated against a specific list.
--- @field public NAME string "ZCLCommandId"
--- @field public byte_length number 1
--- @field public value number This is the ID of a ZCL command
local ZCLCommandId = {}
setmetatable(ZCLCommandId, UintABC.new_mt({ NAME = "ZCLCommandId" }, 1))

return ZCLCommandId
