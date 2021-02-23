local capabilities = require "st.capabilities"
local log = require "log"
--- @type st.zwave.CommandClass
local cc  = require "st.zwave.CommandClass"
--- @type st.zwave.constants
local constants = require "st.zwave.constants"
--- @type st.zwave.CommandClass.Basic
local Basic = (require "st.zwave.CommandClass.Basic")({version=1,strict=true})
--- @type st.zwave.CommandClass.SwitchBinary
local SwitchBinary = (require "st.zwave.CommandClass.SwitchBinary")({version=2,strict=true})
--- @type st.zwave.CommandClass.SwitchMultilevel
local SwitchMultilevel = (require "st.zwave.CommandClass.SwitchMultilevel")({version=4,strict=true})

local zwave_handlers = {}

--- Default handler for basic, binary and multilevel switch reports for
--- switch-implementing devices
---
--- This converts the command value from 0 -> Switch.switch.off, otherwise
--- Switch.switch.on.
---
--- @param driver st.zwave.Driver
--- @param device st.zwave.Device
--- @param cmd st.zwave.CommandClass.SwitchMultilevel.Report|st.zwave.CommandClass.SwitchBinary.Report|st.zwave.CommandClass.Basic.Report
function zwave_handlers.report(driver, device, cmd)
  local event
  if cmd.args.target_value ~= nil then
    -- Target value is our best inidicator of eventual state.
    -- If we see this, it should be considered authoritative.
    if cmd.args.target_value == SwitchBinary.value.OFF_DISABLE then
      event = capabilities.switch.switch.off()
    else
      event = capabilities.switch.switch.on()
    end
  else
    if cmd.args.value == SwitchBinary.value.OFF_DISABLE then
      event = capabilities.switch.switch.off()
    else
      event = capabilities.switch.switch.on()
    end
  end
  device:emit_event(event)
end

--- Interrogate the device's supported command classes to determine whether a
--- BASIC, SWITCH_BINARY or SWITCH_MULTILEVEL set should be issued to fulfill
--- the on/off capability command.
---
--- @param driver st.zwave.Driver
--- @param device st.zwave.Device
--- @param value number st.zwave.CommandClass.SwitchBinary.value.OFF_DISABLE or st.zwave.CommandClass.SwitchBinary.value.ON_ENABLE
local function switch_set_helper(driver, device, value)
  local set
  local get
  local delay = constants.DEFAULT_GET_STATUS_DELAY
  if device:is_cc_supported(cc.SWITCH_BINARY) then
    log.trace("SWITCH_BINARY supported.")
    set = SwitchBinary:Set({
      target_value = value,
      duration = 0
    })
    get = SwitchBinary:Get({})
  elseif device:is_cc_supported(cc.SWITCH_MULTILEVEL) then
    log.trace("SWITCH_MULTILEVEL supported.")
    set = SwitchMultilevel:Set({
      value = value,
      duration = constants.DEFAULT_DIMMING_DURATION
    })
    delay = constants.MIN_DIMMING_GET_STATUS_DELAY
    get = SwitchMultilevel:Get({})
  else
    log.trace("SWITCH_BINARY and SWITCH_MULTILEVEL NOT supported. Use Basic.Set()")
    set = Basic:Set({
      value = value
    })
    get = Basic:Get({})
  end
  device:send(set)
  local query_device = function()
    device:send(get)
  end
  device.thread:call_with_delay(delay, query_device)
end

local capability_handlers = {}

--- Issue a switch-on command to the specified device.
---
--- @param driver st.zwave.Driver
--- @param device st.zwave.Device
function capability_handlers.on(driver, device)
  switch_set_helper(driver, device, SwitchBinary.value.ON_ENABLE)
end

--- Issue a switch-off command to the specified device.
---
--- @param driver st.zwave.Driver
--- @param device st.zwave.Device
function capability_handlers.off(driver, device)
  switch_set_helper(driver, device, SwitchBinary.value.OFF_DISABLE)
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
    -- it is exeeds `SwitchBinary` default driver scope of responcibility
    -- but we want to handle this special case: issue command for `SwitchMultilevel`
    -- if supported
    return {SwitchMultilevel:Get({})}
  elseif device:supports_capability_by_id(capabilities.switch.ID) and device:is_cc_supported(cc.SWITCH_BINARY) then
    return {SwitchBinary:Get({})}
  elseif device:supports_capability_by_id(capabilities.switch.ID) and device:is_cc_supported(cc.BASIC) then
    return {Basic:Get({})}
  end
end

--- @class st.zwave.defaults.switch
--- @alias switch_defaults
--- @field public zwave_handlers table
--- @field public capability_handlers table
--- @field public get_refresh_commands function
local switch_defaults = {
  zwave_handlers = {
    [cc.BASIC] = {
      [Basic.REPORT] = zwave_handlers.report
    },
    [cc.SWITCH_BINARY] = {
      [SwitchBinary.REPORT] = zwave_handlers.report
    },
    [cc.SWITCH_MULTILEVEL] = {
      [SwitchMultilevel.REPORT] = zwave_handlers.report
    }
  },
  capability_handlers = {
    [capabilities.switch.commands.on] = capability_handlers.on,
    [capabilities.switch.commands.off] = capability_handlers.off
  },
  get_refresh_commands = get_refresh_commands,
}

return switch_defaults
