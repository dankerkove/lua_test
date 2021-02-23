-- THIS CODE IS AUTOMATICALLY GENERATED BY zwave_lib_generator/gen.py.  DO NOT HAND EDIT.
--
-- Generator script revision: b'aa2e97900114164f8c529a796bf831ed52b6bc41'
-- Protocol definition XML version: 2.3.2

local zw = require "st.zwave"
local buf = require "st.zwave.utils.buf"
local utils = require "st.utils"

--- @class st.zwave.CommandClass.SceneControllerConf
--- @alias SceneControllerConf
---
--- Supported versions: 1
---
--- @field public SET number 0x01 - SCENE_CONTROLLER_CONF_SET command id
--- @field public GET number 0x02 - SCENE_CONTROLLER_CONF_GET command id
--- @field public REPORT number 0x03 - SCENE_CONTROLLER_CONF_REPORT command id
local SceneControllerConf = {}
SceneControllerConf.SET = 0x01
SceneControllerConf.GET = 0x02
SceneControllerConf.REPORT = 0x03

SceneControllerConf._commands = {
  [SceneControllerConf.SET] = "SET",
  [SceneControllerConf.GET] = "GET",
  [SceneControllerConf.REPORT] = "REPORT"
}

--- Instantiate a versioned instance of the SceneControllerConf Command Class module, optionally setting strict to require explicit passing of all parameters to constructors.
---
--- @param params st.zwave.CommandClass.Params command class instance parameters
--- @return st.zwave.CommandClass.SceneControllerConf versioned command class instance
function SceneControllerConf:init(params)
  local version = params and params.version or nil
  if (params or {}).strict ~= nil then
  local strict = params.strict
  else
  local strict = true -- default
  end
  local strict = params and params.strict or nil
  assert(version == nil or zw._versions[zw.SCENE_CONTROLLER_CONF][version] ~= nil, "unsupported version")
  assert(strict == nil or type(strict) == "boolean", "strict must be a boolean")
  local mt = {
    __index = self
  }
  local instance = setmetatable({}, mt)
  instance._serialization_version = version
  instance._strict = strict
  return instance
end

setmetatable(SceneControllerConf, {
  __call = SceneControllerConf.init
})

SceneControllerConf._serialization_version = nil
SceneControllerConf._strict = false
zw._deserialization_versions = zw.deserialization_versions or {}
zw._versions = zw._versions or {}
setmetatable(zw._deserialization_versions, { __index = zw._versions })
zw._versions[zw.SCENE_CONTROLLER_CONF] = {
  [1] = true
}

--- @class st.zwave.CommandClass.SceneControllerConf.SetV1Args
--- @alias SetV1Args
--- @field public group_id integer [0,255]
--- @field public scene_id integer [0,255]
--- @field public dimming_duration number|string [0,7620] or "default"
local SetV1Args = {}

--- @class st.zwave.CommandClass.SceneControllerConf.SetV1:st.zwave.Command
--- @alias SetV1
---
--- v1 SCENE_CONTROLLER_CONF_SET
---
--- @field public cmd_class number 0x2D
--- @field public cmd_id number 0x01
--- @field public version number 1
--- @field public args st.zwave.CommandClass.SceneControllerConf.SetV1Args command-specific arguments
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

--- Initialize a v1 SCENE_CONTROLLER_CONF_SET object.
---
--- @param module st.zwave.CommandClass.SceneControllerConf command class module instance
--- @param args st.zwave.CommandClass.SceneControllerConf.SetV1Args command-specific arguments
function SetV1:init(module, args, ...)
  zw.Command._parse(self, module, zw.SCENE_CONTROLLER_CONF, SceneControllerConf.SET, 1, args, ...)
end

--- Serialize v1 SCENE_CONTROLLER_CONF_SET arguments.
---
--- @return string serialized payload
function SetV1:serialize()
  local writer = buf.Writer()
  local args = self.args
  writer:write_u8(args.group_id)
  writer:write_u8(args.scene_id)
  writer:write_actuator_duration_set(args.dimming_duration)
  return writer.buf
