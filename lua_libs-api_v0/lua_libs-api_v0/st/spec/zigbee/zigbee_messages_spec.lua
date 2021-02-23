local messages = require "st.zigbee.messages"
local zcl_global_commands = require "st.zigbee.zcl.global_commands"
local data_types = require "st.zigbee.data_types"
local FrameCtrl = require "st.zigbee.zcl.frame_ctrl"
local zcl = require "st.zigbee.zcl"
local buf_lib = require "st.buf"

local buf_from_str = function(str)
  return buf_lib.Reader(str)
end

describe("test address header", function()
  local dead_addr = "\xAD\xDE"
  local src_endpoint = "\x01"
  local zero_addr = "\x00\x00"
  local dest_endpoint = "\x01"
  local profile = "\x04\x01"
  local cluster = "\x06\x00"
  local frame_str = dead_addr .. src_endpoint .. zero_addr .. dest_endpoint .. profile .. cluster
  it("shold be parsable from byte data", function()
    local out_frame = messages.AddressHeader.deserialize(buf_from_str(frame_str))
    assert.are.equal(out_frame.src_addr.value, 0xDEAD, "source address should parse correctly")
    assert.are.equal(out_frame.src_endpoint.value, 0x01, "source endpoint should parse correctly")
    assert.are.equal(out_frame.dest_addr.value, 0x0000, "destination address should parse correctly")
    assert.are.equal(out_frame.dest_endpoint.value, 0x01, "destination endpoint should parse correctly")
    assert.are.equal(out_frame.profile.value, 0x0104, "profile should parse correctly")
    assert.are.equal(out_frame.cluster.value, 0x0006, "cluster should parse correctly")
    assert.are.equal(out_frame:get_length(), 10)
    assert.are.equal(out_frame:serialize(), frame_str)
  end)
  it("should be buildable from raw values", function()
    local out_frame = messages.AddressHeader(0x0000, 0x01, 0xDEAD, 0x01, 0x0104, 0x0006)
    assert.are.equal(out_frame.src_addr.value, 0x0000, "source address should have correct default")
    assert.are.equal(out_frame.src_endpoint.value, 0x01, "source endpoint should have correct default")
    assert.are.equal(out_frame.dest_addr.value, 0xDEAD, "destination address should be built correctly")
    assert.are.equal(out_frame.dest_endpoint.value, 0x01, "destination endpoint should be built correctly")
    assert.are.equal(out_frame.profile.value, 0x0104, "profile should have correct default")
    assert.are.equal(out_frame.cluster.value, 0x0006, "cluster should be built correctly")
    assert.are.equal(out_frame:get_length(), 10)
    assert.are.equal(out_frame:serialize(), zero_addr .. src_endpoint .. dead_addr .. dest_endpoint .. profile .. cluster)
  end)
end)

