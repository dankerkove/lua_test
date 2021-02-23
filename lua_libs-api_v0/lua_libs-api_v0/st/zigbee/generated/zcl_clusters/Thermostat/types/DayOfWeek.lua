local data_types = require "st.zigbee.data_types"
local BitmapABC = require "st.zigbee.data_types.base_defs.BitmapABC"

-- DO NOT EDIT: this code is automatically generated by tools/zigbee-lib_generator/generate_clusters_from_xml.py
-- Script version: b'2cda4a8ebeb3328f48b89dd179d4e8623e7ad8f1'
-- ZCL XML version: 7.2

--- @class st.zigbee.zcl.clusters.Thermostat.types.DayOfWeek : Bitmap8
--- @alias DayOfWeek
---
--- @field public byte_length number 1
--- @field public SUNDAY number 1
--- @field public MONDAY number 2
--- @field public TUESDAY number 4
--- @field public WEDNESDAY number 8
--- @field public THURSDAY number 16
--- @field public FRIDAY number 32
--- @field public SATURDAY number 64
--- @field public AWAY_OR_VACATION number 128
local DayOfWeek = {}
local new_mt = BitmapABC.new_mt({NAME = "DayOfWeek", ID = data_types.name_to_id_map["Bitmap8"]}, 1)
new_mt.__index.BASE_MASK        = 0xFF
new_mt.__index.SUNDAY           = 0x01
new_mt.__index.MONDAY           = 0x02
new_mt.__index.TUESDAY          = 0x04
new_mt.__index.WEDNESDAY        = 0x08
new_mt.__index.THURSDAY         = 0x10
new_mt.__index.FRIDAY           = 0x20
new_mt.__index.SATURDAY         = 0x40
new_mt.__index.AWAY_OR_VACATION = 0x80

--- @function DayOfWeek:is_sunday_set
--- @return boolean True if the value of SUNDAY is non-zero
new_mt.__index.is_sunday_set = function(self)
  return (self.value & self.SUNDAY) ~= 0
end
 
--- @function DayOfWeek:set_sunday
--- Set the value of the bit in the SUNDAY field to 1
new_mt.__index.set_sunday = function(self)
  self.value = self.value | self.SUNDAY
end

--- @function DayOfWeek:unset_sunday
--- Set the value of the bits in the SUNDAY field to 0
new_mt.__index.unset_sunday = function(self)
  self.value = self.value & (~self.SUNDAY & self.BASE_MASK)
end

--- @function DayOfWeek:is_monday_set
--- @return boolean True if the value of MONDAY is non-zero
new_mt.__index.is_monday_set = function(self)
  return (self.value & self.MONDAY) ~= 0
end
 
--- @function DayOfWeek:set_monday
--- Set the value of the bit in the MONDAY field to 1
new_mt.__index.set_monday = function(self)
  self.value = self.value | self.MONDAY
end

--- @function DayOfWeek:unset_monday
--- Set the value of the bits in the MONDAY field to 0
new_mt.__index.unset_monday = function(self)
  self.value = self.value & (~self.MONDAY & self.BASE_MASK)
end

--- @function DayOfWeek:is_tuesday_set
--- @return boolean True if the value of TUESDAY is non-zero
new_mt.__index.is_tuesday_set = function(self)
  return (self.value & self.TUESDAY) ~= 0
end
 
--- @function DayOfWeek:set_tuesday
--- Set the value of the bit in the TUESDAY field to 1
new_mt.__index.set_tuesday = function(self)
  self.value = self.value | self.TUESDAY
end

--- @function DayOfWeek:unset_tuesday
--- Set the value of the bits in the TUESDAY field to 0
new_mt.__index.unset_tuesday = function(self)
  self.value = self.value & (~self.TUESDAY & self.BASE_MASK)
end

--- @function DayOfWeek:is_wednesday_set
--- @return boolean True if the value of WEDNESDAY is non-zero
new_mt.__index.is_wednesday_set = function(self)
  return (self.value & self.WEDNESDAY) ~= 0
end
 
--- @function DayOfWeek:set_wednesday
--- Set the value of the bit in the WEDNESDAY field to 1
new_mt.__index.set_wednesday = function(self)
  self.value = self.value | self.WEDNESDAY
end

--- @function DayOfWeek:unset_wednesday
--- Set the value of the bits in the WEDNESDAY field to 0
new_mt.__index.unset_wednesday = function(self)
  self.value = self.value & (~self.WEDNESDAY & self.BASE_MASK)
end

--- @function DayOfWeek:is_thursday_set
--- @return boolean True if the value of THURSDAY is non-zero
new_mt.__index.is_thursday_set = function(self)
  return (self.value & self.THURSDAY) ~= 0
end
 
--- @function DayOfWeek:set_thursday
--- Set the value of the bit in the THURSDAY field to 1
new_mt.__index.set_thursday = function(self)
  self.value = self.value | self.THURSDAY
end

--- @function DayOfWeek:unset_thursday
--- Set the value of the bits in the THURSDAY field to 0
new_mt.__index.unset_thursday = function(self)
  self.value = self.value & (~self.THURSDAY & self.BASE_MASK)
end

--- @function DayOfWeek:is_friday_set
--- @return boolean True if the value of FRIDAY is non-zero
new_mt.__index.is_friday_set = function(self)
  return (self.value & self.FRIDAY) ~= 0
end
 
--- @function DayOfWeek:set_friday
--- Set the value of the bit in the FRIDAY field to 1
new_mt.__index.set_friday = function(self)
  self.value = self.value | self.FRIDAY
end

--- @function DayOfWeek:unset_friday
--- Set the value of the bits in the FRIDAY field to 0
new_mt.__index.unset_friday = function(self)
  self.value = self.value & (~self.FRIDAY & self.BASE_MASK)
end

--- @function DayOfWeek:is_saturday_set
--- @return boolean True if the value of SATURDAY is non-zero
new_mt.__index.is_saturday_set = function(self)
  return (self.value & self.SATURDAY) ~= 0
end
 
--- @function DayOfWeek:set_saturday
--- Set the value of the bit in the SATURDAY field to 1
new_mt.__index.set_saturday = function(self)
  self.value = self.value | self.SATURDAY
end

--- @function DayOfWeek:unset_saturday
--- Set the value of the bits in the SATURDAY field to 0
new_mt.__index.unset_saturday = function(self)
  self.value = self.value & (~self.SATURDAY & self.BASE_MASK)
end

--- @function DayOfWeek:is_away_or_vacation_set
--- @return boolean True if the value of AWAY_OR_VACATION is non-zero
new_mt.__index.is_away_or_vacation_set = function(self)
  return (self.value & self.AWAY_OR_VACATION) ~= 0
end
 
--- @function DayOfWeek:set_away_or_vacation
--- Set the value of the bit in the AWAY_OR_VACATION field to 1
new_mt.__index.set_away_or_vacation = function(self)
  self.value = self.value | self.AWAY_OR_VACATION
end

--- @function DayOfWeek:unset_away_or_vacation
--- Set the value of the bits in the AWAY_OR_VACATION field to 0
new_mt.__index.unset_away_or_vacation = function(self)
  self.value = self.value & (~self.AWAY_OR_VACATION & self.BASE_MASK)
end

setmetatable(DayOfWeek, new_mt)
return DayOfWeek