end

--- Deserialize a v1 SCENE_CONTROLLER_CONF_SET payload.
---
--- @return st.zwave.CommandClass.SceneControllerConf.SetV1Args deserialized arguments
function SetV1:deserialize()
  local reader = buf.Reader(self.payload)
  reader:read_u8("group_id")
  reader:read_u8("scene_id")
  reader:read_actuator_duration_set("dimming_duration")
  return reader.parsed
end

--- Return a deep copy of self.args, merging defaults for unset, but required parameters.
---
--- @param self st.zwave.CommandClass.SceneControllerConf.SetV1
--- @return st.zwave.CommandClass.SceneControllerConf.SetV1Args
function SetV1._defaults(self)
  local args = {}
  args.group_id = self.args.group_id or 0
  args.scene_id = self.args.scene_id or 0
  args.dimming_duration = self.args.dimming_duration or 0
  return args
end

--- Return a deep copy of self.args, merging defaults for all unset parameters.
---
--- @param self st.zwave.CommandClass.SceneControllerConf.SetV1
--- @return st.zwave.CommandClass.SceneControllerConf.SetV1Args
function SetV1._template(self)
  local args = self:_defaults()
  return args
end

--- Set defaults for any required, but unset arguments.
---
--- @param self st.zwave.CommandClass.SceneControllerConf.SetV1
function SetV1._set_defaults(self)
  local defaults = self:_defaults()
  utils.merge(self.args, defaults)
end

--- Set const reflectors to allow enum stringification.
---
--- @param self st.zwave.CommandClass.SceneControllerConf.SetV1
function SetV1._set_reflectors(self)
end

--- @class st.zwave.CommandClass.SceneControllerConf.GetV1Args
--- @alias GetV1Args
--- @field public group_id integer [0,255]
local GetV1Args = {}

--- @class st.zwave.CommandClass.SceneControllerConf.GetV1:st.zwave.Command
--- @alias GetV1
---
--- v1 SCENE_CONTROLLER_CONF_GET
---
--- @field public cmd_class number 0x2D
--- @field public cmd_id number 0x02
--- @field public version number 1
--- @field public args st.zwave.CommandClass.SceneControllerConf.GetV1Args command-specific arguments
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

--- Initialize a v1 SCENE_CONTROLLER_CONF_GET object.
---
--- @param module st.zwave.CommandClass.SceneControllerConf command class module instance
--- @param args st.zwave.CommandClass.SceneControllerConf.GetV1Args command-specific arguments
function GetV1:init(module, args, ...)
  zw.Command._parse(self, module, zw.SCENE_CONTROLLER_CONF, SceneControllerConf.GET, 1, args, ...)
end

--- Serialize v1 SCENE_CONTROLLER_CONF_GET arguments.
---
--- @return string serialized payload
function GetV1:serialize()
  local writer = buf.Writer()
  local args = self.args
  writer:write_u8(args.group_id)
  return writer.buf
end

--- Deserialize a v1 SCENE_CONTROLLER_CONF_GET payload.
---
--- @return st.zwave.CommandClass.SceneControllerConf.GetV1Args deserialized arguments
function GetV1:deserialize()
  local reader = buf.Reader(self.payload)
  reader:read_u8("group_id")
  return reader.parsed
end

--- Return a deep copy of self.args, merging defaults for unset, but required parameters.
---
--- @param self st.zwave.CommandClass.SceneControllerConf.GetV1
--- @return st.zwave.CommandClass.SceneControllerConf.GetV1Args
function GetV1._defaults(self)
  local args = {}
  args.group_id = self.args.group_id or 0
  return args
end

--- Return a deep copy of self.args, merging defaults for all unset parameters.
---
--- @param self st.zwave.CommandClass.SceneControllerConf.GetV1
--- @return st.zwave.CommandClass.SceneControllerConf.GetV1Args
function GetV1._template(self)
  local args = self:_defaults()
  return args
