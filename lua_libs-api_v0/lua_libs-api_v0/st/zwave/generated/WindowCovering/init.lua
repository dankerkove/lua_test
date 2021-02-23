-- THIS CODE IS AUTOMATICALLY GENERATED BY zwave_lib_generator/gen.py.  DO NOT HAND EDIT.
--
-- Generator script revision: b'aa2e97900114164f8c529a796bf831ed52b6bc41'
-- Protocol definition XML version: 2.3.2

local zw = require "st.zwave"
local buf = require "st.zwave.utils.buf"
local utils = require "st.utils"

--- @class st.zwave.CommandClass.WindowCovering
--- @alias WindowCovering
---
--- Supported versions: 1
---
--- @field public SUPPORTED_GET number 0x01 - WINDOW_COVERING_SUPPORTED_GET command id
--- @field public SUPPORTED_REPORT number 0x02 - WINDOW_COVERING_SUPPORTED_REPORT command id
--- @field public GET number 0x03 - WINDOW_COVERING_GET command id
--- @field public REPORT number 0x04 - WINDOW_COVERING_REPORT command id
--- @field public SET number 0x05 - WINDOW_COVERING_SET command id
--- @field public START_LEVEL_CHANGE number 0x06 - WINDOW_COVERING_START_LEVEL_CHANGE command id
--- @field public STOP_LEVEL_CHANGE number 0x07 - WINDOW_COVERING_STOP_LEVEL_CHANGE command id
local WindowCovering = {}
WindowCovering.SUPPORTED_GET = 0x01
WindowCovering.SUPPORTED_REPORT = 0x02
WindowCovering.GET = 0x03
WindowCovering.REPORT = 0x04
WindowCovering.SET = 0x05
WindowCovering.START_LEVEL_CHANGE = 0x06
WindowCovering.STOP_LEVEL_CHANGE = 0x07

WindowCovering._commands = {
  [WindowCovering.SUPPORTED_GET] = "SUPPORTED_GET",
  [WindowCovering.SUPPORTED_REPORT] = "SUPPORTED_REPORT",
  [WindowCovering.GET] = "GET",
  [WindowCovering.REPORT] = "REPORT",
  [WindowCovering.SET] = "SET",
  [WindowCovering.START_LEVEL_CHANGE] = "START_LEVEL_CHANGE",
  [WindowCovering.STOP_LEVEL_CHANGE] = "STOP_LEVEL_CHANGE"
}

--- Instantiate a versioned instance of the WindowCovering Command Class module, optionally setting strict to require explicit passing of all parameters to constructors.
---
--- @param params st.zwave.CommandClass.Params command class instance parameters
--- @return st.zwave.CommandClass.WindowCovering versioned command class instance
function WindowCovering:init(params)
  local version = params and params.version or nil
  if (params or {}).strict ~= nil then
  local strict = params.strict
  else
  local strict = true -- default
  end
  local strict = params and params.strict or nil
  assert(version == nil or zw._versions[zw.WINDOW_COVERING][version] ~= nil, "unsupported version")
  assert(strict == nil or type(strict) == "boolean", "strict must be a boolean")
  local mt = {
    __index = self
  }
  local instance = setmetatable({}, mt)
  instance._serialization_version = version
  instance._strict = strict
  return instance
end

setmetatable(WindowCovering, {
  __call = WindowCovering.init
})

WindowCovering._serialization_version = nil
WindowCovering._strict = false
zw._deserialization_versions = zw.deserialization_versions or {}
zw._versions = zw._versions or {}
setmetatable(zw._deserialization_versions, { __index = zw._versions })
zw._versions[zw.WINDOW_COVERING] = {
  [1] = true
}

--- @class st.zwave.CommandClass.WindowCovering.SupportedGetV1Args
--- @alias SupportedGetV1Args
local SupportedGetV1Args = {}

--- @class st.zwave.CommandClass.WindowCovering.SupportedGetV1:st.zwave.Command
--- @alias SupportedGetV1
---
--- v1 WINDOW_COVERING_SUPPORTED_GET
---
--- @field public cmd_class number 0x6A
--- @field public cmd_id number 0x01
--- @field public version number 1
--- @field public args st.zwave.CommandClass.WindowCovering.SupportedGetV1Args command-specific arguments
local SupportedGetV1 = {}
setmetatable(SupportedGetV1, {
  __index = zw.Command,
  __call = function(cls, self, ...)
    local mt = {
      __index = function(tbl, key)
        if key == "payload" then
          return tbl:serialize()
        else
          return cls[key]
        end
      end,
      __tostring = zw.Command.pretty_print,
      __eq = zw.Command.equals
    }
    local instance = setmetatable({}, mt)
    instance:init(self, ...)
    return instance
  end,
})

--- Initialize a v1 WINDOW_COVERING_SUPPORTED_GET object.
---
--- @param module st.zwave.CommandClass.WindowCovering command class module instance
--- @param args st.zwave.CommandClass.WindowCovering.SupportedGetV1Args command-specific arguments
function SupportedGetV1:init(module, args, ...)
  zw.Command._parse(self, module, zw.WINDOW_COVERING, WindowCovering.SUPPORTED_GET, 1, args, ...)
end

--- Serialize v1 WINDOW_COVERING_SUPPORTED_GET arguments.
---
--- @return string serialized payload
function SupportedGetV1:serialize()
  local writer = buf.Writer()
  return writer.buf
end

