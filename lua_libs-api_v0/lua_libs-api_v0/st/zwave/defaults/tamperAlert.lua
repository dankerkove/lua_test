local capabilities = require "st.capabilities"
--- @type st.zwave.CommandClass
local cc = require "st.zwave.CommandClass"
--- @type st.zwave.CommandClass.Notification
local Notification = (require "st.zwave.CommandClass.Notification")({version=3})

--- Default handler for notification command class reports
---
--- This converts tamper reports across multiple notification types into tamper events.
---
--- @param self st.zwave.Driver
--- @param device st.zwave.Device
--- @param cmd st.zwave.CommandClass.Notification.Report
local function notification_handler(self, device, cmd)
  local home_security_notification_events_map = {
    [Notification.event.home_security.TAMPERING_PRODUCT_COVER_REMOVED] = capabilities.tamperAlert.tamper.detected(),
    [Notification.event.home_security.TAMPERING_INVALID_CODE] = capabilities.tamperAlert.tamper.detected(),
    [Notification.event.home_security.TAMPERING_PRODUCT_MOVED] = capabilities.tamperAlert.tamper.detected(),
    [Notification.event.home_security.STATE_IDLE] = capabilities.tamperAlert.tamper.clear(),
  }

  local event

  if (cmd.args.notification_type == Notification.notification_type.HOME_SECURITY) then
    event = home_security_notification_events_map[cmd.args.event]
  elseif (cmd.args.notification_type == Notification.notification_type.SYSTEM) then
    if (cmd.args.event == Notification.event.system.TAMPERING_PRODUCT_COVER_REMOVED) then
      event = capabilities.tamperAlert.tamper.detected()
    elseif (cmd.args.event == Notification.event.system.STATE_IDLE) then
      event = capabilities.tamperAlert.tamper.clear()
    end
  end

  if (event ~= nil) then device:emit_event(event) end
end

--- @class st.zwave.defaults.tamperAlert
--- @alias tamper_alert_defaults
--- @field public zwave_handlers table
local tamper_alert_defaults = {
  zwave_handlers = {
    [cc.NOTIFICATION] = {
      [Notification.REPORT] = notification_handler
    }
  }
}

return tamper_alert_defaults