end

--- Set defaults for any required, but unset arguments.
---
--- @param self st.zwave.CommandClass.SceneControllerConf.GetV1
function GetV1._set_defaults(self)
  local defaults = self:_defaults()
  utils.merge(self.args, defaults)
end

--- Set const reflectors to allow enum stringification.
---
--- @param self st.zwave.CommandClass.SceneControllerConf.GetV1
function GetV1._set_reflectors(self)
end

--- @class st.zwave.CommandClass.SceneControllerConf.ReportV1Args
--- @alias ReportV1Args
--- @field public group_id integer [0,255]
--- @field public scene_id integer [0,255]
--- @field public dimming_duration number|string [0,7560] or "unknown" or "reserved"
local ReportV1Args = {}

--- @class st.zwave.CommandClass.SceneControllerConf.ReportV1:st.zwave.Command
--- @alias ReportV1
---
--- v1 SCENE_CONTROLLER_CONF_REPORT
---
--- @field public cmd_class number 0x2D
--- @field public cmd_id number 0x03
--- @field public version number 1
--- @field public args st.zwave.CommandClass.SceneControllerConf.ReportV1Args command-specific arguments
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

--- Initialize a v1 SCENE_CONTROLLER_CONF_REPORT object.
---
--- @param module st.zwave.CommandClass.SceneControllerConf command class module instance
--- @param args st.zwave.CommandClass.SceneControllerConf.ReportV1Args command-specific arguments
function ReportV1:init(module, args, ...)
  zw.Command._parse(self, module, zw.SCENE_CONTROLLER_CONF, SceneControllerConf.REPORT, 1, args, ...)
end

--- Serialize v1 SCENE_CONTROLLER_CONF_REPORT arguments.
---
--- @return string serialized payload
function ReportV1:serialize()
  local writer = buf.Writer()
  local args = self.args
  writer:write_u8(args.group_id)
  writer:write_u8(args.scene_id)
  writer:write_actuator_duration_report(args.dimming_duration)
  return writer.buf
end

--- Deserialize a v1 SCENE_CONTROLLER_CONF_REPORT payload.
---
--- @return st.zwave.CommandClass.SceneControllerConf.ReportV1Args deserialized arguments
function ReportV1:deserialize()
  local reader = buf.Reader(self.payload)
  reader:read_u8("group_id")
  reader:read_u8("scene_id")
  reader:read_actuator_duration_report("dimming_duration")
  return reader.parsed
end

--- Return a deep copy of self.args, merging defaults for unset, but required parameters.
---
--- @param self st.zwave.CommandClass.SceneControllerConf.ReportV1
--- @return st.zwave.CommandClass.SceneControllerConf.ReportV1Args
function ReportV1._defaults(self)
  local args = {}
  args.group_id = self.args.group_id or 0
  args.scene_id = self.args.scene_id or 0
  args.dimming_duration = self.args.dimming_duration or 0
  return args
end

--- Return a deep copy of self.args, merging defaults for all unset parameters.
---
--- @param self st.zwave.CommandClass.SceneControllerConf.ReportV1
--- @return st.zwave.CommandClass.SceneControllerConf.ReportV1Args
function ReportV1._template(self)
  local args = self:_defaults()
  return args
end

--- Set defaults for any required, but unset arguments.
---
--- @param self st.zwave.CommandClass.SceneControllerConf.ReportV1
function ReportV1._set_defaults(self)
  local defaults = self:_defaults()
  utils.merge(self.args, defaults)
end

--- Set const reflectors to allow enum stringification.
---
--- @param self st.zwave.CommandClass.SceneControllerConf.ReportV1
function ReportV1._set_reflectors(self)
end

