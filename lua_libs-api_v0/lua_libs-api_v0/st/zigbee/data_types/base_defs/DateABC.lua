local Uint8 = require "st.zigbee.data_types.Uint8"

--- @class DateABC: DataType
---
--- Classes being created using the DateABC class represent Zigbee data types whose lua "value" is stored
--- as a set of hours, minutes, seconds, and hundredths of seconds (all Uints)
local DateABC = {}

--- This function will create a new metatable with the appropriate functionality for a Zigbee Date
--- @param base table the base meta table, this will include the ID and NAME of the type being represented
--- @return table The meta table containing the functionality for this type class
function DateABC.new_mt(base)
    local mt = {}
    mt.__index = base or {}
    mt.__index.month_lookup = {
      [1] = "January",
      [2] = "February",
      [3] = "March",
      [4] = "April",
      [5] = "May",
      [6] = "June",
      [7] = "July",
      [8] = "August",
      [9] = "September",
      [10] = "October",
      [11] = "November",
      [12] = "December",
    }
    mt.__index.day_of_week_lookup = {
      [1] = "Monday",
      [2] = "Tuesday",
      [3] = "Wednesday",
      [4] = "Thursday",
      [5] = "Friday",
      [6] = "Saturday",
      [7] = "Sunday",
    }
    mt.__index.is_fixed_length = true
    mt.__index.is_discrete = false
    mt.__index.serialize = function(self)
      return self.year:serialize() .. self.month:serialize() .. self.day_of_month:serialize() .. self.day_of_week:serialize()
    end
    mt.__index.get_length = function(self)
      return self.year:get_length() + self.month:get_length() + self.day_of_month:get_length() + self.day_of_week:get_length()
    end
    mt.__index.deserialize = function(buf, field_name)
      local o = {}
      o.field_name = field_name
      setmetatable(o, mt)
      o.year = Uint8.deserialize(buf, "year")
      o.month = Uint8.deserialize(buf, "month")
      o.day_of_month = Uint8.deserialize(buf, "day_of_month")
      o.day_of_week = Uint8.deserialize(buf, "day_of_week")
      return o
    end
    mt.__index.pretty_print = function(self)
      return string.format("<%s: %s%s%d %d>",
          self.field_name or self.NAME,
          self.day_of_week.value ~= 0xFF and self.day_of_week_lookup[self.day_of_week.value] .. " " or "",
          self.month.value ~= 0xFF and self.month_lookup[self.month.value] .. " " or "",
          self.day_of_month.value,
          1900 + self.year.value)
    end
    mt.__call = function(orig, year, month, day_of_month, day_of_week)
      local o = {}
      setmetatable(o, mt)
      o.year = Uint8(year - 1900)
      o.month = Uint8(month)
      o.day_of_month = Uint8(day_of_month)
      o.day_of_week = Uint8(day_of_week)
      return o
    end
  mt.__tostring = function(self)
    return self:pretty_print()
  end
    return mt
  end

return DateABC