--- Deserialize a v1 WINDOW_COVERING_SUPPORTED_GET payload.
---
--- @return st.zwave.CommandClass.WindowCovering.SupportedGetV1Args deserialized arguments
function SupportedGetV1:deserialize()
  local reader = buf.Reader(self.payload)
  return reader.parsed
end

--- Return a deep copy of self.args, merging defaults for unset, but required parameters.
---
--- @param self st.zwave.CommandClass.WindowCovering.SupportedGetV1
--- @return st.zwave.CommandClass.WindowCovering.SupportedGetV1Args
function SupportedGetV1._defaults(self)
  return {}
end

--- Return a deep copy of self.args, merging defaults for all unset parameters.
---
--- @param self st.zwave.CommandClass.WindowCovering.SupportedGetV1
--- @return st.zwave.CommandClass.WindowCovering.SupportedGetV1Args
function SupportedGetV1._template(self)
  return {}
end

--- Set defaults for any required, but unset arguments.
---
--- @param self st.zwave.CommandClass.WindowCovering.SupportedGetV1
function SupportedGetV1._set_defaults(self)
  local defaults = self:_defaults()
  utils.merge(self.args, defaults)
end

--- Set const reflectors to allow enum stringification.
---
--- @param self st.zwave.CommandClass.WindowCovering.SupportedGetV1
function SupportedGetV1._set_reflectors(self)
end

--- @class st.zwave.CommandClass.WindowCovering.SupportedReportV1Args
--- @alias SupportedReportV1Args
--- @field public parameter_mask string
local SupportedReportV1Args = {}

--- @class st.zwave.CommandClass.WindowCovering.SupportedReportV1:st.zwave.Command
--- @alias SupportedReportV1
---
--- v1 WINDOW_COVERING_SUPPORTED_REPORT
---
--- @field public cmd_class number 0x6A
--- @field public cmd_id number 0x02
--- @field public version number 1
--- @field public args st.zwave.CommandClass.WindowCovering.SupportedReportV1Args command-specific arguments
local SupportedReportV1 = {}
setmetatable(SupportedReportV1, {
  __index = zw.Command,
  __call = function(cls, self, ...)
    local mt = {
      __index = function(tbl, key)
        if key == "payload" then
          return tbl:serialize()
        else
          return cls[key]
        end
      end,
      __tostring = zw.Command.pretty_print,
      __eq = zw.Command.equals
    }
    local instance = setmetatable({}, mt)
    instance:init(self, ...)
    return instance
  end,
})

--- Initialize a v1 WINDOW_COVERING_SUPPORTED_REPORT object.
---
--- @param module st.zwave.CommandClass.WindowCovering command class module instance
--- @param args st.zwave.CommandClass.WindowCovering.SupportedReportV1Args command-specific arguments
function SupportedReportV1:init(module, args, ...)
  zw.Command._parse(self, module, zw.WINDOW_COVERING, WindowCovering.SUPPORTED_REPORT, 1, args, ...)
end

--- Serialize v1 WINDOW_COVERING_SUPPORTED_REPORT arguments.
---
--- @return string serialized payload
function SupportedReportV1:serialize()
  local writer = buf.Writer()
  local args = self.args
  writer:write_bits(4, writer.length(args.parameter_mask))
  writer:write_bits(4, 0) -- reserved
  writer:write_bytes(args.parameter_mask)
  return writer.buf
end

--- Deserialize a v1 WINDOW_COVERING_SUPPORTED_REPORT payload.
---
--- @return st.zwave.CommandClass.WindowCovering.SupportedReportV1Args deserialized arguments
function SupportedReportV1:deserialize()
  local reader = buf.Reader(self.payload)
  reader:read_bits(4, "number_of_parameter_mask_bytes")
  reader:read_bits(4) -- reserved
  reader:read_bytes(reader.parsed.number_of_parameter_mask_bytes, "parameter_mask")
  return reader.parsed
end

--- Return a deep copy of self.args, merging defaults for unset, but required parameters.
---
--- @param self st.zwave.CommandClass.WindowCovering.SupportedReportV1
--- @return st.zwave.CommandClass.WindowCovering.SupportedReportV1Args
function SupportedReportV1._defaults(self)
  local args = {}
  args.parameter_mask = self.args.parameter_mask or ""
  return args
end

--- Return a deep copy of self.args, merging defaults for all unset parameters.
---
--- @param self st.zwave.CommandClass.WindowCovering.SupportedReportV1
--- @return st.zwave.CommandClass.WindowCovering.SupportedReportV1Args
function SupportedReportV1._template(self)
  local args = self:_defaults()
  return args
end

--- Set defaults for any required, but unset arguments.
---
--- @param self st.zwave.CommandClass.WindowCovering.SupportedReportV1
function SupportedReportV1._set_defaults(self)
  local defaults = self:_defaults()
  utils.merge(self.args, defaults)
end

--- Set const reflectors to allow enum stringification.
---
--- @param self st.zwave.CommandClass.WindowCovering.SupportedReportV1
function SupportedReportV1._set_reflectors(self)
end

--- @class st.zwave.CommandClass.WindowCovering.GetV1Args
--- @alias GetV1Args
--- @field public parameter_id integer see :lua:class:`WindowCovering.parameter_id <st.zwave.CommandClass.WindowCovering.parameter_id>`
local GetV1Args = {}

