local generic_body = {}

--- This represents an unknown body of a Zigbee message and is essentially just a bytes container
--- @class GenericBody
---
local GenericBody = {
  NAME = "GenericBody",
}
GenericBody.__index = GenericBody

generic_body.GenericBody = GenericBody

--- Get the length of this body in bytes
---
--- @return number the length of the body in bytes
function GenericBody:get_length()
  return #self.body_bytes
end

--- Get the serialized version of this body
---
--- @return string the byte string of this body
function GenericBody:serialize()
  return self.body_bytes
end

--- Get a human readable representation of this body
---
--- @return string a human readable representation of this body
function GenericBody:pretty_print()
  local out_str = self.NAME .. ": "
  for i = 1, #self.body_bytes do
    out_str = out_str .. string.format(" %02X", string.byte(self.body_bytes:sub(i,i)))
  end
  return out_str
end
GenericBody.__tostring = GenericBody.pretty_print

function GenericBody.deserialize(buf)
  self = {}
  setmetatable(self, GenericBody)
  self.body_bytes = buf:read_bytes(buf:remain())
  return self
end


return generic_body
