local capabilities = require "st.capabilities"
--- @type st.zwave.CommandClass
local cc  = require "st.zwave.CommandClass"
--- @type st.zwave.constants
local constants = require "st.zwave.constants"
--- @type st.zwave.CommandClass.Basic
local Basic = (require "st.zwave.CommandClass.Basic")({ version=1, strict=true })
--- @type st.zwave.CommandClass.SwitchBinary
local SwitchBinary = (require "st.zwave.CommandClass.SwitchBinary")({ version=2, strict=true })
--- @type log
local log = require "log"

local zwave_handlers = {}

--- Default handler binary switch reports for
--- valve (switch-implementing) devices
---
--- This converts the Z-Wave command value
--- to capability.valve open/closed
---
--- @param driver st.zwave.Driver
--- @param device st.zwave.Device
--- @param cmd st.zwave.CommandClass.SwitchBinary.Report|st.zwave.CommandClass.Basic.Report
function zwave_handlers.report(driver, device, cmd)
  local event
  if cmd.args.target_value ~= nil then
    -- Target value is our best inidicator of eventual state.
    -- If we see this, it should be considered authoritative.
    if cmd.args.target_value == SwitchBinary.value.OFF_DISABLE then
      event = capabilities.valve.valve.closed()
    else
      event = capabilities.valve.valve.open()
    end
  else
    if cmd.args.value == SwitchBinary.value.OFF_DISABLE then
      event = capabilities.valve.valve.closed()
    else
      event = capabilities.valve.valve.open()
    end
  end
  device:emit_event(event)
end

--- Interrogate the device's supported command classes to determine whether a
--- BASIC, SWITCH_BINARY set should be issued to fulfill
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
  else
    log.trace("SWITCH_BINARY supported. Use Basic.Set()")
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

--- Issue a valve open command to the specified device.
---
--- @param driver st.zwave.Driver
--- @param device st.zwave.Device
function capability_handlers.open(driver, device)
  switch_set_helper(driver, device, SwitchBinary.value.ON_ENABLE)
end

--- Issue a valve closed ( switch.OFF) command to the specified device.
---
--- @param driver st.zwave.Driver
--- @param device st.zwave.Device
function capability_handlers.close(driver, device)
  switch_set_helper(driver, device, SwitchBinary.value.OFF_DISABLE)
end

--- Find single best match from
--- SwitchBinary:Get(), Basic:Get()}
---
--- @param driver st.zwave.Driver
--- @param device st.zwave.Device
local function get_refresh_commands(driver, device)
  if device:is_cc_supported(cc.SWITCH_BINARY) then
    return {SwitchBinary:Get({})}
  else
    return {Basic:Get({})}
  end
end

--- @class st.zwave.defaults.valve
--- @alias valve_defaults valve_defaults
--- @field public zwave_handlers table
--- @field public capability_handlers table
--- @field public get_refresh_commands function
local valve_defaults = {
  zwave_handlers = {
    [cc.BASIC] = {
      [Basic.REPORT] = zwave_handlers.report
    },
    [cc.SWITCH_BINARY] = {
      [SwitchBinary.REPORT] = zwave_handlers.report
    },
  },
  capability_handlers = {
    [capabilities.valve.commands.open] = capability_handlers.open,
    [capabilities.valve.commands.close] = capability_handlers.close,
  },
  get_refresh_commands = get_refresh_commands,
}

return valve_defaults