--- @class st.zwave.CommandClass.WindowCovering.GetV1:st.zwave.Command
--- @alias GetV1
---
--- v1 WINDOW_COVERING_GET
---
--- @field public cmd_class number 0x6A
--- @field public cmd_id number 0x03
--- @field public version number 1
--- @field public args st.zwave.CommandClass.WindowCovering.GetV1Args command-specific arguments
local GetV1 = {}
setmetatable(GetV1, {
  __index = zw.Command,
  __call = function(cls, self, ...)
    local mt = {
      __index = function(tbl, key)
        if key == "payload" then
          return tbl:serialize()
        else
          return cls[key]
        end
      end,
      __tostring = zw.Command.pretty_print,
      __eq = zw.Command.equals
    }
    local instance = setmetatable({}, mt)
    instance:init(self, ...)
    return instance
  end,
})

--- Initialize a v1 WINDOW_COVERING_GET object.
---
--- @param module st.zwave.CommandClass.WindowCovering command class module instance
--- @param args st.zwave.CommandClass.WindowCovering.GetV1Args command-specific arguments
function GetV1:init(module, args, ...)
  zw.Command._parse(self, module, zw.WINDOW_COVERING, WindowCovering.GET, 1, args, ...)
end

--- Serialize v1 WINDOW_COVERING_GET arguments.
---
--- @return string serialized payload
function GetV1:serialize()
  local writer = buf.Writer()
  local args = self.args
  writer:write_u8(args.parameter_id)
  return writer.buf
end

--- Deserialize a v1 WINDOW_COVERING_GET payload.
---
--- @return st.zwave.CommandClass.WindowCovering.GetV1Args deserialized arguments
function GetV1:deserialize()
  local reader = buf.Reader(self.payload)
  reader:read_u8("parameter_id")
  return reader.parsed
end

--- Return a deep copy of self.args, merging defaults for unset, but required parameters.
---
--- @param self st.zwave.CommandClass.WindowCovering.GetV1
--- @return st.zwave.CommandClass.WindowCovering.GetV1Args
function GetV1._defaults(self)
  local args = {}
  args.parameter_id = self.args.parameter_id or 0
  return args
end

--- Return a deep copy of self.args, merging defaults for all unset parameters.
---
--- @param self st.zwave.CommandClass.WindowCovering.GetV1
--- @return st.zwave.CommandClass.WindowCovering.GetV1Args
function GetV1._template(self)
  local args = self:_defaults()
  return args
end

--- Set defaults for any required, but unset arguments.
---
--- @param self st.zwave.CommandClass.WindowCovering.GetV1
function GetV1._set_defaults(self)
  local defaults = self:_defaults()
  utils.merge(self.args, defaults)
end

--- Set const reflectors to allow enum stringification.
---
--- @param self st.zwave.CommandClass.WindowCovering.GetV1
function GetV1._set_reflectors(self)
  local args = self.args
  args._reflect = args._reflect or {}
  args._reflect.parameter_id = function()
    return zw._reflect(
      WindowCovering._reflect_parameter_id,
      args.parameter_id
    )
  end
end

--- @class st.zwave.CommandClass.WindowCovering.ReportV1Args
--- @alias ReportV1Args
--- @field public parameter_id integer see :lua:class:`WindowCovering.parameter_id <st.zwave.CommandClass.WindowCovering.parameter_id>`
--- @field public current_value integer [0,255]
--- @field public target_value integer [0,255]
--- @field public duration number|string [0,7560] or "unknown" or "reserved"
local ReportV1Args = {}

--- @class st.zwave.CommandClass.WindowCovering.ReportV1:st.zwave.Command
--- @alias ReportV1
---
--- v1 WINDOW_COVERING_REPORT
---
--- @field public cmd_class number 0x6A
--- @field public cmd_id number 0x04
--- @field public version number 1
--- @field public args st.zwave.CommandClass.WindowCovering.ReportV1Args command-specific arguments
local ReportV1 = {}
setmetatable(ReportV1, {
  __index = zw.Command,
  __call = function(cls, self, ...)
    local mt = {
      __index = function(tbl, key)
        if key == "payload" then
          return tbl:serialize()
        else
          return cls[key]
        end
      end,
      __tostring = zw.Command.pretty_print,
      __eq = zw.Command.equals
    }
    local instance = setmetatable({}, mt)
    instance:init(self, ...)
    return instance
  end,
})

--- Initialize a v1 WINDOW_COVERING_REPORT object.
---
--- @param module st.zwave.CommandClass.WindowCovering command class module instance
--- @param args st.zwave.CommandClass.WindowCovering.ReportV1Args command-specific arguments
function ReportV1:init(module, args, ...)
  zw.Command._parse(self, module, zw.WINDOW_COVERING, WindowCovering.REPORT, 1, args, ...)
end

--- Serialize v1 WINDOW_COVERING_REPORT arguments.
---
--- @return string serialized payload
function ReportV1:serialize()
  local writer = buf.Writer()
  local args = self.args
  writer:write_u8(args.parameter_id)
  writer:write_u8(args.current_value)
  writer:write_u8(args.target_value)
  writer:write_actuator_duration_report(args.duration)
  return writer.buf
end

--- Deserialize a v1 WINDOW_COVERING_REPORT payload.
---
--- @return st.zwave.CommandClass.WindowCovering.ReportV1Args deserialized arguments
function ReportV1:deserialize()
  local reader = buf.Reader(self.payload)
  reader:read_u8("parameter_id")
  reader:read_u8("current_value")
  reader:read_u8("target_value")
  reader:read_actuator_duration_report("duration")
  return reader.parsed
end

