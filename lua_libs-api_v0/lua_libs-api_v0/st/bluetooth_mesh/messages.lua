local messages = {}

local driver = require "st.driver"
local data_types = require "st.zigbee.data_types"
local utils = require "st.zigbee.utils"
local buf_lib = require "st.buf"

local BluetoothMeshMessageRx = {
  NAME = "BTMeshMessageRx"
}

messages.BluetoothMeshMessageRx = BluetoothMeshMessageRx

--- @function BluetoothMeshMessageRx:deserialize
--- A function to take a stream of bytes and parse a received Bluetooth Mesh Rx message (device -> hub)
--- @param proto table A prototype table for the class
--- @param str string The byte string
--- @return BluetoothMeshMessageRx an instance of a BluetoothMeshMessageRx parsed from the byte string
function BluetoothMeshMessageRx.deserialize(proto, str)
  local self = proto or {}
  local pos = 1
  local buf = buf_lib.Reader(str)
  self.address = data_types.Uint16.deserialize(buf)
  self.address.field_name = "address"

  self.type = data_types.Uint8.deserialize(buf)
  self.type.field_name = "type"

  self.index = data_types.Uint16.deserialize(buf)
  self.index.field_name = "index"

  self.opcode_len = data_types.Uint16.deserialize(buf)
  self.opcode_len.field_name = "opcode_len"

  self.opcode_val = data_types.Uint32.deserialize(buf)
  self.opcode_val.field_name = "opcode_val"

  self.packet_len = data_types.Uint16.deserialize(buf)
  self.packet_len.field_name = "packet_len"

  self.packet = {string.byte(str, buf:tell() + 1, #str)}

  setmetatable(self, { __index = messages.BluetoothMeshMessageRx })

  return self
end

--- TODO: Currently the packet (or actual data payload) in a BluetoothMeshMessageRx is not included as a field until we
--- create an applicable data type, so beware if using the following functions.

--- @function BluetoothMeshMessageRx:get_fields
--- A helper function used by common code to get all the component pieces of this message frame
--- @return table An array formatted table with each component field in the order their bytes should be serialized
function BluetoothMeshMessageRx:get_fields()
  return {
    self.address,
    self.type,
    self.index,
    self.opcode_len,
    self.opcode_val,
    self.packet_len
  }
end

--- @function BluetoothMeshMessageRx:get_length
--- A function to return the total length in bytes this frame uses when serialized
--- @return number the length in bytes of this frame
function BluetoothMeshMessageRx:get_length() end
BluetoothMeshMessageRx.get_length = utils.length_from_fields

--- @function BluetoothMeshMessageRx:serialize
--- A function for serializing this Bluetooth Mesh Message to bytes
--- @return string the bytes representing this message
function BluetoothMeshMessageRx:serialize() end
BluetoothMeshMessageRx.serialize = utils.serialize_from_fields

--- @function BluetoothMeshMessageRx:pretty_print
--- A function for printing in a human readable format
--- @return string A human readable representation of this message frame
function BluetoothMeshMessageRx:pretty_print() end
BluetoothMeshMessageRx.pretty_print = utils.print_from_fields


return messages
