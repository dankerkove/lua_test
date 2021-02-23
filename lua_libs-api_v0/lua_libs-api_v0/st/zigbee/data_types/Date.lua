local DateABC = require "st.zigbee.data_types.base_defs.DateABC"

--- @class Date: DateABC
--- @field public ID number 0xE1
--- @field public NAME string "Date"
--- @field public year Uint8 The year of this date (year - 1900, e.g. 119 for 2019)
--- @field public month Uint8 The month value of this date (1 - 12)
--- @field public day_of_month Uint8 The day of the month value of this date
--- @field public day_of_week Uint8 The day of week value of this date (1 - 7)
local Date = {}
setmetatable(Date, DateABC.new_mt({ NAME = "Date", ID = 0xE1 }))

return Date