--- Return a deep copy of self.args, merging defaults for unset, but required parameters.
---
--- @param self st.zwave.CommandClass.WindowCovering.ReportV1
--- @return st.zwave.CommandClass.WindowCovering.ReportV1Args
function ReportV1._defaults(self)
  local args = {}
  args.parameter_id = self.args.parameter_id or 0
  args.current_value = self.args.current_value or 0
  args.target_value = self.args.target_value or 0
  args.duration = self.args.duration or 0
  return args
end

--- Return a deep copy of self.args, merging defaults for all unset parameters.
---
--- @param self st.zwave.CommandClass.WindowCovering.ReportV1
--- @return st.zwave.CommandClass.WindowCovering.ReportV1Args
function ReportV1._template(self)
  local args = self:_defaults()
  return args
end

--- Set defaults for any required, but unset arguments.
---
--- @param self st.zwave.CommandClass.WindowCovering.ReportV1
function ReportV1._set_defaults(self)
  local defaults = self:_defaults()
  utils.merge(self.args, defaults)
end

--- Set const reflectors to allow enum stringification.
---
--- @param self st.zwave.CommandClass.WindowCovering.ReportV1
function ReportV1._set_reflectors(self)
  local args = self.args
  args._reflect = args._reflect or {}
  args._reflect.parameter_id = function()
    return zw._reflect(
      WindowCovering._reflect_parameter_id,
      args.parameter_id
    )
  end
end

--- @class st.zwave.CommandClass.WindowCovering.SetV1ArgsParameters
--- @alias SetV1ArgsParameters
--- @field public parameter_id integer see :lua:class:`WindowCovering.parameter_id <st.zwave.CommandClass.WindowCovering.parameter_id>`
--- @field public value integer [0,255]
local SetV1ArgsParameters = {}

--- @class st.zwave.CommandClass.WindowCovering.SetV1Args
--- @alias SetV1Args
--- @field public parameters st.zwave.CommandClass.WindowCovering.SetV1ArgsParameters[]
--- @field public duration number|string [0,7620] or "default"
local SetV1Args = {}

--- @class st.zwave.CommandClass.WindowCovering.SetV1:st.zwave.Command
--- @alias SetV1
---
--- v1 WINDOW_COVERING_SET
---
--- @field public cmd_class number 0x6A
--- @field public cmd_id number 0x05
--- @field public version number 1
--- @field public args st.zwave.CommandClass.WindowCovering.SetV1Args command-specific arguments
local SetV1 = {}
setmetatable(SetV1, {
  __index = zw.Command,
  __call = function(cls, self, ...)
    local mt = {
      __index = function(tbl, key)
        if key == "payload" then
          return tbl:serialize()
        else
          return cls[key]
        end
      end,
      __tostring = zw.Command.pretty_print,
      __eq = zw.Command.equals
    }
    local instance = setmetatable({}, mt)
    instance:init(self, ...)
    return instance
  end,
})

--- Initialize a v1 WINDOW_COVERING_SET object.
---
--- @param module st.zwave.CommandClass.WindowCovering command class module instance
--- @param args st.zwave.CommandClass.WindowCovering.SetV1Args command-specific arguments
function SetV1:init(module, args, ...)
  zw.Command._parse(self, module, zw.WINDOW_COVERING, WindowCovering.SET, 1, args, ...)
end

--- Serialize v1 WINDOW_COVERING_SET arguments.
---
--- @return string serialized payload
function SetV1:serialize()
  local writer = buf.Writer()
  local args = self.args
  writer:write_bits(5, writer.length(args.parameters))
  writer:write_bits(3, 0) -- reserved
  for i=1,writer.length(args.parameters) do
    writer:write_u8(args.parameters[i].parameter_id)
    writer:write_u8(args.parameters[i].value)
  end
  writer:write_actuator_duration_set(args.duration)
  return writer.buf
end

--- Deserialize a v1 WINDOW_COVERING_SET payload.
---
--- @return st.zwave.CommandClass.WindowCovering.SetV1Args deserialized arguments
function SetV1:deserialize()
  local reader = buf.Reader(self.payload)
  reader:read_bits(5, "parameter_count")
  reader:read_bits(3) -- reserved
  reader.parsed.parameters = {}
  for i=1,reader.parsed.parameter_count do
    reader.parsed.parameters[i] = {}
    reader:read_u8("parameter_id", reader.parsed.parameters[i])
    reader:read_u8("value", reader.parsed.parameters[i])
  end
  reader:read_actuator_duration_set("duration")
  return reader.parsed
end

--- Return a deep copy of self.args, merging defaults for unset, but required parameters.
---
--- @param self st.zwave.CommandClass.WindowCovering.SetV1
--- @return st.zwave.CommandClass.WindowCovering.SetV1Args
function SetV1._defaults(self)
  local args = {}
  args.parameters = self.args.parameters or {}
  for i=1,buf.Writer.length(args.parameters) do
    args.parameters[i] = args.parameters[i] or {}
    args.parameters[i].parameter_id = self.args.parameters[i].parameter_id or 0
    args.parameters[i].value = self.args.parameters[i].value or 0
  end
  args.duration = self.args.duration or 0
  return args
end

--- Return a deep copy of self.args, merging defaults for all unset parameters.
---
--- @param self st.zwave.CommandClass.WindowCovering.SetV1
--- @return st.zwave.CommandClass.WindowCovering.SetV1Args
function SetV1._template(self)
  local args = self:_defaults()
  local writer = buf.Writer()
  for i=1,buf.Writer.length(args.parameters) do
    args.parameters[i] = args.parameters[i] or {}
  end
  return args
