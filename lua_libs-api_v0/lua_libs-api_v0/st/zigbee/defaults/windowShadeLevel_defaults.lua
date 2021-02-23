local zcl_clusters = require "st.zigbee.zcl.clusters"
local capabilities = require "st.capabilities"

--- @class st.zigbee.defaults.windowShadeLevel
--- @field public capability_handlers table
local windowShadeLevel_defaults = {}

--- Default Command handler for Window Shade Level
---
--- @param ZigbeeDriver Driver The current driver running containing necessary context for execution
--- @param ZigbeeDevice ZigbeeDevice The device this message was received from containing identifying information
--- @param command CapabilityCommand The capability command table
function windowShadeLevel_defaults.window_shade_level_cmd(ZigbeeDriver, ZigbeeDevice, command)
  local level = command.args.shadeLevel.value
  ZigbeeDevice:send_to_component(command.component, zcl_clusters.WindowCovering.server.commands.GoToLiftPercentage(ZigbeeDevice, level))
end

windowShadeLevel_defaults.capability_handlers = {
  [capabilities.windowShadeLevel.commands.setShadeLevel] = windowShadeLevel_defaults.window_shade_level_cmd
}

return windowShadeLevel_defaults
