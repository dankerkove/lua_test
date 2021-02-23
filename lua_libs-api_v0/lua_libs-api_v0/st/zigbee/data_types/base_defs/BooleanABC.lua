local st_utils = require "st.utils"

--- @class BooleanABC: DataType
---
--- Classes being created using the BooleanABC class represent Zigbee data types whose lua "value" is stored
--- as a boolean.
local BooleanABC = {}

--- This function will create a new metatable with the appropriate functionality for a Zigbee Boolean
--- @param base table the base meta table, this will include the ID and NAME of the type being represented
--- @return table The meta table containing the functionality for this type class
function BooleanABC.new_mt(base)
  local mt = {}
  mt.__index = base or {}
  mt.__index.is_fixed_length = true
  mt.__index.is_discrete = true
  mt.__index.serialize = function(s)
    return st_utils.serialize_int(s.value and 1 or 0, 1, false, true)
  end
  mt.__index.get_length = function(self)
    return 1
  end
  mt.__index.deserialize = function(buf, field_name)
    local o = {}
    setmetatable(o, mt)
    o.value = (buf:read_u8() == 1)
    o.field_name = field_name
    return o
  end
  mt.__index.pretty_print = function(self)
    return string.format("%s: %s", self.field_name or self.NAME, self.value and "true" or "false")
  end
  mt.__call = function(orig, val)
    if type(val) ~= "boolean" then
      error({ code = 1, msg = orig.NAME .. " value must be type boolean" })
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

return BooleanABC