describe("test ZclHeader", function ()
  local frame_ctrl_non_mfg = "\x18"
  local frame_ctrl_mfg = "\x1C"
  local mfg_code = "\x0A\x11"
  local seqno = "\x00"
  local cmd = "\x0A"
  it("should parse from bytes non mfg specific", function ()
    local out_frame = zcl.ZclHeader.deserialize(buf_from_str(frame_ctrl_non_mfg .. seqno .. cmd))
    assert.are.equal(out_frame.frame_ctrl.value, 0x18, "frame ctrl should parse correctly")
    assert.are.equal(out_frame.seqno.value, 0x00, "seqno should parse correctly")
    assert.are.equal(out_frame.cmd.value, 0x0A, "command should parse correctly")
    assert.is_nil(out_frame.mfg_code, "mfg code should not be set")
    assert.are.equal(out_frame:get_length(), 3, "length should be correct")
    assert.are.equal(out_frame:serialize(), frame_ctrl_non_mfg .. seqno .. cmd, "should pack to the input")
  end)
  it("should parse from bytes mfg specific", function ()
    local out_frame = zcl.ZclHeader.deserialize(buf_from_str(frame_ctrl_mfg .. mfg_code .. seqno .. cmd))
    assert.are.equal(out_frame.frame_ctrl.value, 0x1C, "frame ctrl should parse correctly")
    assert.are.equal(out_frame.seqno.value, 0x00, "seqno should parse correctly")
    assert.are.equal(out_frame.cmd.value, 0x0A, "command should parse correctly")
    assert.are.equal(out_frame.mfg_code.value, 0x110A, "mfg code should parse correctly")
    assert.are.equal(out_frame:get_length(), 5, "length should be correct")
    assert.are.equal(out_frame:serialize(), frame_ctrl_mfg .. mfg_code .. seqno .. cmd, "should pack to the input")
  end)
  it("should be buildable as mfg specific", function ()
    local out_frame = zcl.ZclHeader({
      frame_ctrl = FrameCtrl(0x1C),
      mfg_code = data_types.Uint16(0x110A),
      cmd = data_types.Uint8(0x0A)
    })
    local out_frame = zcl.ZclHeader(out_frame)
    assert.are.equal(out_frame.frame_ctrl.value, 0x1C, "frame ctrl should build correctly")
    assert.are.equal(out_frame.seqno.value, 0x00, "seqno should have correct default")
    assert.are.equal(out_frame.cmd.value, 0x0A, "command should build correctly")
    assert.are.equal(out_frame.mfg_code.value, 0x110A, "mfg code should build correctly")
    assert.are.equal(out_frame:get_length(), 5, "length should be correct")
    assert.are.equal(out_frame:serialize(), frame_ctrl_mfg .. mfg_code .. seqno .. cmd, "should pack to the input")
  end)
  it("should be buildable as non mfg specific", function ()
    local out_frame = zcl.ZclHeader({
      frame_ctrl = FrameCtrl(0x18),
      cmd = data_types.Uint8(0x0A)
    })
    local out_frame = zcl.ZclHeader(out_frame)
    assert.are.equal(out_frame.frame_ctrl.value, 0x18, "frame ctrl should build correctly")
    assert.are.equal(out_frame.seqno.value, 0x00, "seqno should have correct default")
    assert.are.equal(out_frame.cmd.value, 0x0A, "command should build correctly")
    assert.is_nil(out_frame.mfg_code, "mfg code should not be set")
    assert.are.equal(out_frame:get_length(), 3, "length should be correct")
    assert.are.equal(out_frame:serialize(), frame_ctrl_non_mfg .. seqno .. cmd, "should pack to the input")
  end)
  it("should reject mfg specific build without mfg code", function()
    local errfn = function()
      return zcl.ZclHeader({
        frame_ctrl = FrameCtrl(0x1C),
        cmd = data_types.Uint8(0x0A)
      })
    end
    assert.has_error(errfn, {code = 1, msg = "ZCLHeader that is manufacturer specific requires manufacturer code"})
  end)
  it("should reject ZclHeader build without cmd", function()
    local errfn = function()
      return zcl.ZclHeader({
        frame_ctrl = data_types.Uint8(0x18)
      })
    end
    assert.has_error(errfn, {code = 1, msg = "ZCLHeader requires a command id"})
  end)
end)

describe("test zcl message rx", function()
  local type = "\x00"
  local address_header = "\xAD\xDE\x01\x00\x00\x01\x04\x01\x06\x00"
  local lqi = "\xFF"
  local rssi = "\x00"
  local body_length = "\x07\x00"
  local zcl_header = "\x18\x00\x0A"
  local report_attr_body = "\x00\x00\x10\x01"
  it("should parse from bytes", function()
    local out_frame = messages.ZigbeeMessageRx.deserialize(buf_from_str(type .. address_header .. lqi .. rssi .. body_length .. zcl_header .. report_attr_body))

    assert.are.equal(out_frame.address_header:serialize(), address_header, "address header should be correct")
    assert.are.equal(out_frame.body.zcl_header:serialize(), zcl_header, "zcl header should be correct")
    assert.are.equal(out_frame.body.zcl_body:serialize(), report_attr_body, "body should be correct")
    assert.are.equal(out_frame:get_length(), #type + #address_header + #lqi + #rssi + #body_length + #zcl_header + #report_attr_body, "length should be correct")
    assert.are.equal(out_frame:serialize(), type .. address_header .. lqi .. rssi .. body_length .. zcl_header .. report_attr_body)
  end)
end)
