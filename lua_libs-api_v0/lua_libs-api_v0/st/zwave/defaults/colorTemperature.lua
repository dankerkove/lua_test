local capabilities = require "st.capabilities"
--- @type st.zwave.CommandClass
local cc = require "st.zwave.CommandClass"
--- @type st.zwave.constants
local constants = require "st.zwave.constants"
--- @type st.zwave.utils.color
local color_utils = require "st.zwave.utils.color"
--- @type st.zwave.CommandClass.SwitchColor
local SwitchColor = (require "st.zwave.CommandClass.SwitchColor")({version=3,strict=true})

-- We must cache data in order to translate between Z-Wave color reports and
-- ST color temperature capability events, which do not have a 1:1 mapping.
-- Claim portions of the device data store key space prefixed with our
-- associated capability and Z-Wave color component IDs to avoid collisions.
local CAP_CACHE_KEY = "st.capabilities." .. capabilities.colorTemperature.ID
local ZW_CACHE_PREFIX = "st.zwave.SwitchColor."

local zwave_handlers = {}

--- Handle a Switch Color Report command received from a Z-Wave device.
--- Translate to and publish a corresponding ST color temperature color event.
---
--- @param driver st.zwave.Driver
--- @param device st.zwave.Device
--- @param cmd st.zwave.CommandClass.SwitchColor.Report
function zwave_handlers.switch_color_report(driver, device, cmd)
  local id = cmd.args.color_component_id
  if id ~= SwitchColor.color_component_id.WARM_WHITE
    and id ~= SwitchColor.color_component_id.COLD_WHITE then
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
  local cached_ev = device:get_field(CAP_CACHE_KEY)
  local ww = device:get_field(ZW_CACHE_PREFIX .. SwitchColor.color_component_id.WARM_WHITE)
  local cw = device:get_field(ZW_CACHE_PREFIX .. SwitchColor.color_component_id.COLD_WHITE)
  if cached_ev ~= nil then
    device:emit_event(cached_ev)
  elseif ww ~= nil and cw ~= nil and (ww > 0 or cw > 0) then
    local t = color_utils.white2Temp(ww, cw)
    device:emit_event(capabilities.colorTemperature.colorTemperature(t))
  end
end

local capability_handlers = {}

--- Issue a color temperature set command to the specified device.
---
--- @param driver st.zwave.Driver
--- @param device st.zwave.Device
--- @param cmd table ST color control capability command
function capability_handlers.set_color_temperature(driver, device, cmd)
  local duration = constants.DEFAULT_DIMMING_DURATION
  local t = cmd.args.temperature
  local cached_ev = capabilities.colorTemperature.colorTemperature(t)
  device:set_field(CAP_CACHE_KEY, cached_ev)
  local ww, cw = color_utils.temp2White(t)
  local set = SwitchColor:Set({
    color_components = {
      { color_component_id=SwitchColor.color_component_id.RED, value=0 },
      { color_component_id=SwitchColor.color_component_id.GREEN, value=0 },
      { color_component_id=SwitchColor.color_component_id.BLUE, value=0 },
      { color_component_id=SwitchColor.color_component_id.WARM_WHITE, value=ww },
      { color_component_id = SwitchColor.color_component_id.COLD_WHITE, value=cw },
    },
    duration=duration
  })
  device:send(set)
  local query_temp = function()
    -- Use a single white color key to trigger our callback to emit a color
    -- temperature capability event update.
    device:send(SwitchColor:Get({ color_component_id=SwitchColor.color_component_id.WARM_WHITE }))
  end
  device.thread:call_with_delay(constants.DEFAULT_GET_STATUS_DELAY  + duration, query_temp)
end

--- If the device supports the colorTemperature capability and the Switch Color
--- command class, return an array of Switch Color GET commands to retrieve
--- color temperature state.
---
--- @param driver st.zwave.Driver
--- @param device st.zwave.Device
local function get_refresh_commands(driver, device)
  if device:supports_capability_by_id(capabilities.colorControl.ID) and device:is_cc_supported(cc.SWITCH_COLOR) then
    return {
      SwitchColor:Get({ color_component_id=SwitchColor.color_component_id.WARM_WHITE }),
      SwitchColor:Get({ color_component_id=SwitchColor.color_component_id.COLD_WHITE }),
   }
  end
end

--- @class st.zwave.defaults.colorTemperature
--- @alias color_temperature_defaults
--- @field public zwave_handlers table
--- @field public capability_handlers table
local color_temperature_defaults = {
  zwave_handlers = {
    [cc.SWITCH_COLOR] = {
      [SwitchColor.REPORT] = zwave_handlers.switch_color_report
    }
  },
  capability_handlers = {
    [capabilities.colorTemperature.commands.setColorTemperature] = capability_handlers.set_color_temperature
  },
  get_refresh_commands = get_refresh_commands,
}

return color_temperature_defaults
