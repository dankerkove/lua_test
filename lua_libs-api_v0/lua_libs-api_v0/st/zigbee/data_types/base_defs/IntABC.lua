local st_utils = require "st.utils"

--- @class IntABC: DataType
---
--- Classes being created using the IntABC class represent Zigbee data types whose lua "value" is stored
----- as a signed number.  In general these are the Zigbee data types Int8-Int56 represented by IDs 0x28-0x2E.
----- Int64 has to be treated differently due to lua limitations.
local IntABC = {}

--- This function will create a new metatable with the appropriate functionality for a Zigbee Int
--- @param base table the base meta table, this will include the ID and NAME of the type being represented
--- @param byte_length number the length in bytes of this Int
function IntABC.new_mt(base, byte_length)
  local mt = {}
  mt.__index = base or {}
  mt.__index.byte_length = byte_length
  mt.__index.is_fixed_length = true
  mt.__index.is_discrete = false
  mt.__index.serialize = function(s)
    return st_utils.serialize_int(s.value, s.byte_length, true, true)
  end
  mt.__index.get_length = function(self)
    return self.byte_length
  end
  mt.__index.deserialize = function(buf, field_name)
    local o = {}
    setmetatable(o, mt)
    o.byte_length = byte_length
    o.value = buf:read_int(byte_length, true, true)
    o.field_name = field_name
    return o
  end
  mt.__index.pretty_print = function(self)
    return string.format("%s: %d", self.field_name or self.NAME, self.value)
  end
  mt.__call = function(orig, val)
    if type(val) ~= "number" or val ~= math.floor(val) then
      error({ code = 1, msg = orig.NAME .. " value must be an integer" })
    elseif val >= (1 << ((byte_length * 8) - 1)) then
      error({ code = 1, msg = orig.NAME .. " too large for type" })
    elseif val < -1 * (1 << ((byte_length * 8) - 1)) then
      error({ code = 1, msg = orig.NAME .. "value too negative for type" })
    end
    local o = {}
    setmetatable(o, mt)
    o.value = val
    return o
  end
  mt.__tostring = function(self)
    return self:pretty_print()
  end
  return mt
end

return IntABC
