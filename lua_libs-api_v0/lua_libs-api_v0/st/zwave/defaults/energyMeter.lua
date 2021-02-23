local capabilities = require "st.capabilities"
--- @type st.zwave.CommandClass
local cc = require "st.zwave.CommandClass"
--- @type st.zwave.CommandClass.Meter
local Meter = (require "st.zwave.CommandClass.Meter")({version=3})

local zwave_handlers = {}
local ENERGY_UNIT_KWH = "kWh"

--- Default handler for energy meter command class reports
---
--- @param self st.zwave.Driver
--- @param device st.zwave.Device
--- @param cmd st.zwave.CommandClass.Meter.Report
function zwave_handlers.meter_report_handler(self, device, cmd)
  if cmd.args.scale == Meter.scale.electric_meter.KILOWATT_HOURS then
    local event_arguments = {
      value = cmd.args.meter_value,
      unit = ENERGY_UNIT_KWH
    }
    device:emit_event(capabilities.energyMeter.energy(event_arguments))
  end
end

--- @param driver st.zwave.Driver
--- @param device st.zwave.Device
local function get_refresh_commands(driver, device)
  if device:supports_capability_by_id(capabilities.energyMeter.ID) and device:is_cc_supported(cc.METER) then
    return {Meter:Get({scale = Meter.scale.electric_meter.KILOWATT_HOURS})}
  end
end

--- @class st.zwave.defaults.energyMeter
--- @alias power_meter_defaults
--- @field public zwave_handlers table
--- @field public get_refresh_commands function
local power_meter_defaults = {
  zwave_handlers = {
    [cc.METER] = {
      [Meter.REPORT] = zwave_handlers.meter_report_handler
    },
  },
  get_refresh_commands = get_refresh_commands
}

return power_meter_defaults
