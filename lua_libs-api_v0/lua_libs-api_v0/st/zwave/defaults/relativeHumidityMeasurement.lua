local capabilities = require "st.capabilities"
--- @type st.zwave.CommandClass
local cc = require "st.zwave.CommandClass"
--- @type st.zwave.CommandClass.SensorMultilevel
local SensorMultilevel = (require "st.zwave.CommandClass.SensorMultilevel")({version=5,strict=true})

--- Default handler for sensor multilevel reports of humidity for humidity measurement-implementing devices
---
--- This converts the command sensor level (0-100) to the appropriate relative humidity percentage
---
--- @param self st.zwave.Driver
--- @param device st.zwave.Device
--- @param cmd st.zwave.CommandClass.SensorMultilevel.Report
local function humidity_report_handler(self, device, cmd)
  if (cmd.args.sensor_type == SensorMultilevel.sensor_type.RELATIVE_HUMIDITY) then
    device:emit_event(capabilities.relativeHumidityMeasurement.humidity({value = cmd.args.sensor_value}))
  end
end

--- @param self st.zwave.Driver
--- @param device st.zwave.Device
local function get_refresh_commands(self, device)
  if device:supports_capability_by_id(capabilities.relativeHumidityMeasurement.ID) and device:is_cc_supported(cc.SENSOR_MULTILEVEL) then
    return {SensorMultilevel:Get({sensor_type = SensorMultilevel.sensor_type.RELATIVE_HUMIDITY, scale = SensorMultilevel.scale.relative_humidity.PERCENTAGE})}
  end
end

--- @class st.zwave.defaults.relativeHumidityMeasurement
--- @alias relative_humidity_measurement_defaults
--- @field public zwave_handlers table
--- @field public get_refresh_commands function
local relative_humidity_measurement_defaults = {
  zwave_handlers = {
    [cc.SENSOR_MULTILEVEL] = {
      [SensorMultilevel.REPORT] = humidity_report_handler
    }
  },
  get_refresh_commands = get_refresh_commands
}

return relative_humidity_measurement_defaults
