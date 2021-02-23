local UintABC = require "st.zigbee.data_types.base_defs.UintABC"

--- @class UTCTime: UintABC
--- @field public ID number 0xE2
--- @field public NAME string "UTCTime"
--- @field public byte_length number 4
--- @field public value number The number of seconds since 0:0:0 Jan 1 2000
local UtcTime = {}
setmetatable(UtcTime, UintABC.new_mt({ NAME = "UTCTime", ID = 0xE2 }, 4))

return UtcTime
