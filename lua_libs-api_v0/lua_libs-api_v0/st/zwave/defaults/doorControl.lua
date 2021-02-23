local capabilities = require "st.capabilities"
--- @type st.zwave.CommandClass
local cc = require "st.zwave.CommandClass"
--- @type st.zwave.CommandClass.BarrierOperator
local BarrierOperator = (require "st.zwave.CommandClass.BarrierOperator")({version=1})

--- @param driver st.zwave.Driver
--- @param device st.zwave.Device
--- @param cmd st.zwave.CommandClass.BarrierOperator.Report
local function report_handler(driver, device, cmd)
  local event
  local contact_event -- for barrier operators that implement the contact sensor capability
  if cmd.args.state == BarrierOperator.state.CLOSED then
    event = capabilities.doorControl.door.closed()
    contact_event = capabilities.contactSensor.contact.closed()
  elseif cmd.args.state == BarrierOperator.state.CLOSING then
    event = capabilities.doorControl.door.closing()
  elseif cmd.args.state == BarrierOperator.state.STOPPED then
    event = capabilities.doorControl.door.unknown()
  elseif cmd.args.state == BarrierOperator.state.OPENING then
    event = capabilities.doorControl.door.opening()
    contact_event = capabilities.contactSensor.contact.open()
  elseif cmd.args.state == BarrierOperator.state.OPEN then
    event = capabilities.doorControl.door.open()
    contact_event = capabilities.contactSensor.contact.open()
  end

  device:emit_event(event)
  if (contact_event ~= nil) then device:emit_event(contact_event) end
end

--- @param driver st.zwave.Driver
--- @param device st.zwave.Device
local function open(driver, device)
  device:send(BarrierOperator:Set({target_value = BarrierOperator.target_value.OPEN}))
end

--- @param driver st.zwave.Driver
--- @param device st.zwave.Device
local function close(driver, device)
  device:send(BarrierOperator:Set({target_value = BarrierOperator.target_value.CLOSE}))
end

--- @class st.zwave.defaults.doorControl
--- @alias door_control_defaults
--- @field public zwave_handlers table
--- @field public capability_handlers table
local door_control_defaults = {
  zwave_handlers = {
    [cc.BARRIER_OPERATOR] = {
      [BarrierOperator.REPORT] = report_handler
    },
  },
  capability_handlers = {
    [capabilities.doorControl.commands.open] = open,
    [capabilities.doorControl.commands.close] = close
  }
}

return door_control_defaults