end

--- Set defaults for any required, but unset arguments.
---
--- @param self st.zwave.CommandClass.WindowCovering.SetV1
function SetV1._set_defaults(self)
  local defaults = self:_defaults()
  utils.merge(self.args, defaults)
end

--- Set const reflectors to allow enum stringification.
---
--- @param self st.zwave.CommandClass.WindowCovering.SetV1
function SetV1._set_reflectors(self)
  local args = self.args
  for i=1,buf.Writer.length(args.parameters) do
    args.parameters[i]._reflect = args.parameters[i]._reflect or {}
    args.parameters[i]._reflect.parameter_id = function()
      return zw._reflect(
        WindowCovering._reflect_parameter_id,
        args.parameters[i].parameter_id
      )
    end
  end
end

--- @class st.zwave.CommandClass.WindowCovering.StartLevelChangeV1Args
--- @alias StartLevelChangeV1Args
--- @field public up_down boolean
--- @field public parameter_id integer see :lua:class:`WindowCovering.parameter_id <st.zwave.CommandClass.WindowCovering.parameter_id>`
--- @field public duration number|string [0,7620] or "default"
local StartLevelChangeV1Args = {}

--- @class st.zwave.CommandClass.WindowCovering.StartLevelChangeV1:st.zwave.Command
--- @alias StartLevelChangeV1
---
--- v1 WINDOW_COVERING_START_LEVEL_CHANGE
---
--- @field public cmd_class number 0x6A
--- @field public cmd_id number 0x06
--- @field public version number 1
--- @field public args st.zwave.CommandClass.WindowCovering.StartLevelChangeV1Args command-specific arguments
local StartLevelChangeV1 = {}
setmetatable(StartLevelChangeV1, {
  __index = zw.Command,
  __call = function(cls, self, ...)
    local mt = {
      __index = function(tbl, key)
        if key == "payload" then
          return tbl:serialize()
        else
          return cls[key]
        end
      end,
      __tostring = zw.Command.pretty_print,
      __eq = zw.Command.equals
    }
    local instance = setmetatable({}, mt)
    instance:init(self, ...)
    return instance
  end,
})

--- Initialize a v1 WINDOW_COVERING_START_LEVEL_CHANGE object.
---
--- @param module st.zwave.CommandClass.WindowCovering command class module instance
--- @param args st.zwave.CommandClass.WindowCovering.StartLevelChangeV1Args command-specific arguments
function StartLevelChangeV1:init(module, args, ...)
  zw.Command._parse(self, module, zw.WINDOW_COVERING, WindowCovering.START_LEVEL_CHANGE, 1, args, ...)
end

--- Serialize v1 WINDOW_COVERING_START_LEVEL_CHANGE arguments.
---
--- @return string serialized payload
function StartLevelChangeV1:serialize()
  local writer = buf.Writer()
  local args = self.args
  writer:write_bits(6, 0) -- res1
  writer:write_bool(args.up_down)
  writer:write_bool(false) -- res2
  writer:write_u8(args.parameter_id)
  writer:write_actuator_duration_set(args.duration)
  return writer.buf
end

--- Deserialize a v1 WINDOW_COVERING_START_LEVEL_CHANGE payload.
---
--- @return st.zwave.CommandClass.WindowCovering.StartLevelChangeV1Args deserialized arguments
function StartLevelChangeV1:deserialize()
  local reader = buf.Reader(self.payload)
  reader:read_bits(6) -- res1
  reader:read_bool("up_down")
  reader:read_bool() -- res2
  reader:read_u8("parameter_id")
  reader:read_actuator_duration_set("duration")
  return reader.parsed
end

--- Return a deep copy of self.args, merging defaults for unset, but required parameters.
---
--- @param self st.zwave.CommandClass.WindowCovering.StartLevelChangeV1
--- @return st.zwave.CommandClass.WindowCovering.StartLevelChangeV1Args
function StartLevelChangeV1._defaults(self)
  local args = {}
  args.up_down = self.args.up_down or false
  args.parameter_id = self.args.parameter_id or 0
  args.duration = self.args.duration or 0
  return args
end

--- Return a deep copy of self.args, merging defaults for all unset parameters.
---
--- @param self st.zwave.CommandClass.WindowCovering.StartLevelChangeV1
--- @return st.zwave.CommandClass.WindowCovering.StartLevelChangeV1Args
function StartLevelChangeV1._template(self)
  local args = self:_defaults()
  return args
end

--- Set defaults for any required, but unset arguments.
---
--- @param self st.zwave.CommandClass.WindowCovering.StartLevelChangeV1
function StartLevelChangeV1._set_defaults(self)
  local defaults = self:_defaults()
  utils.merge(self.args, defaults)
end

--- Set const reflectors to allow enum stringification.
---
--- @param self st.zwave.CommandClass.WindowCovering.StartLevelChangeV1
function StartLevelChangeV1._set_reflectors(self)
  local args = self.args
  args._reflect = args._reflect or {}
  args._reflect.parameter_id = function()
    return zw._reflect(
      WindowCovering._reflect_parameter_id,
      args.parameter_id
    )
  end
end

--- @class st.zwave.CommandClass.WindowCovering.StopLevelChangeV1Args
--- @alias StopLevelChangeV1Args
--- @field public parameter_id integer see :lua:class:`WindowCovering.parameter_id <st.zwave.CommandClass.WindowCovering.parameter_id>`
local StopLevelChangeV1Args = {}

