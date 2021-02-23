local TimeOfDayABC = require "st.zigbee.data_types.base_defs.TimeOfDayABC"

--- @class TimeOfDay: TimeOfDayABC
--- @field public ID number 0xE0
--- @field public NAME string "TimeOfDay"
--- @field public hours Uint8 The hours value of this time
--- @field public minutes Uint8 The minutes value of this time
--- @field public seconds Uint8 The seconds value of this time
--- @field public hundredths Uint8 The hundredths value of this time
local TimeOfDay = {}
setmetatable(TimeOfDay, TimeOfDayABC.new_mt({ NAME = "TimeOfDay", ID = 0xE0 }))

return TimeOfDay
