local capabilities = require "st.capabilities"
--- @type st.zwave.CommandClass
local cc = require "st.zwave.CommandClass"
--- @type st.zwave.constants
local constants = require "st.zwave.constants"
--- @type st.zwave.CommandClass.Basic
local Basic = (require "st.zwave.CommandClass.Basic")({version=1})
--- @type st.zwave.CommandClass.SwitchMultilevel
local SwitchMultilevel = (require "st.zwave.CommandClass.SwitchMultilevel")({version=4})

local PRESET_LEVEL = 50

local capability_handlers = {}

--- Issue a window shade preset position command to the specified device.
---
--- @param driver st.zwave.Driver
--- @param device st.zwave.Device
--- @param command table ST level capability command
function capability_handlers.preset_position(driver, device)
  local set
  local get
  if device:is_cc_supported(cc.SWITCH_MULTILEVEL) then
    set = SwitchMultilevel:Set({
      value = PRESET_LEVEL,
      duration = constants.DEFAULT_DIMMING_DURATION
    })
    get = SwitchMultilevel:Get({})
  else
    set = Basic:Set({
      value = PRESET_LEVEL
    })
    get = Basic:Get({})
  end
  device:send(set)
  local query_device = function()
    device:send(get)
  end
  device.thread:call_with_delay(constants.MIN_DIMMING_GET_STATUS_DELAY, query_device)
end

--- @class st.zwave.defaults.windowShadePreset
--- @alias window_shade_preset_defaults
--- @field public capability_handlers table
local window_shade_preset_defaults = {
  capability_handlers = {
    [capabilities.windowShadePreset.commands.presetPosition] = capability_handlers.preset_position
  }
}

return window_shade_preset_defaults
