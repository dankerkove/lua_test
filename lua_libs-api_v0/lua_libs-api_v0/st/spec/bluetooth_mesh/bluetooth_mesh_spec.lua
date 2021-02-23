local messages = require "st.bluetooth_mesh.messages"

describe("test bluetooth mesh message rx", function()
  local address = "\x34\x12"
  local type = "\x01"
  local index = "\x56\x78"
  local opcode_val = "\x00\x00\x82\x02"
  local opcode_len = "\x00\x02"
  local packet_len = "\x04\x00"
  local packet = "\x01\x02\x03\x04"
  it("should parse from bytes", function()
    local out_frame = messages.BluetoothMeshMessageRx.deserialize({}, address .. type .. index .. opcode_len .. opcode_val .. packet_len .. packet)
    assert.are.equal(out_frame.address:serialize(), address, "address should be correct")
    assert.are.equal(out_frame.type:serialize(), type, "type should be correct")
    assert.are.equal(out_frame.index:serialize(), index, "index should be correct")
    assert.are.equal(out_frame.opcode_len:serialize(), opcode_len, "opcode_len should be correct")
    assert.are.equal(out_frame.opcode_val:serialize(), opcode_val, "opcode_val should be correct")
    assert.are.equal(out_frame.packet_len:serialize(), packet_len, "packet_len should be correct")
    assert.are.equal(out_frame:get_length(), #address + #type + #index + #opcode_len + #opcode_val + #packet_len)
    assert.are.equal(#out_frame.packet, #packet)
    assert.are.equal(out_frame:serialize(), address .. type .. index .. opcode_len .. opcode_val .. packet_len)
  end)
end)
