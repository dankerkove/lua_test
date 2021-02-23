local zb_utils = require "st.zigbee.utils"
local st_utils = require "st.utils"

--- @class EnumABC: DataType
---
--- Classes being created using the EnumABC class represent Zigbee data types whose lua value is stored
--- as an unsigned number.  In general these are the Zigbee data types Enum8 and Enum16 represented by IDs 0x30 and 0x31.
local EnumABC = {}

function EnumABC.new_mt(base, byte_length)
  local mt = {}
  mt.__index = base or {}
  mt.__index.byte_length = byte_length
  mt.__index.is_fixed_length = true
  mt.__index.is_discrete = true
  mt.__index.serialize = function(s)
    s:check_if_valid(s.value)
    return st_utils.serialize_int(s.value, s.byte_length, false, true)
  end
  mt.__index.get_length = function(self)
    return self.byte_length
  end
  mt.__index.deserialize = function(buf, field_name)
    local o = {}
    setmetatable(o, mt)
    o.byte_length = byte_length
    o.value = buf:read_int(byte_length, false, true)
    o.field_name = field_name
    return o
  end
  mt.__index.pretty_print = function(self)
    local pattern = ">I" .. self.byte_length
    return string.format("%s: 0x%s", self.field_name or self.NAME, zb_utils.pretty_print_hex_str(string.pack(pattern, self.value)))
  end
  mt.__index.check_if_valid = function(self, val)
    if type(val) ~= "number" or val ~= math.floor(val) then
      error({ code = 1, msg = self.NAME .. " value must be an integer" })
    elseif val >= (1 << (byte_length * 8)) then
      error({ code = 1, msg = self.NAME .. " too large for type" })
    elseif val < 0 then
      error({ code = 1, msg = self.NAME .. " value must be positive" })
    end
  end
  mt.__newindex = function(self, k, v)
    if k == "value" then
      self:check_if_valid(v)
      rawset(self, k, v)
    else
      rawset(self, k, v)
    end
  end
  mt.__call = function(orig, val)
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

return EnumABC
