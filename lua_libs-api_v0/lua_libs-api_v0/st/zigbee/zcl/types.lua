local types = {
}

local types_mt = {}
types_mt.__type_cache = {}
types_mt.__index = function(self, key)
  if types_mt.__type_cache[key] == nil then
    local require_path = string.format("st.zigbee.generated.types.%s", key)
    types_mt.__type_cache[key] = require(require_path)
  end
  return types_mt.__type_cache[key]
end

setmetatable(types, types_mt)
return types