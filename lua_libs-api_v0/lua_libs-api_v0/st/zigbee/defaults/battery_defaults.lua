local zcl_clusters = require "st.zigbee.zcl.clusters"
local capabilities = require "st.capabilities"
local utils = require "st.utils"

--- @class st.zigbee.defaults.battery
--- @field public zigbee_handlers table
--- @field public attribute_configurations table
--- @field public capability_handlers table
--- @field public default_voltage_configuration st.zigbee.defaults.battery.BatteryVoltageConfiguration
--- @field public default_percentage_configuration st.zigbee.defaults.battery.BatteryPercentageConfiguration
local battery_defaults = {}

--- Default handler for battery voltage attribute on the power config cluster
---
--- This converts the Uint8 value from 0-254 to Battery.battery(0-100).  This follows the default linear range of 2 to 3
--- volts so is only useful for coin cell batteries and of limited use there.  It is recommended if possible to use
--- either the battery percentage remaining attribute if available, or to implement a custom conversion of voltage to
--- percentage.
---
--- @param driver ZigbeeDriver The current driver running containing necessary context for execution
--- @param device ZigbeeDevice The device this message was received from containing identifying information
--- @param value Uint8 the value of the battery voltage on the power config cluster
--- @param zb_rx ZigbeeMessageRx the full message this report came in
function battery_defaults.battery_volt_attr_handler(driver, device, value, zb_rx)
  local bat_default_min = 20.0
  local bat_default_max = 30.0
  local batt_perc = math.floor(((value.value - bat_default_min) / (bat_default_max - bat_default_min) * 100) + 0.5)
  device:emit_event_for_endpoint(
      zb_rx.address_header.src_endpoint.value,
      capabilities.battery.battery(utils.clamp_value(batt_perc, 0, 100))
  )
end

--- Default handler for battery percentage attribute on the power config cluster
---
--- This converts the Uint8 value from 0-254 to Battery.battery(0-100).
---
--- @param driver ZigbeeDriver The current driver running containing necessary context for execution
--- @param device ZigbeeDevice The device this message was received from containing identifying information
--- @param value Uint8 the value of the battery percentage on the power config cluster
--- @param zb_rx ZigbeeMessageRx the full message this report came in
function battery_defaults.battery_perc_attr_handler(driver, device, value, zb_rx)
  device:emit_event_for_endpoint(
      zb_rx.address_header.src_endpoint.value,
      capabilities.battery.battery(math.floor(value.value / 2.0 + 0.5))
  )
end

battery_defaults.zigbee_handlers = {
  global = {},
  cluster = {},
  attr = {
    [zcl_clusters.PowerConfiguration] = {
      [zcl_clusters.PowerConfiguration.attributes.BatteryVoltage] = battery_defaults.battery_volt_attr_handler,
      [zcl_clusters.PowerConfiguration.attributes.BatteryPercentageRemaining] = battery_defaults.battery_perc_attr_handler,
    }
  }
}

--- @class st.zigbee.defaults.battery.BatteryVoltageConfiguration
--- @field public cluster number PowerConfiguration ID 0x0001
--- @field public attribute number BatteryVoltage ID 0x0020
--- @field public minimum_interval number 30 seconds
--- @field public maximum_interval number 21600 seconds (6 hours)
--- @field public data_type Uint8 the Uint8 class
--- @field public reportable_change number 1 (.01 volts)
local default_voltage_configuration = {
  cluster = zcl_clusters.PowerConfiguration.ID,
  attribute = zcl_clusters.PowerConfiguration.attributes.BatteryVoltage.ID,
  minimum_interval = 30,
  maximum_interval = 21600,
  data_type = zcl_clusters.PowerConfiguration.attributes.BatteryVoltage.base_type,
  reportable_change = 1
}

--- @class st.zigbee.defaults.battery.BatteryPercentageConfiguration
--- @field public cluster number PowerConfiguration ID 0x0001
--- @field public attribute number BatteryPercentageRemaining ID 0x0021
--- @field public minimum_interval number 30 seconds
--- @field public maximum_interval number 21600 seconds (6 hours)
--- @field public data_type Uint8 the Uint8 class
--- @field public reportable_change number 1 (.5 percent)
local default_percentage_configuration = {
    cluster = zcl_clusters.PowerConfiguration.ID,
    attribute = zcl_clusters.PowerConfiguration.attributes.BatteryPercentageRemaining.ID,
    minimum_interval = 30,
    maximum_interval = 21600,
    data_type = zcl_clusters.PowerConfiguration.attributes.BatteryPercentageRemaining.base_type,
    reportable_change = 1
}

battery_defaults.default_voltage_configuration = default_voltage_configuration
battery_defaults.default_percentage_configuration = default_percentage_configuration

battery_defaults.capability_handlers = {}

battery_defaults.attribute_configurations = {
  default_voltage_configuration,
  default_percentage_configuration
}

return battery_defaults
