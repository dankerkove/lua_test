local capabilities = require "st.capabilities"
local log = require "log"
--- @type st.zwave.CommandClass
local cc = require "st.zwave.CommandClass"
--- @type st.zwave.CommandClass.Battery
local Battery = (require "st.zwave.CommandClass.Battery")({version=1,strict=true})

--- Default handler for battery command class reports
---
--- This converts the command battery level from 0-100 -> Battery.battery(value), 0xFF -> Battery.battery(1)
---
--- @param self st.zwave.Driver
--- @param device st.zwave.Device
--- @param cmd st.zwave.CommandClass.Battery.Report
local function battery_report_handler(self, device, cmd)
  local battery_level = cmd.args.battery_level or 1
  if (battery_level == Battery.battery_level.BATTERY_LOW_WARNING) then
    battery_level = 1
  end

  if battery_level > 100 then
    log.error("Z-Wave battery report handler: invalid battery level " .. battery_level)
  else
    device:emit_event(capabilities.battery.battery(battery_level))
  end
end

--- @param self st.zwave.Driver
--- @param device st.zwave.Device
local function get_refresh_commands(self, device)
  if device:supports_capability_by_id(capabilities.battery.ID) and device:is_cc_supported(cc.BATTERY) then
    return {Battery:Get({})}
  end
end

--- @class st.zwave.defaults.battery
--- @alias battery_defaults
--- @field public zwave_handlers table
--- @field public get_refresh_commands function
local battery_defaults = {
  zwave_handlers = {
    [cc.BATTERY] = {
      [Battery.REPORT] = battery_report_handler
    }
  },
  get_refresh_commands = get_refresh_commands
}

return battery_defaults
