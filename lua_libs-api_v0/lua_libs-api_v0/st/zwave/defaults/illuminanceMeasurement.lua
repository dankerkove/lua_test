local capabilities = require "st.capabilities"
--- @type st.zwave.CommandClass
local cc = require "st.zwave.CommandClass"
--- @type st.zwave.CommandClass.SwitchMultilevel
local SensorMultilevel = (require "st.zwave.CommandClass.SensorMultilevel")({version=5,strict=true})

--- Default handler for sensor multilevel reports of luminance for luminance measurement-implementing devices
---
--- This converts the command sensor level to the appropriate luminance in lux (% not supported)
---
--- @param self st.zwave.Driver
--- @param device st.zwave.Device
--- @param cmd st.zwave.CommandClass.SensorMultilevel.Report
local function illuminance_report_handler(self, device, cmd)
  if (cmd.args.sensor_type == SensorMultilevel.sensor_type.LUMINANCE and
      cmd.args.scale == SensorMultilevel.scale.luminance.LUX) then
    device:emit_event(capabilities.illuminanceMeasurement.illuminance({value = cmd.args.sensor_value, unit = "lux"}))
  end
end

--- @param self st.zwave.Driver
--- @param device st.zwave.Device
local function get_refresh_commands(self, device)
  if device:supports_capability_by_id(capabilities.relativeHumidityMeasurement.ID) and device:is_cc_supported(cc.SENSOR_MULTILEVEL) then
    return {SensorMultilevel:Get({sensor_type = SensorMultilevel.sensor_type.LUMINANCE, scale = SensorMultilevel.scale.luminance.LUX})}
  end
end

--- @class st.zwave.defaults.illuminanceMeasurement
--- @alias luminance_measurement_defaults
--- @field public zwave_handlers table
--- @field public get_refresh_commands function
local luminance_measurement_defaults = {
  zwave_handlers = {
    [cc.SENSOR_MULTILEVEL] = {
      [SensorMultilevel.REPORT] = illuminance_report_handler
    }
  },
  get_refresh_commands = get_refresh_commands
}

return luminance_measurement_defaults
