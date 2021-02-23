local Uint16 = require "st.zigbee.data_types.Uint16"
local ZigbeeDataType = require "st.zigbee.data_types.ZigbeeDataType"
--  TODO: figure out my circular dependencies
local data_types = require "st.zigbee.data_types"

--- @class ArrayABC: DataType
---
--- Classes being created using the ArrayABC class represent Zigbee data types whose lua "value" is stored
--- as an array of Zigbee data types all of the same type.
local ArrayABC = {}

--- This function will create a new metatable with the appropriate functionality for a Zigbee Array
--- @param base table the base meta table, this will include the ID and NAME of the type being represented
--- @return table The meta table containing the functionality for this type class
function ArrayABC.new_mt(base)
  local mt = {}
  mt.__index = base or {}
  mt.__index.is_fixed_length = false
  mt.__index.is_discrete = true
  mt.__index.serialize = function(self)
    local out_string = self.num_elements:serialize()
    for i = 1, self.num_elements.value, 1 do
      out_string = out_string .. self.array_data_type:serialize() .. self.elements[i]:serialize()
    end
    return out_string
  end
  mt.__index.get_length = function(self)
    local total_length = self.num_elements:get_length()
    for i = 1, self.num_elements.value, 1 do
      total_length = total_length + 1 + self.elements[i]:get_length() -- include dataType byte for each element
    end
    return total_length
  end
  mt.__index.deserialize = function(buf, field_name)
    local o = {}
    setmetatable(o, mt)
    o.field_name = field_name
    o.num_elements = Uint16.deserialize(buf)
    o.elements = {}
    for i = 1, o.num_elements.value, 1 do
      local data_type = ZigbeeDataType.deserialize(buf)
      o.elements[i] = data_types.parse_data_type(data_type.value, buf)
      if o.array_data_type == nil then
        o.array_data_type = data_type
      end
      if data_type.value ~= o.array_data_type.value then
        error({ code = 2, msg = "Unexpected bytes for zigbee Array type" })
      end
    end
    return o
  end
  mt.__index.pretty_print = function(self)
    local out_str = (self.field_name or self.NAME) .. ": ["
    for _, v in ipairs(self.elements) do
      out_str = out_str .. v:pretty_print() .. ", "
    end
    if #self.elements > 0 then
      out_str = out_str:sub(1, -3) -- remove trailing comma
    end
    out_str = out_str .. "]"
    return out_str
  end
  mt.__call = function(orig, data_vals)
    local o = {}
    setmetatable(o, mt)
    if #data_vals > 0 then
      local value_ids = data_vals[1].ID
      for _, v in ipairs(data_vals) do
        if v.ID ~= value_ids then
          error(self.NAME .. " entries must be of the same data type")
        end
      end
      o.elements = data_vals
      o.num_elements = Uint16(#data_vals)
      o.array_data_type = ZigbeeDataType(o.elements[1].ID)
    else
      o.num_elements = Uint16(0)
    end
    return o
  end
  mt.__tostring = function(self)
    return self:pretty_print()
  end
  return mt
end

return ArrayABC
