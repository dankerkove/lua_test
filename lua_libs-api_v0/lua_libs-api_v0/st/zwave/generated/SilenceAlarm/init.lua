-- THIS CODE IS AUTOMATICALLY GENERATED BY zwave_lib_generator/gen.py.  DO NOT HAND EDIT.
--
-- Generator script revision: b'aa2e97900114164f8c529a796bf831ed52b6bc41'
-- Protocol definition XML version: 2.3.2

local zw = require "st.zwave"
local buf = require "st.zwave.utils.buf"
local utils = require "st.utils"

--- @class st.zwave.CommandClass.SilenceAlarm
--- @alias SilenceAlarm
---
--- Supported versions: 1
---
--- @field public SENSOR_ALARM_SET number 0x01 - SENSOR_ALARM_SET command id
local SilenceAlarm = {}
SilenceAlarm.SENSOR_ALARM_SET = 0x01

SilenceAlarm._commands = {
  [SilenceAlarm.SENSOR_ALARM_SET] = "SENSOR_ALARM_SET"
}

--- Instantiate a versioned instance of the SilenceAlarm Command Class module, optionally setting strict to require explicit passing of all parameters to constructors.
---
--- @param params st.zwave.CommandClass.Params command class instance parameters
--- @return st.zwave.CommandClass.SilenceAlarm versioned command class instance
function SilenceAlarm:init(params)
  local version = params and params.version or nil
  if (params or {}).strict ~= nil then
  local strict = params.strict
  else
  local strict = true -- default
  end
  local strict = params and params.strict or nil
  assert(version == nil or zw._versions[zw.SILENCE_ALARM][version] ~= nil, "unsupported version")
  assert(strict == nil or type(strict) == "boolean", "strict must be a boolean")
  local mt = {
    __index = self
  }
  local instance = setmetatable({}, mt)
  instance._serialization_version = version
  instance._strict = strict
  return instance
end

setmetatable(SilenceAlarm, {
  __call = SilenceAlarm.init
})

SilenceAlarm._serialization_version = nil
SilenceAlarm._strict = false
zw._deserialization_versions = zw.deserialization_versions or {}
zw._versions = zw._versions or {}
setmetatable(zw._deserialization_versions, { __index = zw._versions })
zw._versions[zw.SILENCE_ALARM] = {
  [1] = true
}

--- @class st.zwave.CommandClass.SilenceAlarm.SensorAlarmSetV1Args
--- @alias SensorAlarmSetV1Args
--- @field public mode integer see :lua:class:`SilenceAlarm.mode <st.zwave.CommandClass.SilenceAlarm.mode>`
--- @field public seconds integer [0,65535]
--- @field public general_purpose_alarm boolean
--- @field public smoke_alarm boolean
--- @field public co_alarm boolean
--- @field public co2_alarm boolean
--- @field public heat_alarm boolean
--- @field public water_leak_alarm boolean
local SensorAlarmSetV1Args = {}

