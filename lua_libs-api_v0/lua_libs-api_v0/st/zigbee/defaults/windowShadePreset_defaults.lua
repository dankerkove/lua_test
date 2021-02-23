local zcl_clusters = require "st.zigbee.zcl.clusters"
local capabilities = require "st.capabilities"

--- @class st.zigbee.defaults.windowShadePreset
--- @field public capability_handlers table
--- @field public PRESET_LEVEL number default value for preset level ex: 50
--- @field public PRESET_LEVEL_KEY string Key for preset level
local windowShadePreset_defaults = {}

windowShadePreset_defaults.PRESET_LEVEL = 50
windowShadePreset_defaults.PRESET_LEVEL_KEY = "_presetLevel"

--- Default Command handler for Window Shade Preset
---
--- Going to read from a field on the device if not found then default value PRESET_LEVEL
--- @param ZigbeeDriver Driver The current driver running containing necessary context for execution
--- @param ZigbeeDevice ZigbeeDevice The device this message was received from containing identifying information
--- @param command CapabilityCommand The capability command table
function windowShadePreset_defaults.window_shade_preset_cmd(ZigbeeDriver, ZigbeeDevice, command)
  local level = ZigbeeDevice:get_field(windowShadePreset_defaults.PRESET_LEVEL_KEY) or windowShadePreset_defaults.PRESET_LEVEL
  ZigbeeDevice:send_to_component(command.component, zcl_clusters.WindowCovering.server.commands.GoToLiftPercentage(ZigbeeDevice, level))
end

windowShadePreset_defaults.capability_handlers = {
  [capabilities.windowShadePreset.commands.presetPosition] = windowShadePreset_defaults.window_shade_preset_cmd
}

return windowShadePreset_defaults
