local capabilities = require "st.capabilities"
local log = require "log"
--- @type st.zwave.CommandClass
local cc = require "st.zwave.CommandClass"
--- @type st.zwave.CommandClass.SensorAlarm
local SensorAlarm = (require "st.zwave.CommandClass.SensorAlarm")({ version = 1 })
--- @type st.zwave.CommandClass.Notification
local Notification = (require "st.zwave.CommandClass.Notification")({ version = 3 })
--- @type st.zwave.CommandClass.SensorBinary
local SensorBinary = (require "st.zwave.CommandClass.SensorBinary")({ version = 2 })

--- Default handler for sensor alarm command class reports
---
--- This converts sensor alarm reports to smoke events
---
--- @param self st.zwave.Driver
--- @param device st.zwave.Device
--- @param cmd st.zwave.CommandClass.SensorAlarm.Report
local function sensor_alarm_report_handler(self, device, cmd)
  if (cmd.args.sensor_type == SensorAlarm.sensor_type.SMOKE_ALARM) then
    local event
    if (cmd.args.sensor_state == SensorAlarm.sensor_state.ALARM) then
      event = capabilities.smokeDetector.smoke.detected()
    elseif (cmd.args.sensor_state == SensorAlarm.sensor_state.NO_ALARM) then
      event = capabilities.smokeDetector.smoke.clear()
    end

    if event ~= nil then
      device:emit_event(event)
    end
  end
end

--- Default handler for notification command class reports
---
--- This converts notification reports into smoke events.
---
--- @param self st.zwave.Driver
--- @param device st.zwave.Device
--- @param cmd table st.zwave.CommandClass.Notification.Report
local function notification_handler(self, device, cmd)
  if cmd.version < 3 then
    -- cc.ALARM and cc.NOTIFICATION has same command class ID
    -- only version is different
    -- subdriver for cc.ALARM ( V1 and V2) should be used
    log.warn("Unhandled Alarm V2 or V1 Smoke command received.")
    return
  end

  local smoke_notification_events_map = {
    [Notification.event.smoke.DETECTED] = capabilities.smokeDetector.smoke.detected(),
    [Notification.event.smoke.DETECTED_LOCATION_PROVIDED] = capabilities.smokeDetector.smoke.detected(),
    [Notification.event.smoke.ALARM_TEST] = capabilities.smokeDetector.smoke.tested(),
    [Notification.event.smoke.STATE_IDLE] = capabilities.smokeDetector.smoke.clear(),
    [Notification.event.smoke.UNKNOWN_EVENT_STATE] = capabilities.smokeDetector.smoke.clear(),
  }

  if (cmd.args.notification_type == Notification.notification_type.SMOKE) then
    local event
    event = smoke_notification_events_map[cmd.args.event]
    if (event ~= nil) then
      device:emit_event(event)
    end
    return
  end
end

--- Default handler for binary sensor command class reports
---
--- This converts binary sensor reports to smoke events
---
--- For a device that uses v1 of the binary sensor command class, all reports will be considered
--- smoke reports.
---
--- @param self st.zwave.Driver
--- @param device st.zwave.Device
--- @param cmd table st.zwave.CommandClass.SensorBinary.Report
local function sensor_binary_report_handler(self, device, cmd)
  -- sensor_type will be nil if this is a v1 report
  if ((cmd.args.sensor_type ~= nil and cmd.args.sensor_type == SensorBinary.sensor_type.SMOKE) or
        cmd.args.sensor_type == nil) then
    if (cmd.args.sensor_value == SensorBinary.sensor_value.DETECTED_AN_EVENT) then
      device:emit_event(capabilities.smokeDetector.smoke.detected())
    elseif (cmd.args.sensor_value == SensorBinary.sensor_value.IDLE) then
      device:emit_event(capabilities.smokeDetector.smoke.clear())
    end
  end
end

--- @param self st.zwave.Driver
--- @param device st.zwave.Device
local function get_refresh_commands(self, device)
  if device:supports_capability_by_id(capabilities.smokeDetector.ID) then
    if device:is_cc_supported(cc.NOTIFICATION) then
      return {Notification:Get({ notification_type = Notification.notification_type.SMOKE })}
    elseif device:is_cc_supported(cc.SENSOR_BINARY) then
      return {SensorBinary:Get({ sensor_type = SensorBinary.sensor_type.SMOKE })}
    end
  end
end

--- @module st.zwave.defaults.smokeDetector
--- @alias smoke_detector_defaults
--- @field public zwave_handlers table
--- @field public get_refresh_commands function
local smoke_detector_defaults = {
  zwave_handlers = {
    [cc.SENSOR_BINARY] = {
      [SensorBinary.REPORT] = sensor_binary_report_handler
    },
    [cc.SENSOR_ALARM] = {
      [SensorAlarm.REPORT] = sensor_alarm_report_handler
    },
    [cc.NOTIFICATION] = {
      -- also shall handle cc.ALARM
      [Notification.REPORT] = notification_handler
    }
  },
  get_refresh_commands = get_refresh_commands
}

return smoke_detector_defaults