--- @class st.zwave.CommandClass.SilenceAlarm.SensorAlarmSetV1:st.zwave.Command
--- @alias SensorAlarmSetV1
---
--- v1 SENSOR_ALARM_SET
---
--- @field public cmd_class number 0x9D
--- @field public cmd_id number 0x01
--- @field public version number 1
--- @field public args st.zwave.CommandClass.SilenceAlarm.SensorAlarmSetV1Args command-specific arguments
local SensorAlarmSetV1 = {}
setmetatable(SensorAlarmSetV1, {
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

--- Initialize a v1 SENSOR_ALARM_SET object.
---
--- @param module st.zwave.CommandClass.SilenceAlarm command class module instance
--- @param args st.zwave.CommandClass.SilenceAlarm.SensorAlarmSetV1Args command-specific arguments
function SensorAlarmSetV1:init(module, args, ...)
  zw.Command._parse(self, module, zw.SILENCE_ALARM, SilenceAlarm.SENSOR_ALARM_SET, 1, args, ...)
end

--- Serialize v1 SENSOR_ALARM_SET arguments.
---
--- @return string serialized payload
function SensorAlarmSetV1:serialize()
  local writer = buf.Writer()
  local args = self.args
  writer:write_u8(args.mode)
  writer:write_be_u16(args.seconds)
  writer:write_u8(1)
  writer:write_bool(args.general_purpose_alarm)
  writer:write_bool(args.smoke_alarm)
  writer:write_bool(args.co_alarm)
  writer:write_bool(args.co2_alarm)
  writer:write_bool(args.heat_alarm)
  writer:write_bool(args.water_leak_alarm)
  return writer.buf
end

--- Deserialize a v1 SENSOR_ALARM_SET payload.
---
--- @return st.zwave.CommandClass.SilenceAlarm.SensorAlarmSetV1Args deserialized arguments
function SensorAlarmSetV1:deserialize()
  local reader = buf.Reader(self.payload)
  reader:read_u8("mode")
  reader:read_be_u16("seconds")
  reader:read_u8("number_of_bit_masks")
  if reader.parsed.number_of_bit_masks > 0 then
    reader:read_bool("general_purpose_alarm")
    reader:read_bool("smoke_alarm")
    reader:read_bool("co_alarm")
    reader:read_bool("co2_alarm")
    reader:read_bool("heat_alarm")
    reader:read_bool("water_leak_alarm")
  end
  return reader.parsed
end

--- Return a deep copy of self.args, merging defaults for unset, but required parameters.
---
--- @param self st.zwave.CommandClass.SilenceAlarm.SensorAlarmSetV1
--- @return st.zwave.CommandClass.SilenceAlarm.SensorAlarmSetV1Args
function SensorAlarmSetV1._defaults(self)
  local args = {}
  args.mode = self.args.mode or 0
  args.seconds = self.args.seconds or 0
  args.general_purpose_alarm = self.args.general_purpose_alarm or false
  args.smoke_alarm = self.args.smoke_alarm or false
  args.co_alarm = self.args.co_alarm or false
  args.co2_alarm = self.args.co2_alarm or false
  args.heat_alarm = self.args.heat_alarm or false
  args.water_leak_alarm = self.args.water_leak_alarm or false
  return args
end

--- Return a deep copy of self.args, merging defaults for all unset parameters.
---
--- @param self st.zwave.CommandClass.SilenceAlarm.SensorAlarmSetV1
--- @return st.zwave.CommandClass.SilenceAlarm.SensorAlarmSetV1Args
function SensorAlarmSetV1._template(self)
  local args = self:_defaults()
  return args
end

--- Set defaults for any required, but unset arguments.
---
--- @param self st.zwave.CommandClass.SilenceAlarm.SensorAlarmSetV1
function SensorAlarmSetV1._set_defaults(self)
  local defaults = self:_defaults()
  utils.merge(self.args, defaults)
end

--- Set const reflectors to allow enum stringification.
---
--- @param self st.zwave.CommandClass.SilenceAlarm.SensorAlarmSetV1
function SensorAlarmSetV1._set_reflectors(self)
  local args = self.args
  args._reflect = args._reflect or {}
  args._reflect.mode = function()
    return zw._reflect(
      SilenceAlarm._reflect_mode,
      args.mode
    )
  end
end

--- @class st.zwave.CommandClass.SilenceAlarm.SensorAlarmSet
--- @alias _SensorAlarmSet
---
--- Dynamically versioned SENSOR_ALARM_SET
---
--- Supported versions: 1; unique base versions: 1
---
--- @field public cmd_class number 0x9D
--- @field public cmd_id number 0x01
--- @field public version number 1
--- @field public args st.zwave.CommandClass.SilenceAlarm.SensorAlarmSetV1Args
local _SensorAlarmSet = {}
setmetatable(_SensorAlarmSet, {
  __call = function(cls, self, ...)
    return cls:construct(self, ...)
  end,
})

--- Construct a SENSOR_ALARM_SET object at the module instance serialization version.
---
--- @param module st.zwave.CommandClass.SilenceAlarm command class module instance
--- @param args st.zwave.CommandClass.SilenceAlarm.SensorAlarmSetV1Args command-specific arguments
--- @return st.zwave.CommandClass.SilenceAlarm.SensorAlarmSet
function _SensorAlarmSet:construct(module, args, ...)
  return zw.Command._construct(module, SilenceAlarm.SENSOR_ALARM_SET, module._serialization_version, args, ...)
end

SilenceAlarm.SensorAlarmSetV1 = SensorAlarmSetV1
SilenceAlarm.SensorAlarmSet = _SensorAlarmSet

SilenceAlarm._lut = {
  [0] = { -- dynamically versioned constructors
    [SilenceAlarm.SENSOR_ALARM_SET] = SilenceAlarm.SensorAlarmSet
  },
  [1] = { -- version 1
    [SilenceAlarm.SENSOR_ALARM_SET] = SilenceAlarm.SensorAlarmSetV1
  }
}
--- @class st.zwave.CommandClass.SilenceAlarm.mode
--- @alias mode
--- @field public DISABLE_SOUNDING_OF_ALL_SENSOR_ALARMS number 0x00
--- @field public DISABLE_SOUNDING_OF_ALL_SENSOR_ALARMS_INDEPENDENT_OF_BIT_MASK_WHICH_HAVE_RECEIVED_THE_ALARM number 0x01
--- @field public DISABLE_SOUNDING_OF_ALL_SENSOR_ALARMS_ACCORDING_TO_BIT_MASK number 0x02
--- @field public DISABLE_SOUNDING_OF_ALL_SENSOR_ALARMS_ACCORDING_TO_BIT_MASK_WHICH_HAVE_RECEIVED_THE_ALARM number 0x03
local mode = {
  DISABLE_SOUNDING_OF_ALL_SENSOR_ALARMS = 0x00,
  DISABLE_SOUNDING_OF_ALL_SENSOR_ALARMS_INDEPENDENT_OF_BIT_MASK_WHICH_HAVE_RECEIVED_THE_ALARM = 0x01,
  DISABLE_SOUNDING_OF_ALL_SENSOR_ALARMS_ACCORDING_TO_BIT_MASK = 0x02,
  DISABLE_SOUNDING_OF_ALL_SENSOR_ALARMS_ACCORDING_TO_BIT_MASK_WHICH_HAVE_RECEIVED_THE_ALARM = 0x03
}
SilenceAlarm.mode = mode
SilenceAlarm._reflect_mode = zw._reflection_builder(SilenceAlarm.mode)


return SilenceAlarm
