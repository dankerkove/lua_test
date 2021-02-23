local capabilities = require "st.capabilities"
--- @type st.zwave.CommandClass
local cc = require "st.zwave.CommandClass"
--- @type st.zwave.CommandClass.SensorMultilevel.Get
local SensorMultilevel = (require "st.zwave.CommandClass.SensorMultilevel")({version=5})

--- Default handler for sensor multilevel reports of temperature for temperature measurement-implementing devices
---
--- This converts the command sensor level to the appropriate temperature and scale (C or F)
---
--- @param self st.zwave.Driver
--- @param device st.zwave.Device
--- @param cmd st.zwave.CommandClass.SensorMultilevel.Report
local function temperature_report_handler(self, device, cmd)
  if (cmd.args.sensor_type == SensorMultilevel.sensor_type.TEMPERATURE) then
    local scale = 'C'
    if (cmd.args.scale == SensorMultilevel.scale.temperature.FAHRENHEIT) then scale = 'F' end
    device:emit_event(capabilities.temperatureMeasurement.temperature({value = cmd.args.sensor_value, unit = scale}))
  end
end

--- @param self st.zwave.Driver
--- @param device st.zwave.Device
local function get_refresh_commands(self, device)
  if device:supports_capability_by_id(capabilities.temperatureMeasurement.ID) and device:is_cc_supported(cc.SENSOR_MULTILEVEL) then
    return {SensorMultilevel:Get({sensor_type = SensorMultilevel.sensor_type.TEMPERATURE})}
  end
end

--- @class st.zwave.defaults.temperatureMeasurement
--- @alias temperature_measurement_defaults
--- @field public zwave_handlers table
local temperature_measurement_defaults = {
  zwave_handlers = {
    [cc.SENSOR_MULTILEVEL] = {
      [SensorMultilevel.REPORT] = temperature_report_handler
    }
  },
  get_refresh_commands = get_refresh_commands
}

return temperature_measurement_defaults
