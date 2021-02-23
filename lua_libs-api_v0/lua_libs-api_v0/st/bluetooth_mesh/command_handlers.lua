local command_handlers = {}
local capabilities = require "st.capabilities"

local function get_unicast_addr_from_dni(dni)
  return string.pack("<I2", tonumber(string.sub(dni, 3, 6), 16))
end

function command_handlers.handle_switch_on(driver, device)
  local cmd = {}
  local address =  get_unicast_addr_from_dni(device.device_network_id)
  local type = "\x01" --Model Message Type
  local index = "\x01\x00" --AppKey Index
  local opcode_val = "\x00\x00\x82\x02" --Generic OnOff Set Opcode
  local opcode_len = "\x02\x00"
  local packet_len = "\x02\x00"
  local packet = "\x01\x01" -- Byte 0: Switch On, Byte 1: Transaction ID
  cmd = address .. type .. index .. opcode_len .. opcode_val .. packet_len .. packet

  driver:send_bt_mesh_command(device, cmd)
end

function command_handlers.handle_switch_off(driver, device)
  local cmd = {}
  local address =  get_unicast_addr_from_dni(device.device_network_id)
  local type = "\x01" --Model Message Type
  local index = "\x01\x00" --AppKey Index
  local opcode_val = "\x00\x00\x82\x02" --Generic OnOff Set Opcode
  local opcode_len = "\x02\x00"
  local packet_len = "\x02\x00"
  local packet = "\x00\x01" -- Byte 0: Switch Off, Byte 1: Transaction ID
  cmd = address .. type .. index .. opcode_len .. opcode_val .. packet_len .. packet

  driver:send_bt_mesh_command(device, cmd)
end

function command_handlers.set_level(driver, device, command)
  local cmd = {}
  local address =  get_unicast_addr_from_dni(device.device_network_id)
  local type = "\x01"
  local index = "\x01\x00"
  local opcode_val = "\x00\x00\x82\x4C"
  local opcode_len = "\x02\x00"
  local packet_len = "\x03\x00"
  local level = math.ceil(command.args.level/2) --Sylvania Lightness is on a 0-50 scale so needs to be divided by 2.
  local packet = string.char(level) .. "\x00\x01"
  cmd = address .. type .. index .. opcode_len .. opcode_val .. packet_len .. packet

  driver:send_bt_mesh_command(device, cmd)
end

return command_handlers