--- @class st.zwave.CommandClass.WindowCovering.StopLevelChangeV1:st.zwave.Command
--- @alias StopLevelChangeV1
---
--- v1 WINDOW_COVERING_STOP_LEVEL_CHANGE
---
--- @field public cmd_class number 0x6A
--- @field public cmd_id number 0x07
--- @field public version number 1
--- @field public args st.zwave.CommandClass.WindowCovering.StopLevelChangeV1Args command-specific arguments
local StopLevelChangeV1 = {}
setmetatable(StopLevelChangeV1, {
  __index = zw.Command,
  __call = function(cls, self, ...)
    local mt = {
      __index = function(tbl, key)
        if key == "payload" then
          return tbl:serialize()
        else
          return cls[key]
        end
      end,
      __tostring = zw.Command.pretty_print,
      __eq = zw.Command.equals
    }
    local instance = setmetatable({}, mt)
    instance:init(self, ...)
    return instance
  end,
})

--- Initialize a v1 WINDOW_COVERING_STOP_LEVEL_CHANGE object.
---
--- @param module st.zwave.CommandClass.WindowCovering command class module instance
--- @param args st.zwave.CommandClass.WindowCovering.StopLevelChangeV1Args command-specific arguments
function StopLevelChangeV1:init(module, args, ...)
  zw.Command._parse(self, module, zw.WINDOW_COVERING, WindowCovering.STOP_LEVEL_CHANGE, 1, args, ...)
end

--- Serialize v1 WINDOW_COVERING_STOP_LEVEL_CHANGE arguments.
---
--- @return string serialized payload
function StopLevelChangeV1:serialize()
  local writer = buf.Writer()
  local args = self.args
  writer:write_u8(args.parameter_id)
  return writer.buf
end

--- Deserialize a v1 WINDOW_COVERING_STOP_LEVEL_CHANGE payload.
---
--- @return st.zwave.CommandClass.WindowCovering.StopLevelChangeV1Args deserialized arguments
function StopLevelChangeV1:deserialize()
  local reader = buf.Reader(self.payload)
  reader:read_u8("parameter_id")
  return reader.parsed
end

--- Return a deep copy of self.args, merging defaults for unset, but required parameters.
---
--- @param self st.zwave.CommandClass.WindowCovering.StopLevelChangeV1
--- @return st.zwave.CommandClass.WindowCovering.StopLevelChangeV1Args
function StopLevelChangeV1._defaults(self)
  local args = {}
  args.parameter_id = self.args.parameter_id or 0
  return args
end

--- Return a deep copy of self.args, merging defaults for all unset parameters.
---
--- @param self st.zwave.CommandClass.WindowCovering.StopLevelChangeV1
--- @return st.zwave.CommandClass.WindowCovering.StopLevelChangeV1Args
function StopLevelChangeV1._template(self)
  local args = self:_defaults()
  return args
end

--- Set defaults for any required, but unset arguments.
---
--- @param self st.zwave.CommandClass.WindowCovering.StopLevelChangeV1
function StopLevelChangeV1._set_defaults(self)
  local defaults = self:_defaults()
  utils.merge(self.args, defaults)
end

--- Set const reflectors to allow enum stringification.
---
--- @param self st.zwave.CommandClass.WindowCovering.StopLevelChangeV1
function StopLevelChangeV1._set_reflectors(self)
  local args = self.args
  args._reflect = args._reflect or {}
  args._reflect.parameter_id = function()
    return zw._reflect(
      WindowCovering._reflect_parameter_id,
      args.parameter_id
    )
  end
end

--- @class st.zwave.CommandClass.WindowCovering.SupportedGet
--- @alias _SupportedGet
---
--- Dynamically versioned WINDOW_COVERING_SUPPORTED_GET
---
--- Supported versions: 1; unique base versions: 1
---
--- @field public cmd_class number 0x6A
--- @field public cmd_id number 0x01
--- @field public version number 1
--- @field public args st.zwave.CommandClass.WindowCovering.SupportedGetV1Args
local _SupportedGet = {}
setmetatable(_SupportedGet, {
  __call = function(cls, self, ...)
    return cls:construct(self, ...)
  end,
})

--- Construct a WINDOW_COVERING_SUPPORTED_GET object at the module instance serialization version.
---
--- @param module st.zwave.CommandClass.WindowCovering command class module instance
--- @param args st.zwave.CommandClass.WindowCovering.SupportedGetV1Args command-specific arguments
--- @return st.zwave.CommandClass.WindowCovering.SupportedGet
function _SupportedGet:construct(module, args, ...)
  return zw.Command._construct(module, WindowCovering.SUPPORTED_GET, module._serialization_version, args, ...)
end

--- @class st.zwave.CommandClass.WindowCovering.SupportedReport
--- @alias _SupportedReport
---
--- Dynamically versioned WINDOW_COVERING_SUPPORTED_REPORT
---
--- Supported versions: 1; unique base versions: 1
---
--- @field public cmd_class number 0x6A
--- @field public cmd_id number 0x02
--- @field public version number 1
--- @field public args st.zwave.CommandClass.WindowCovering.SupportedReportV1Args
local _SupportedReport = {}
setmetatable(_SupportedReport, {
  __call = function(cls, self, ...)
    return cls:construct(self, ...)
  end,
})

