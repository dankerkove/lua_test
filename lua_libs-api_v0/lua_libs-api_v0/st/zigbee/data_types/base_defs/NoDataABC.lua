--- @class NoDataABC: DataType
---
--- Classes being created using the NoDataABC class represent Zigbee data types that have no body
local NoDataABC = {}

--- This function will create a new metatable with the appropriate functionality for a Zigbee NoData
--- @param base table the base meta table, this will include the ID and NAME of the type being represented
--- @return table The meta table containing the functionality for this type class
function NoDataABC.new_mt(base)
  local mt = {}
  mt.__index = base or {}
  mt.__index.is_discrete = true
  mt.__index.is_fixed_length = true
  mt.__index.deserialize = function(buf, field_name)
    local o = {}
    o.field_name = field_name
    setmetatable(o, mt)
    return o
  end
  mt.__index.serialize = function(self)
    return ""
  end
  mt.__index.get_length = function(self)
    return 0
  end
  mt.__index.pretty_print = function(self)
    return "<" .. (self.field_name or self.NAME) .. ">"
  end
  mt.__call = function(orig)
    local o = {}
    setmetatable(o, mt)
    return o
  end
  mt.__tostring = function(self)
    return self:pretty_print()
  end
  return mt
end

return NoDataABC
