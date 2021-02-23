local capabilities = require "st.capabilities"
--- @type st.utils
local utils = require "st.utils"
--- @type st.zwave.CommandClass
local cc = require "st.zwave.CommandClass"
--- @type st.zwave.constants
local constants = require "st.zwave.constants"
--- @type st.zwave.CommandClass.Basic
local Basic = (require "st.zwave.CommandClass.Basic")({version=1,strict=true})
--- @type st.zwave.CommandClass.SwitchBinary
local SwitchBinary = (require "st.zwave.CommandClass.SwitchBinary")({version=2,strict=true})
--- @type st.zwave.CommandClass.SwitchMultilevel
local SwitchMultilevel = (require "st.zwave.CommandClass.SwitchMultilevel")({version=4,strict=true})

local zwave_handlers = {}

--- Handle a Switch Multilevel Report command received from a Z-Wave device.
--- Translate to and publish corresponding ST capabilities.
---
--- @param driver st.zwave.Driver
--- @param device st.zwave.Device
--- @param cmd st.zwave.CommandClass.SwitchMultilevel.Report
function zwave_handlers.switch_multilevel_report(driver, device, cmd)
  local event = nil
  if cmd.args.target_value ~= nil then
    -- Target value is our best inidicator of eventual state.
    -- If we see this, it should be considered authoritative.
    if cmd.args.target_value > 0 then -- level 0 is switch off, not level set
      event = capabilities.switchLevel.level(cmd.args.target_value)
    end
  else
    if cmd.args.value > 0 then -- level 0 is switch off, not level set
      event = capabilities.switchLevel.level(cmd.args.value)
    end
  end
  if event ~= nil then
    device:emit_event(event)
  end
end

local capability_handlers = {}

--- Issue a level-set command to the specified device.
---
--- @param driver st.zwave.Driver
--- @param device st.zwave.Device
--- @param command table ST level capability command
function capability_handlers.switch_level_set(driver, device, command)
  local level = utils.round(command.args.level)
  level = utils.clamp_value(level, 1, 99)
  local dimmingDuration = command.args.rate or constants.DEFAULT_DIMMING_DURATION -- dimming duration in seconds
  device:send(SwitchMultilevel:Set({ value=level, duration=dimmingDuration }))
  local query_level = function()
    device:send(SwitchMultilevel:Get({}))
  end
  -- delay shall be at least 5 sec.
  local delay = math.max(dimmingDuration + constants.DEFAULT_POST_DIMMING_DELAY , constants.MIN_DIMMING_GET_STATUS_DELAY) --delay in seconds
  device.thread:call_with_delay(delay, query_level)
end

--- Find single best match from
--- {SwitchMultilevel:Get(), SwitchBinary:Get(), Basic:Get()}
--- based on supported combination of 2 capabilities:{`switch` and `switch level`}
--- and 3 command classes { Basic, SwitchBinary, SwitchMultilevel }
---
--- @param driver st.zwave.Driver
--- @param device st.zwave.Device
local function get_refresh_commands(driver, device)
  if device:supports_capability_by_id(capabilities.switchLevel.ID) and device:is_cc_supported(cc.SWITCH_MULTILEVEL) then
    return {SwitchMultilevel:Get({})}
  elseif device:supports_capability_by_id(capabilities.switch.ID) and device:is_cc_supported(cc.SWITCH_BINARY) then
    -- this is indication that driver is used for wrong device
    -- but we want to have switch refresh command if possible
    return {SwitchBinary:Get({})}
  elseif device:supports_capability_by_id(capabilities.switch.ID) and device:is_cc_supported(cc.BASIC) then
    -- this is indication that driver is used for wrong device
    -- but we want to have switch refresh command if possible
    return {Basic:Get({})}
  end
end

--- @class st.zwave.defaults.switchLevel
--- @alias switch_level_defaults
--- @field public zwave_handlers table
--- @field public capability_handlers table
--- @field public get_refresh_commands function
local switch_level_defaults = {
  zwave_handlers = {
    [cc.SWITCH_MULTILEVEL] = {
      [SwitchMultilevel.REPORT] = zwave_handlers.switch_multilevel_report
    }
  },
  capability_handlers = {
    [capabilities.switchLevel.commands.setLevel] = capability_handlers.switch_level_set
  },
  get_refresh_commands = get_refresh_commands
}

return switch_level_defaults
