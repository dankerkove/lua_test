local capabilities = require "st.capabilities"
--- @type st.utils
local utils = require "st.utils"
--- @type st.zwave.CommandClass
local cc = require "st.zwave.CommandClass"
--- @type st.zwave.constants
local constants = require "st.zwave.constants"
--- @type st.zwave.CommandClass.SwitchColor
local SwitchColor = (require "st.zwave.CommandClass.SwitchColor")({version=3,strict=true})

-- We must cache data in order to translate between Z-Wave color reports and
-- ST color capability events, which do not have a 1:1 mapping.  Claim portions
-- of the device data store key space prefixed with our associated capability
-- and Z-Wave color component IDs to avoid collisions.
local CAP_CACHE_KEY = "st.capabilities." .. capabilities.colorControl.ID
local ZW_CACHE_PREFIX = "st.zwave.SwitchColor."

local zwave_handlers = {}

--- Handle an RGB Switch Color Report command received from a Z-Wave device.
--- Translate to and publish a corresponding ST color capability.
---
--- @param driver st.zwave.Driver
--- @param device st.zwave.Device
--- @param cmd st.zwave.CommandClass.SwitchColor.Report
function zwave_handlers.switch_color_report(driver, device, cmd)
  local id = cmd.args.color_component_id
  if id ~= SwitchColor.color_component_id.RED
    and id ~= SwitchColor.color_component_id.GREEN
    and id ~= SwitchColor.color_component_id.BLUE then
    return
  end
  local value
  if cmd.args.target_value ~= nil then
    -- Target value is our best inidicator of eventual state.
    -- If we see this, it should be considered authoritative.
    value = cmd.args.target_value
  else
    value = cmd.args.value
  end
  device:set_field(ZW_CACHE_PREFIX .. id, value, { persist=false })
  local cached_cmd = device:get_field(CAP_CACHE_KEY)
  local r = device:get_field(ZW_CACHE_PREFIX .. SwitchColor.color_component_id.RED)
  local g = device:get_field(ZW_CACHE_PREFIX .. SwitchColor.color_component_id.GREEN)
  local b = device:get_field(ZW_CACHE_PREFIX .. SwitchColor.color_component_id.BLUE)
  if cached_cmd ~= nil then
    local h = cached_cmd.args.color.hue
    local s = cached_cmd.args.color.saturation
    device:emit_event(capabilities.colorControl.hue(h))
    device:emit_event(capabilities.colorControl.saturation(s))
  elseif r ~= nil and g ~= nil and b ~= nil and (r > 0 or b > 0 or g > 0) then
    local h, s = utils.rgb_to_hsl(r, g, b)
    device:emit_event(capabilities.colorControl.hue(h))
    device:emit_event(capabilities.colorControl.saturation(s))
  end
end

local capability_handlers = {}

--- Issue an RGB color set command to the specified device.
---
--- @param driver st.zwave.Driver
--- @param device st.zwave.Device
--- @param cmd table ST color control capability command
function capability_handlers.set_color(driver, device, cmd)
  local duration = constants.DEFAULT_DIMMING_DURATION
  local r, g, b = utils.hsl_to_rgb(cmd.args.color.hue, cmd.args.color.saturation)
  device:set_field(CAP_CACHE_KEY, cmd)
  local set = SwitchColor:Set({
    color_components = {
      { color_component_id=SwitchColor.color_component_id.RED, value=r },
      { color_component_id=SwitchColor.color_component_id.GREEN, value=g },
      { color_component_id=SwitchColor.color_component_id.BLUE, value=b },
      { color_component_id=SwitchColor.color_component_id.WARM_WHITE, value=0 },
      { color_component_id=SwitchColor.color_component_id.COLD_WHITE, value=0 },
    },
    duration=duration
  })
  device:send(set)
  local query_color = function()
    -- Use a single RGB color key to trigger our callback to emit a color
    -- control capability update.
    device:send(SwitchColor:Get({ color_component_id=SwitchColor.color_component_id.RED }))
  end
  device.thread:call_with_delay(constants.DEFAULT_GET_STATUS_DELAY + duration, query_color)
end

--- If the device supports the colorControl capability and the Switch Color
--- command class, return an array of Switch Color GET commands to retrieve
--- RGB state.
---
--- @param driver st.zwave.Driver
--- @param device st.zwave.Device
local function get_refresh_commands(driver, device)
  if device:supports_capability_by_id(capabilities.colorControl.ID) and device:is_cc_supported(cc.SWITCH_COLOR) then
    return {
      SwitchColor:Get({ color_component_id=SwitchColor.color_component_id.RED }),
      SwitchColor:Get({ color_component_id=SwitchColor.color_component_id.GREEN }),
      SwitchColor:Get({ color_component_id=SwitchColor.color_component_id.BLUE }),
   }
  end
end

--- @class st.zwave.defaults.colorControl
--- @alias color_control_defaults
--- @field public zwave_handlers table
--- @field public capability_handlers table
local color_control_defaults = {
  zwave_handlers = {
    [cc.SWITCH_COLOR] = {
      [SwitchColor.REPORT] = zwave_handlers.switch_color_report
    }
  },
  capability_handlers = {
    [capabilities.colorControl.commands.setColor] = capability_handlers.set_color
  },
  get_refresh_commands = get_refresh_commands,
}

return color_control_defaults
