--- @module st.zwave.CommandClass.configuration
--- @alias Configuration
local Configuration = require "st.zwave.generated.Configuration"
local buf = require "st.zwave.utils.buf"

--- Based upon Lua type and value, infer a corresponding Z-Wave
--- COMMAND_CLASS_CONFIGURATION type.
---
--- @param vtype string Lua type string
--- @param value string|number value for which to infer format
--- @return number Configuration.format enum value
local function _format(vtype, value)
  if vtype == "string" then
    return Configuration.format.BIT_FIELD
  elseif vtype == "number" then
    if value >= -0x80000000 and value <= 0x7FFFFFFF then
      -- SIGNED_INTEGER is default, so we infer this for most cases.
      return Configuration.format.SIGNED_INTEGER
    elseif value > 0x7FFFFFFF and value <= 0xFFFFFFFF then
      -- Only report UNSIGNED_INTEGER for (INT32_MAX,UINT32_MAX) corner case.
      -- Note that we are unable to directly infer type enum.  However, the
      -- library has provision for code to specify this explicitly.
      return Configuration.format.UNSIGNED_INTEGER
    else
      error("Z-Wave integer overflow: " .. value)
    end
  else
    error("unsupported Z-Wave type " .. vtype)
  end
end

do
--- Infer a Z-Wave COMMAND_CLASS_CONFIGURATION type for the passed numerical
--- or string-represented bitmask argument.
---
--- @param value string|number value for which to infer format
--- @return number Configuration.format enum value
local function format(value)
  return _format(type(value), value)
end
buf.Writer.format = format
end

do
--- Return the consensus COMMMAND_CLASS_CONFIGURATION format type of all passed
--- string-represented bitmasks or integers.
---
--- Each argument is encoded as an array of table references which must be built
--- up into table-dereference operations for recursion and interrogation.  For
--- instance, an argument may be of form: { args, "vg1", "vg2", "param1" }.
--- Presuming vg1 is a variant-group array and vg2 is a variant-group array
--- within vg2, and param1 is a parameter literal, consensus interrogation of
--- this would compose into this nested loop:
---
---   for i=1,#vg1 do
---     for j=1,#vg2 do
---       -- evaluate concencus against args["vg1"][i]["vg2"][j]["param1"]
---     end
---   end
---
--- Illegal conditions for which an error is raised:
---   - no arguments passed
---   - any arguments of unsupported types
---   - any arguments of mismatched type
---   - string arguments of differing lengths
---
--- @param ... table 1 or more table-traversal paths to string or number arguments
--- @return number consensus Configuration.format enum value
local function consensus_format(...)
  local _,vtype,_,_,vmax = buf.Writer.consensus_size(...)
  return _format(vtype, vmax)
end
buf.Writer.consensus_format = consensus_format
end

do
--- Read a dynamically-typed COMMAND_CLASS_CONFIGURATION value from the buffer.
---
--- @param format number Configuration.format enum value
--- @param size number buffer read length in bytes
--- @return any value read from the buffer
local function read_typed(self, format, size, ...)
  if format == Configuration.format.SIGNED_INTEGER then
    if size == 1 then
      return self:read_i8(...)
    elseif size == 2 then
      return self:read_be_i16(...)
    elseif size == 4 then
      return self:read_be_i32(...)
    else
      error("illegal Z-Wave integer size " .. size)
    end
  elseif format == Configuration.format.UNSIGNED_INTEGER or format == Configuration.format.ENUMERATED then
    if size == 1 then
      return self:read_u8(...)
    elseif size == 2 then
      return self:read_be_u16(...)
    elseif size == 4 then
      return self:read_be_u32(...)
    else
      error("illegal Z-Wave integer size " .. size)
    end
  elseif format == Configuration.format.BIT_FIELD then
    return self:read_bytes(size, ...)
  else
    error("illegal Z-Wave format " .. format)
  end
end
buf.Reader.read_typed = read_typed
end

do
--- Write a dynamically-typed COMMAND_CLASS_CONFIGURATION value to the buffer.
---
--- @param format number Configuration.format enum value
--- @param size number buffer write length in bytes
--- @param val any value to write
local function write_typed(self, format, size, value, ...)
  value = value or not self.strict and 0 or nil
  format = format or self.format(value)
  size = size or self.size(value)
  if format == Configuration.format.SIGNED_INTEGER then
    if size == 1 then
      self:write_i8(value, ...)
    elseif size == 2 then
      self:write_be_i16(value, ...)
    elseif size == 4 then
      self:write_be_i32(value, ...)
    else
      error("illegal Z-Wave integer size " .. size)
    end
  elseif format == Configuration.format.UNSIGNED_INTEGER or format == Configuration.format.ENUMERATED then
    if size == 1 then
      self:write_u8(value, ...)
    elseif size == 2 then
      self:write_be_u16(value, ...)
    elseif size == 4 then
      self:write_be_u32(value, ...)
    else
      error("illegal Z-Wave integer size " .. size)
    end
  elseif format == Configuration.format.BIT_FIELD then
    self:write_bytes(value, ...)
  else
    error("illegal Z-Wave format " .. format)
  end
end
buf.Writer.write_typed = write_typed
end

return Configuration