--- @class st.zwave.CommandClass.SceneControllerConf.Set
--- @alias _Set
---
--- Dynamically versioned SCENE_CONTROLLER_CONF_SET
---
--- Supported versions: 1; unique base versions: 1
---
--- @field public cmd_class number 0x2D
--- @field public cmd_id number 0x01
--- @field public version number 1
--- @field public args st.zwave.CommandClass.SceneControllerConf.SetV1Args
local _Set = {}
setmetatable(_Set, {
  __call = function(cls, self, ...)
    return cls:construct(self, ...)
  end,
})

--- Construct a SCENE_CONTROLLER_CONF_SET object at the module instance serialization version.
---
--- @param module st.zwave.CommandClass.SceneControllerConf command class module instance
--- @param args st.zwave.CommandClass.SceneControllerConf.SetV1Args command-specific arguments
--- @return st.zwave.CommandClass.SceneControllerConf.Set
function _Set:construct(module, args, ...)
  return zw.Command._construct(module, SceneControllerConf.SET, module._serialization_version, args, ...)
end

--- @class st.zwave.CommandClass.SceneControllerConf.Get
--- @alias _Get
---
--- Dynamically versioned SCENE_CONTROLLER_CONF_GET
---
--- Supported versions: 1; unique base versions: 1
---
--- @field public cmd_class number 0x2D
--- @field public cmd_id number 0x02
--- @field public version number 1
--- @field public args st.zwave.CommandClass.SceneControllerConf.GetV1Args
local _Get = {}
setmetatable(_Get, {
  __call = function(cls, self, ...)
    return cls:construct(self, ...)
  end,
})

--- Construct a SCENE_CONTROLLER_CONF_GET object at the module instance serialization version.
---
--- @param module st.zwave.CommandClass.SceneControllerConf command class module instance
--- @param args st.zwave.CommandClass.SceneControllerConf.GetV1Args command-specific arguments
--- @return st.zwave.CommandClass.SceneControllerConf.Get
function _Get:construct(module, args, ...)
  return zw.Command._construct(module, SceneControllerConf.GET, module._serialization_version, args, ...)
end

--- @class st.zwave.CommandClass.SceneControllerConf.Report
--- @alias _Report
---
--- Dynamically versioned SCENE_CONTROLLER_CONF_REPORT
---
--- Supported versions: 1; unique base versions: 1
---
--- @field public cmd_class number 0x2D
--- @field public cmd_id number 0x03
--- @field public version number 1
--- @field public args st.zwave.CommandClass.SceneControllerConf.ReportV1Args
local _Report = {}
setmetatable(_Report, {
  __call = function(cls, self, ...)
    return cls:construct(self, ...)
  end,
})

--- Construct a SCENE_CONTROLLER_CONF_REPORT object at the module instance serialization version.
---
--- @param module st.zwave.CommandClass.SceneControllerConf command class module instance
--- @param args st.zwave.CommandClass.SceneControllerConf.ReportV1Args command-specific arguments
--- @return st.zwave.CommandClass.SceneControllerConf.Report
function _Report:construct(module, args, ...)
  return zw.Command._construct(module, SceneControllerConf.REPORT, module._serialization_version, args, ...)
end

SceneControllerConf.SetV1 = SetV1
SceneControllerConf.GetV1 = GetV1
SceneControllerConf.ReportV1 = ReportV1
SceneControllerConf.Set = _Set
SceneControllerConf.Get = _Get
SceneControllerConf.Report = _Report

SceneControllerConf._lut = {
  [0] = { -- dynamically versioned constructors
    [SceneControllerConf.SET] = SceneControllerConf.Set,
    [SceneControllerConf.GET] = SceneControllerConf.Get,
    [SceneControllerConf.REPORT] = SceneControllerConf.Report
  },
  [1] = { -- version 1
    [SceneControllerConf.SET] = SceneControllerConf.SetV1,
    [SceneControllerConf.GET] = SceneControllerConf.GetV1,
    [SceneControllerConf.REPORT] = SceneControllerConf.ReportV1
  }
}

return SceneControllerConf