--- Construct a WINDOW_COVERING_SUPPORTED_REPORT object at the module instance serialization version.
---
--- @param module st.zwave.CommandClass.WindowCovering command class module instance
--- @param args st.zwave.CommandClass.WindowCovering.SupportedReportV1Args command-specific arguments
--- @return st.zwave.CommandClass.WindowCovering.SupportedReport
function _SupportedReport:construct(module, args, ...)
  return zw.Command._construct(module, WindowCovering.SUPPORTED_REPORT, module._serialization_version, args, ...)
end

--- @class st.zwave.CommandClass.WindowCovering.Get
--- @alias _Get
---
--- Dynamically versioned WINDOW_COVERING_GET
---
--- Supported versions: 1; unique base versions: 1
---
--- @field public cmd_class number 0x6A
--- @field public cmd_id number 0x03
--- @field public version number 1
--- @field public args st.zwave.CommandClass.WindowCovering.GetV1Args
local _Get = {}
setmetatable(_Get, {
  __call = function(cls, self, ...)
    return cls:construct(self, ...)
  end,
})

--- Construct a WINDOW_COVERING_GET object at the module instance serialization version.
---
--- @param module st.zwave.CommandClass.WindowCovering command class module instance
--- @param args st.zwave.CommandClass.WindowCovering.GetV1Args command-specific arguments
--- @return st.zwave.CommandClass.WindowCovering.Get
function _Get:construct(module, args, ...)
  return zw.Command._construct(module, WindowCovering.GET, module._serialization_version, args, ...)
end

--- @class st.zwave.CommandClass.WindowCovering.Report
--- @alias _Report
---
--- Dynamically versioned WINDOW_COVERING_REPORT
---
--- Supported versions: 1; unique base versions: 1
---
--- @field public cmd_class number 0x6A
--- @field public cmd_id number 0x04
--- @field public version number 1
--- @field public args st.zwave.CommandClass.WindowCovering.ReportV1Args
local _Report = {}
setmetatable(_Report, {
  __call = function(cls, self, ...)
    return cls:construct(self, ...)
  end,
})

--- Construct a WINDOW_COVERING_REPORT object at the module instance serialization version.
---
--- @param module st.zwave.CommandClass.WindowCovering command class module instance
--- @param args st.zwave.CommandClass.WindowCovering.ReportV1Args command-specific arguments
--- @return st.zwave.CommandClass.WindowCovering.Report
function _Report:construct(module, args, ...)
  return zw.Command._construct(module, WindowCovering.REPORT, module._serialization_version, args, ...)
end

--- @class st.zwave.CommandClass.WindowCovering.Set
--- @alias _Set
---
--- Dynamically versioned WINDOW_COVERING_SET
---
--- Supported versions: 1; unique base versions: 1
---
--- @field public cmd_class number 0x6A
--- @field public cmd_id number 0x05
--- @field public version number 1
--- @field public args st.zwave.CommandClass.WindowCovering.SetV1Args
local _Set = {}
setmetatable(_Set, {
  __call = function(cls, self, ...)
    return cls:construct(self, ...)
  end,
})

--- Construct a WINDOW_COVERING_SET object at the module instance serialization version.
---
--- @param module st.zwave.CommandClass.WindowCovering command class module instance
--- @param args st.zwave.CommandClass.WindowCovering.SetV1Args command-specific arguments
--- @return st.zwave.CommandClass.WindowCovering.Set
function _Set:construct(module, args, ...)
  return zw.Command._construct(module, WindowCovering.SET, module._serialization_version, args, ...)
end

--- @class st.zwave.CommandClass.WindowCovering.StartLevelChange
--- @alias _StartLevelChange
---
--- Dynamically versioned WINDOW_COVERING_START_LEVEL_CHANGE
---
--- Supported versions: 1; unique base versions: 1
---
--- @field public cmd_class number 0x6A
--- @field public cmd_id number 0x06
--- @field public version number 1
--- @field public args st.zwave.CommandClass.WindowCovering.StartLevelChangeV1Args
local _StartLevelChange = {}
setmetatable(_StartLevelChange, {
  __call = function(cls, self, ...)
    return cls:construct(self, ...)
  end,
})

--- Construct a WINDOW_COVERING_START_LEVEL_CHANGE object at the module instance serialization version.
---
--- @param module st.zwave.CommandClass.WindowCovering command class module instance
--- @param args st.zwave.CommandClass.WindowCovering.StartLevelChangeV1Args command-specific arguments
--- @return st.zwave.CommandClass.WindowCovering.StartLevelChange
function _StartLevelChange:construct(module, args, ...)
  return zw.Command._construct(module, WindowCovering.START_LEVEL_CHANGE, module._serialization_version, args, ...)
end

--- @class st.zwave.CommandClass.WindowCovering.StopLevelChange
--- @alias _StopLevelChange
---
--- Dynamically versioned WINDOW_COVERING_STOP_LEVEL_CHANGE
---
--- Supported versions: 1; unique base versions: 1
---
--- @field public cmd_class number 0x6A
--- @field public cmd_id number 0x07
--- @field public version number 1
--- @field public args st.zwave.CommandClass.WindowCovering.StopLevelChangeV1Args
local _StopLevelChange = {}
setmetatable(_StopLevelChange, {
  __call = function(cls, self, ...)
    return cls:construct(self, ...)
  end,
})

