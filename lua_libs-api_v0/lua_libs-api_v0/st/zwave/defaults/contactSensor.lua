local capabilities = require "st.capabilities"
--- @type st.zwave.CommandClass
local cc = require "st.zwave.CommandClass"
--- @type st.zwave.CommandClass.Basic
local Basic = (require "st.zwave.CommandClass.Basic")({version=1})
--- @type st.zwave.CommandClass.Notification
local Notification = (require "st.zwave.CommandClass.Notification")({version=3})
--- @type st.zwave.CommandClass.SensorAlarm
local SensorAlarm = (require "st.zwave.CommandClass.SensorAlarm")({version=1})
--- @type st.zwave.CommandClass.SensorBinary
local SensorBinary = (require "st.zwave.CommandClass.SensorBinary")({version=2})

local function contact_report_factory(argument_field)
  return function(self, device, cmd)
    if (cmd.args[argument_field] ~= 0) then
      device:emit_event(capabilities.contactSensor.contact.open())
    else
      device:emit_event(capabilities.contactSensor.contact.closed())
    end
  end
end

--- Default handler for binary sensor command class reports
---
--- This converts binary sensor reports to correct contact open/closed events
---
--- For a device that uses v1 of the binary sensor command class, all reports will be considered
--- contact reports.
---
--- @param self st.zwave.Driver
--- @param device st.zwave.Device
--- @param cmd st.zwave.CommandClass.SensorBinary.Report
local function sensor_binary_report_handler(self, device, cmd)
  -- sensor_type will be nil if this is a v1 report
  if ((cmd.args.sensor_type ~= nil and cmd.args.sensor_type == SensorBinary.sensor_type.DOOR_WINDOW) or
        cmd.args.sensor_type == nil) then
    if (cmd.args.sensor_value == SensorBinary.sensor_value.DETECTED_AN_EVENT) then
      device:emit_event(capabilities.contactSensor.contact.open())
    elseif (cmd.args.sensor_value == SensorBinary.sensor_value.IDLE) then
      device:emit_event(capabilities.contactSensor.contact.closed())
    end
  end
end

--- Default handler for sensor alarm command class reports
---
--- This converts sensor alarm reports to correct motion active/inactive events
---
--- @param self st.zwave.Driver
--- @param device st.zwave.Device
--- @param cmd st.zwave.CommandClass.SensorAlarm.Report
local function sensor_alarm_report_handler(self, device, cmd)
  if (cmd.args.sensor_type == SensorAlarm.sensor_type.GENERAL_PURPOSE_ALARM) then
    if (cmd.args.sensor_state == SensorAlarm.sensor_state.ALARM) then
      device:emit_event(capabilities.contactSensor.contact.open())
    elseif (cmd.args.sensor_state == SensorAlarm.sensor_state.NO_ALARM) then
      device:emit_event(capabilities.contactSensor.contact.closed())
    end
  end
end

--- Default handler for notification command class reports
---
--- This converts intrusion home security reports into contact open/closed events
---
--- @param self st.zwave.Driver
--- @param device st.zwave.Device
--- @param cmd st.zwave.CommandClass.Notification
local function notification_handler(self, device, cmd)
  local contact_notification_events_map = {
    [Notification.event.home_security.INTRUSION_LOCATION_PROVIDED] = capabilities.contactSensor.contact.open(),
    [Notification.event.home_security.INTRUSION] = capabilities.contactSensor.contact.open(),
    [Notification.event.home_security.STATE_IDLE] = capabilities.contactSensor.contact.closed(),
  }

  if (cmd.args.notification_type == Notification.notification_type.HOME_SECURITY) then
    local event
    event = contact_notification_events_map[cmd.args.event]
    if (event ~= nil) then device:emit_event(event) end
  end
end

--- @param self st.zwave.Driver
--- @param device st.zwave.Device
local function get_refresh_commands(self, device)
  if device:supports_capability_by_id(capabilities.contactSensor.ID) and device:is_cc_supported(cc.SENSOR_BINARY) then
    return {SensorBinary:Get({sensor_type = SensorBinary.sensor_type.DOOR_WINDOW})}
  end
end

--- @class st.zwave.defaults.contactSensor
--- @alias contact_sensor_defaults
--- @field public zwave_handlers table
--- @field public get_refresh_commands function
local contact_sensor_defaults = {
  zwave_handlers = {
    [cc.BASIC] = {
      [Basic.REPORT] = contact_report_factory("value")
    },
    [cc.SENSOR_BINARY] = {
      [SensorBinary.REPORT] = sensor_binary_report_handler
    },
    [cc.SENSOR_ALARM] = {
      [SensorAlarm.REPORT] = sensor_alarm_report_handler
    },
    [cc.NOTIFICATION] = {
      [Notification.REPORT] = notification_handler
    }
  },
  get_refresh_commands = get_refresh_commands
}

return contact_sensor_defaults
