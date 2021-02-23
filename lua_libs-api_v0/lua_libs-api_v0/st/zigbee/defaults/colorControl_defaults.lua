local zcl_clusters = require "st.zigbee.zcl.clusters"
local capabilities = require "st.capabilities"
local switch_defaults = require "st.zigbee.defaults.switch_defaults"

--- @class st.zigbee.defaults.colorControl
--- @field public zigbee_handlers table
--- @field public attribute_configurations table
--- @field public capability_handlers table
local color_control_defaults = {}

--- Default handler for the current hue attribute on the color control cluster
---
--- This converts the Uint8 value of the current hue attribute on the color control cluster to
--- ColorControl.hue
---
--- @param driver ZigbeeDriver The current driver running containing necessary context for execution
--- @param device ZigbeeDevice The device this message was received from containing identifying information
--- @param value Uint8 the color control current hue value
--- @param zb_rx ZigbeeMessageRx the full message this report came in
function color_control_defaults.color_hue_handler(driver, device, value, zb_rx)
  device:emit_event_for_endpoint(
      zb_rx.address_header.src_endpoint.value,
      capabilities.colorControl.hue(math.floor(value.value / 0xFE * 100))
  )
end

--- Default handler for the current saturation attribute on the color control cluster
---
--- This converts the Uint8 value of the current saturation attribute on the color control cluster to
--- ColorControl.saturation
---
--- @param driver ZigbeeDriver The current driver running containing necessary context for execution
--- @param device ZigbeeDevice The device this message was received from containing identifying information
--- @param value Uint8 the color control current saturation value
--- @param zb_rx ZigbeeMessageRx the full message this report came in
function color_control_defaults.color_sat_handler(driver, device, value, zb_rx)
  device:emit_event_for_endpoint(
      zb_rx.address_header.src_endpoint.value,
      capabilities.colorControl.saturation(math.floor(value.value / 0xFE * 100))
  )
end

--- Default handler for the ColorControl.setColor command
---
--- This will send an on command to the on off cluster, followed by a move to hue and saturation command to the
--- color control cluster
---
--- @param driver ZigbeeDriver The current driver running containing necessary context for execution
--- @param device ZigbeeDevice The device this message was received from containing identifying information
--- @param command CapabilityCommand The capability command table
function color_control_defaults.set_color(driver, device, command)
  switch_defaults.on(driver, device, command)
  local hue = math.floor((command.args.color.hue * 0xFE) / 100.0 + 0.5)
  local sat = math.floor((command.args.color.saturation * 0xFE) / 100.0 + 0.5)
  device:send_to_component(command.component, zcl_clusters.ColorControl.server.commands.MoveToHueAndSaturation(device, hue, sat, 0x0000))

  local color_read = function(d)
    device:send_to_component(command.component, zcl_clusters.ColorControl.attributes.CurrentHue:read(device))
    device:send_to_component(command.component, zcl_clusters.ColorControl.attributes.CurrentSaturation:read(device))
  end

  device.thread:call_with_delay(2, color_read, "setColor delayed read")
end


color_control_defaults.zigbee_handlers = {
  global = {},
  cluster = {},
  attr = {
    [zcl_clusters.ColorControl] = {
      [zcl_clusters.ColorControl.attributes.CurrentHue] = color_control_defaults.color_hue_handler,
      [zcl_clusters.ColorControl.attributes.CurrentSaturation] = color_control_defaults.color_sat_handler,
    }
  }
}
color_control_defaults.capability_handlers = {
  [capabilities.colorControl.commands.setColor] = color_control_defaults.set_color
}

return color_control_defaults