--- Construct a WINDOW_COVERING_STOP_LEVEL_CHANGE object at the module instance serialization version.
---
--- @param module st.zwave.CommandClass.WindowCovering command class module instance
--- @param args st.zwave.CommandClass.WindowCovering.StopLevelChangeV1Args command-specific arguments
--- @return st.zwave.CommandClass.WindowCovering.StopLevelChange
function _StopLevelChange:construct(module, args, ...)
  return zw.Command._construct(module, WindowCovering.STOP_LEVEL_CHANGE, module._serialization_version, args, ...)
end

WindowCovering.SupportedGetV1 = SupportedGetV1
WindowCovering.SupportedReportV1 = SupportedReportV1
WindowCovering.GetV1 = GetV1
WindowCovering.ReportV1 = ReportV1
WindowCovering.SetV1 = SetV1
WindowCovering.StartLevelChangeV1 = StartLevelChangeV1
WindowCovering.StopLevelChangeV1 = StopLevelChangeV1
WindowCovering.SupportedGet = _SupportedGet
WindowCovering.SupportedReport = _SupportedReport
WindowCovering.Get = _Get
WindowCovering.Report = _Report
WindowCovering.Set = _Set
WindowCovering.StartLevelChange = _StartLevelChange
WindowCovering.StopLevelChange = _StopLevelChange

WindowCovering._lut = {
  [0] = { -- dynamically versioned constructors
    [WindowCovering.SUPPORTED_GET] = WindowCovering.SupportedGet,
    [WindowCovering.SUPPORTED_REPORT] = WindowCovering.SupportedReport,
    [WindowCovering.GET] = WindowCovering.Get,
    [WindowCovering.REPORT] = WindowCovering.Report,
    [WindowCovering.SET] = WindowCovering.Set,
    [WindowCovering.START_LEVEL_CHANGE] = WindowCovering.StartLevelChange,
    [WindowCovering.STOP_LEVEL_CHANGE] = WindowCovering.StopLevelChange
  },
  [1] = { -- version 1
    [WindowCovering.SUPPORTED_GET] = WindowCovering.SupportedGetV1,
    [WindowCovering.SUPPORTED_REPORT] = WindowCovering.SupportedReportV1,
    [WindowCovering.GET] = WindowCovering.GetV1,
    [WindowCovering.REPORT] = WindowCovering.ReportV1,
    [WindowCovering.SET] = WindowCovering.SetV1,
    [WindowCovering.START_LEVEL_CHANGE] = WindowCovering.StartLevelChangeV1,
    [WindowCovering.STOP_LEVEL_CHANGE] = WindowCovering.StopLevelChangeV1
  }
}
--- @class st.zwave.CommandClass.WindowCovering.parameter_id
--- @alias parameter_id
--- @field public OUT_LEFT_1 number 0x00
--- @field public OUT_LEFT_2 number 0x01
--- @field public OUT_RIGHT_1 number 0x02
--- @field public OUT_RIGHT_2 number 0x03
--- @field public IN_LEFT_1 number 0x04
--- @field public IN_LEFT_2 number 0x05
--- @field public IN_RIGHT_1 number 0x06
--- @field public IN_RIGHT_2 number 0x07
--- @field public IN_RIGHT_LEFT_1 number 0x08
--- @field public IN_RIGHT_LEFT_2 number 0x09
--- @field public VERTICAL_SLATS_ANGLE_1 number 0x0A
--- @field public VERTICAL_SLATS_ANGLE_2 number 0x0B
--- @field public OUT_BOTTOM_1 number 0x0C
--- @field public OUT_BOTTOM_2 number 0x0D
--- @field public OUT_TOP_1 number 0x0E
--- @field public OUT_TOP_2 number 0x0F
--- @field public IN_BOTTOM_1 number 0x10
--- @field public IN_BOTTOM_2 number 0x11
--- @field public IN_TOP_1 number 0x12
--- @field public IN_TOP_2 number 0x13
--- @field public IN_TOP_BOTTOM_1 number 0x14
--- @field public IN_TOP_BOTTOM_2 number 0x15
--- @field public HORIZONTAL_SLATS_ANGLE_1 number 0x16
--- @field public HORIZONTAL_SLATS_ANGLE_2 number 0x17
local parameter_id = {
  OUT_LEFT_1 = 0x00,
  OUT_LEFT_2 = 0x01,
  OUT_RIGHT_1 = 0x02,
  OUT_RIGHT_2 = 0x03,
  IN_LEFT_1 = 0x04,
  IN_LEFT_2 = 0x05,
  IN_RIGHT_1 = 0x06,
  IN_RIGHT_2 = 0x07,
  IN_RIGHT_LEFT_1 = 0x08,
  IN_RIGHT_LEFT_2 = 0x09,
  VERTICAL_SLATS_ANGLE_1 = 0x0A,
  VERTICAL_SLATS_ANGLE_2 = 0x0B,
  OUT_BOTTOM_1 = 0x0C,
  OUT_BOTTOM_2 = 0x0D,
  OUT_TOP_1 = 0x0E,
  OUT_TOP_2 = 0x0F,
  IN_BOTTOM_1 = 0x10,
  IN_BOTTOM_2 = 0x11,
  IN_TOP_1 = 0x12,
  IN_TOP_2 = 0x13,
  IN_TOP_BOTTOM_1 = 0x14,
  IN_TOP_BOTTOM_2 = 0x15,
  HORIZONTAL_SLATS_ANGLE_1 = 0x16,
  HORIZONTAL_SLATS_ANGLE_2 = 0x17
}
WindowCovering.parameter_id = parameter_id
WindowCovering._reflect_parameter_id = zw._reflection_builder(WindowCovering.parameter_id)


return WindowCovering
