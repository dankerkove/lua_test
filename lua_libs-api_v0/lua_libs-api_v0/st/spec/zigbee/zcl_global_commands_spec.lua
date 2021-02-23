local zcl_cmds = require "st.zigbee.zcl.global_commands"
local data_types = require "st.zigbee.data_types"
local buf_lib = require "st.buf"

local buf_from_str = function(str)
  return buf_lib.Reader(str)
end

-- TODO: replace with status constants
local success_status = "\x00"
local unsupported_attr_status = "\x86"
local attr_id_1 = string.pack("<I2", 0x0001)
local attr_id_2 = string.pack("<I2", 0x0002)
local uint16_data_type = string.pack("<I1", data_types.Uint16.ID)
local uint16_data_27 = string.pack("<I2", 27)
local int16_data_type = string.pack("<I1", data_types.Int16.ID)
local int16_data_neg_2 = string.pack("<i2", -2)
local direction_0 = "\x00"
local direction_1 = "\x01"


describe("test read attribute response message", function()
  it("should parse a single successful attribute record", function()
    local frame = attr_id_1 .. success_status .. uint16_data_type .. uint16_data_27
    local read_attr_resp = zcl_cmds.ReadAttributeResponse.deserialize(buf_from_str(frame))
    assert.are.equal(#read_attr_resp.attr_records, 1, "there should be one entry")
    assert.are.equal(read_attr_resp.attr_records[1].status.value, 0, "the status should be successful")
    assert.are.equal(read_attr_resp.attr_records[1].data_type.value, data_types.Uint16.ID, "the entry should have the correct data type")
    assert.are.equal(read_attr_resp.attr_records[1].data.value, 27, "the data value should parse correctly")
    assert.are.equal(read_attr_resp:serialize(), frame, "the message should pack to the input")
  end)
  it("should handle a single unsuccessful read record", function()
    local frame = attr_id_1 .. unsupported_attr_status
    local read_attr_resp = zcl_cmds.ReadAttributeResponse.deserialize(buf_from_str(frame))
    assert.are.equal(#read_attr_resp.attr_records, 1, "there should be one entry")
    assert.are.equal(read_attr_resp.attr_records[1].status.value, 0x86, "the status should be unsuccessful")
    assert.are.equal(read_attr_resp.attr_records[1].data_type, nil, "the entry should have no data type")
    assert.are.equal(read_attr_resp.attr_records[1].data, nil, "the entry should have no data")
    assert.are.equal(read_attr_resp:serialize(), frame, "the message should pack to the input")
  end)
  it("should handle multiple successful attributes", function()
    local frame = attr_id_1 .. success_status .. uint16_data_type .. uint16_data_27 .. attr_id_2 .. success_status .. int16_data_type .. int16_data_neg_2
    local read_attr_resp = zcl_cmds.ReadAttributeResponse.deserialize(buf_from_str(frame))
    assert.are.equal(#read_attr_resp.attr_records, 2, "there should be two entries")
    assert.are.equal(read_attr_resp.attr_records[1].status.value, 0, "the first status should be successful")
    assert.are.equal(read_attr_resp.attr_records[1].data_type.value, data_types.Uint16.ID, "the first entry should have the correct data type")
    assert.are.equal(read_attr_resp.attr_records[1].data.value, 27, "the first entry data value should parse correctly")
    assert.are.equal(read_attr_resp.attr_records[2].status.value, 0, "the second status should be successful")
    assert.are.equal(read_attr_resp.attr_records[2].data_type.value, data_types.Int16.ID, "the second entry should have the correct data type")
    assert.are.equal(read_attr_resp.attr_records[2].data.value, -2, "the second entry data value should parse correctly")
    assert.are.equal(read_attr_resp:serialize(), frame, "the message should pack to the input")
  end)
  it("should handle multiple mixed status attributes", function()
    local frame = attr_id_1 .. unsupported_attr_status .. attr_id_2 .. success_status .. int16_data_type .. int16_data_neg_2
    local read_attr_resp = zcl_cmds.ReadAttributeResponse.deserialize(buf_from_str(frame))
    assert.are.equal(#read_attr_resp.attr_records, 2, "there should be two entries")
    assert.are.equal(read_attr_resp.attr_records[1].status.value, 0x86, "the first status should be unsuccessful")
    assert.are.equal(read_attr_resp.attr_records[1].data_type, nil, "the first entry should have no data type")
    assert.are.equal(read_attr_resp.attr_records[1].data, nil, "the first entry should have no data")
    assert.are.equal(read_attr_resp.attr_records[2].status.value, 0, "the second status should be successful")
    assert.are.equal(read_attr_resp.attr_records[2].data_type.value, data_types.Int16.ID, "the second entry should have the correct data type")
    assert.are.equal(read_attr_resp.attr_records[2].data.value, -2, "the second entry data value should parse correctly")
    assert.are.equal(read_attr_resp:serialize(), frame, "the message should pack to the input")
  end)
  it("should be correctly parsed from command id", function()
    local frame = attr_id_1 .. unsupported_attr_status .. attr_id_2 .. success_status .. int16_data_type .. int16_data_neg_2
    local read_attr_resp = zcl_cmds.parse_global_zcl_command(0x01, buf_from_str(frame))
    assert.are.equal(#read_attr_resp.attr_records, 2, "there should be two entries")
    assert.are.equal(read_attr_resp.attr_records[1].status.value, 0x86, "the first status should be unsuccessful")
    assert.are.equal(read_attr_resp.attr_records[1].data_type, nil, "the first entry should have no data type")
    assert.are.equal(read_attr_resp.attr_records[1].data, nil, "the first entry should have no data")
    assert.are.equal(read_attr_resp.attr_records[2].status.value, 0, "the second status should be successful")
    assert.are.equal(read_attr_resp.attr_records[2].data_type.value, data_types.Int16.ID, "the second entry should have the correct data type")
    assert.are.equal(read_attr_resp.attr_records[2].data.value, -2, "the second entry data value should parse correctly")
    assert.are.equal(read_attr_resp:serialize(), frame, "the message should pack to the input")
  end)
end)

describe("test report attribute response message", function()
  it("should parse a single attribute record", function()
    local frame = attr_id_1 .. uint16_data_type .. uint16_data_27
    local report_attr = zcl_cmds.ReportAttribute.deserialize(buf_from_str(frame))
    assert.are.equal(#report_attr.attr_records, 1, "there should be one entry")
    assert.are.equal(report_attr.attr_records[1].data_type.value, data_types.Uint16.ID, "the entry should have the correct data type")
    assert.are.equal(report_attr.attr_records[1].data.value, 27, "the data value should parse correctly")
    assert.are.equal(report_attr:serialize(), frame, "the message should pack to the input")
  end)
  it("should handle multiple attributes", function()
    local frame = attr_id_1 .. uint16_data_type .. uint16_data_27 .. attr_id_2 .. int16_data_type .. int16_data_neg_2
    local report_attr = zcl_cmds.ReportAttribute.deserialize(buf_from_str(frame))
    assert.are.equal(#report_attr.attr_records, 2, "there should be two entries")
    assert.are.equal(report_attr.attr_records[1].data_type.value, data_types.Uint16.ID, "the first entry should have the correct data type")
    assert.are.equal(report_attr.attr_records[1].data.value, 27, "the first entry data value should parse correctly")
    assert.are.equal(report_attr.attr_records[2].data_type.value, data_types.Int16.ID, "the second entry should have the correct data type")
    assert.are.equal(report_attr.attr_records[2].data.value, -2, "the second entry data value should parse correctly")
    assert.are.equal(report_attr:serialize(), frame, "the message should pack to the input")
  end)
  it("should be correctly parsed from command id", function()
    local frame = attr_id_1 .. uint16_data_type .. uint16_data_27 .. attr_id_2 .. int16_data_type .. int16_data_neg_2
    local report_attr = zcl_cmds.parse_global_zcl_command(0x0A, buf_from_str(frame))
    assert.are.equal(#report_attr.attr_records, 2, "there should be two entries")
    assert.are.equal(report_attr.attr_records[1].data_type.value, data_types.Uint16.ID, "the first entry should have the correct data type")
    assert.are.equal(report_attr.attr_records[1].data.value, 27, "the first entry data value should parse correctly")
    assert.are.equal(report_attr.attr_records[2].data_type.value, data_types.Int16.ID, "the second entry should have the correct data type")
    assert.are.equal(report_attr.attr_records[2].data.value, -2, "the second entry data value should parse correctly")
    assert.are.equal(report_attr:serialize(), frame, "the message should pack to the input")
  end)
end)

describe("test read attribute message", function()
  it("should parse a single attribute id", function()
    local frame = attr_id_1
    local read_attr = zcl_cmds.ReadAttribute.deserialize(buf_from_str(frame))
    assert.are.equal(#read_attr.attr_ids, 1, "there should be one entry")
    assert.are.equal(read_attr.attr_ids[1].value, 0x0001, "the attr id should parse correctly")
    assert.are.equal(read_attr:serialize(), frame, "the message should pack to the input")
  end)
  it("should handle multiple attribute ids", function()
    local frame = attr_id_1 .. attr_id_2
    local read_attr = zcl_cmds.ReadAttribute.deserialize(buf_from_str(frame))
    assert.are.equal(#read_attr.attr_ids, 2, "there should be two entries")
    assert.are.equal(read_attr.attr_ids[1].value, 0x0001, "the first attr id should parse correctly")
    assert.are.equal(read_attr.attr_ids[2].value, 0x0002, "the second attr id should parse correctly")
    assert.are.equal(read_attr:serialize(), frame, "the message should pack to the input")
  end)
  it("should be correctly parsed from command id", function()
    local frame = attr_id_1 .. attr_id_2
    local read_attr = zcl_cmds.parse_global_zcl_command(0x00, buf_from_str(frame))
    assert.are.equal(#read_attr.attr_ids, 2, "there should be two entries")
    assert.are.equal(read_attr.attr_ids[1].value, 0x0001, "the first attr id should parse correctly")
    assert.are.equal(read_attr.attr_ids[2].value, 0x0002, "the second attr id should parse correctly")
    assert.are.equal(read_attr:serialize(), frame, "the message should pack to the input")
  end)
  it("should be buildable from attr id list", function()
    local read_attr = zcl_cmds.ReadAttribute({data_types.AttributeId(0x0001), data_types.AttributeId(0x0002)})
    assert.are.equal(#read_attr.attr_ids, 2, "there should be two entries")
    assert.are.equal(read_attr.attr_ids[1].value, 0x0001, "the first attr id should be set correctly")
    assert.are.equal(read_attr.attr_ids[2].value, 0x0002, "the second attr id should be set correctly")
    assert.are.equal(read_attr:serialize(), attr_id_1 .. attr_id_2, "the message should pack to the correct output")
  end)
  it("should reject an incorrect attr id list", function()
    local errfn = function()
      return zcl_cmds.ReadAttribute({data_types.AttributeId(0x0001), "asdfasdf"})
    end
    assert.has_error(errfn,  "Error creating AttributeId: ...gine/lua_libs/st/zigbee/data_types/base_defs/UintABC.lua:44: AttributeId value must be an integer")
  end)
end)

describe("test write attribute message", function()
  it("should parse a single attribute record", function()
    local frame = attr_id_1 .. uint16_data_type .. uint16_data_27
    local write_attr = zcl_cmds.WriteAttribute.deserialize(buf_from_str(frame))
    assert.are.equal(#write_attr.attr_records, 1, "there should be one entry")
    assert.are.equal(write_attr.attr_records[1].attr_id.value, 0x0001, "the attr id should parse correctly")
    assert.are.equal(write_attr.attr_records[1].data_type.value, data_types.Uint16.ID, "the data type should parse correctly")
    assert.are.equal(write_attr.attr_records[1].data.value, 27, "the attr data should parse correctly")
    assert.are.equal(write_attr:serialize(), frame, "the message should pack to the input")
  end)
  it("should handle multiple attribute ids", function()
    local frame = attr_id_1 .. uint16_data_type .. uint16_data_27 .. attr_id_2 .. int16_data_type .. int16_data_neg_2
    local write_attr = zcl_cmds.WriteAttribute.deserialize(buf_from_str(frame))
    assert.are.equal(#write_attr.attr_records, 2, "there should be two entries")
    assert.are.equal(write_attr.attr_records[1].data_type.value, data_types.Uint16.ID, "the first entry should have the correct data type")
    assert.are.equal(write_attr.attr_records[1].data.value, 27, "the first entry data value should parse correctly")
    assert.are.equal(write_attr.attr_records[2].data_type.value, data_types.Int16.ID, "the second entry should have the correct data type")
    assert.are.equal(write_attr.attr_records[2].data.value, -2, "the second entry data value should parse correctly")
    assert.are.equal(write_attr:serialize(), frame, "the message should pack to the input")
  end)
  it("should be correctly parsed from command id", function()
    local frame = attr_id_1 .. uint16_data_type .. uint16_data_27 .. attr_id_2 .. int16_data_type .. int16_data_neg_2
    local write_attr = zcl_cmds.parse_global_zcl_command(0x02, buf_from_str(frame))
    assert.are.equal(#write_attr.attr_records, 2, "there should be two entries")
    assert.are.equal(write_attr.attr_records[1].data_type.value, data_types.Uint16.ID, "the first entry should have the correct data type")
    assert.are.equal(write_attr.attr_records[1].data.value, 27, "the first entry data value should parse correctly")
    assert.are.equal(write_attr.attr_records[2].data_type.value, data_types.Int16.ID, "the second entry should have the correct data type")
    assert.are.equal(write_attr.attr_records[2].data.value, -2, "the second entry data value should parse correctly")
    assert.are.equal(write_attr:serialize(), frame, "the message should pack to the input")
  end)
  it("should be buildable from attr record list", function()
    local attr_record_1 = zcl_cmds.WriteAttribute.AttributeRecord(data_types.AttributeId(0x0001), data_types.ZigbeeDataType(data_types.Uint16.ID), data_types.Uint16(27))
    local attr_record_2 = zcl_cmds.WriteAttribute.AttributeRecord(data_types.AttributeId(0x0002), data_types.ZigbeeDataType(data_types.Int16.ID), data_types.Int16(-2))
    local write_attr = zcl_cmds.WriteAttribute({attr_record_1, attr_record_2})
    assert.are.equal(#write_attr.attr_records, 2, "there should be two entries")
    assert.are.equal(write_attr.attr_records[1].data_type.value, data_types.Uint16.ID, "the first entry should have the correct data type")
    assert.are.equal(write_attr.attr_records[1].data.value, 27, "the first entry data value should parse correctly")
    assert.are.equal(write_attr.attr_records[2].data_type.value, data_types.Int16.ID, "the second entry should have the correct data type")
    assert.are.equal(write_attr.attr_records[2].data.value, -2, "the second entry data value should parse correctly")
    assert.are.equal(write_attr:serialize(), attr_id_1 .. uint16_data_type .. uint16_data_27 .. attr_id_2 .. int16_data_type .. int16_data_neg_2, "the message should pack to the input")
  end)
  it("should reject an incorrect attr record creation", function()
    local errfn = function()
      return zcl_cmds.WriteAttribute.AttributeRecord(data_types.AttributeId(0x0001), data_types.ZigbeeDataType(data_types.Uint16.ID), data_types.Int16(27))
    end
    assert.has_error(errfn, "Expecting Uint16 (0x21) for \"data\" received Int16: 27")
    errfn = function()
      return zcl_cmds.WriteAttribute.AttributeRecord("asdf", data_types.ZigbeeDataType(data_types.Uint16.ID), data_types.Int16(27))
    end
    assert.has_error(errfn, "Error creating attr_id: ...gine/lua_libs/st/zigbee/data_types/base_defs/UintABC.lua:44: AttributeId value must be an integer")
  end)
  it("should reject an incorrect attr record list", function()
    local errfn = function()
      local attr_record_1 = zcl_cmds.WriteAttribute.AttributeRecord(data_types.AttributeId(0x0001), data_types.ZigbeeDataType(data_types.Uint16.ID), data_types.Uint16(27))
      local attr_record_2 = zcl_cmds.WriteAttribute.AttributeRecord(data_types.AttributeId(0x0001), data_types.ZigbeeDataType(data_types.Uint16.ID), data_types.Uint16(27))
      attr_record_2.data = nil
      return zcl_cmds.WriteAttribute({attr_record_1, attr_record_2})
    end
    assert.has_error(errfn, "Write attribute records must be valid")
  end)
end)

describe("test write attribute response message", function()
  it("should parse a global status record", function()
    local frame = success_status
    local write_attr_resp = zcl_cmds.WriteAttributeResponse.deserialize(buf_from_str(frame))
    assert.are.equal(write_attr_resp.global_status.value, 0x00, "the global status should be set")
    assert.is_nil(write_attr_resp.attr_records, "there should be no attr records")
    assert.are.equal(write_attr_resp:serialize(), frame, "the message should pack to the input")
  end)
  it("should handle single attribute status", function()
    local frame = success_status .. attr_id_1
    local write_attr_resp = zcl_cmds.WriteAttributeResponse.deserialize(buf_from_str(frame))
    assert.are.equal(#write_attr_resp.attr_records, 1, "there should be one entries")
    assert.are.equal(write_attr_resp.attr_records[1].status.value, 0x00, "the entry should have the correct status")
    assert.are.equal(write_attr_resp.attr_records[1].attr_id.value, 0x0001, "the entry attr id should parse correctly")
    assert.are.equal(write_attr_resp:serialize(), frame, "the message should pack to the input")
  end)
  it("should handle multiple attribute records", function()
    local frame = success_status .. attr_id_1 .. unsupported_attr_status .. attr_id_2
    local write_attr_resp = zcl_cmds.WriteAttributeResponse.deserialize(buf_from_str(frame))
    assert.are.equal(#write_attr_resp.attr_records, 2, "there should be two entries")
    assert.are.equal(write_attr_resp.attr_records[1].status.value, 0x00, "the first entry should have the correct status")
    assert.are.equal(write_attr_resp.attr_records[1].attr_id.value, 0x0001, "the first entry attr id should parse correctly")
    assert.are.equal(write_attr_resp.attr_records[2].status.value, 0x86, "the second entry should have the correct status")
    assert.are.equal(write_attr_resp.attr_records[2].attr_id.value, 0x0002, "the second entry data value should parse correctly")
    assert.are.equal(write_attr_resp:serialize(), frame, "the message should pack to the input")
  end)
  it("should be correctly parsed from command id", function()
    local frame = success_status .. attr_id_1 .. unsupported_attr_status .. attr_id_2
    local write_attr_resp = zcl_cmds.parse_global_zcl_command(0x04, buf_from_str(frame))
    assert.are.equal(#write_attr_resp.attr_records, 2, "there should be two entries")
    assert.are.equal(write_attr_resp.attr_records[1].status.value, 0x00, "the first entry should have the correct status")
    assert.are.equal(write_attr_resp.attr_records[1].attr_id.value, 0x0001, "the first entry attr id should parse correctly")
    assert.are.equal(write_attr_resp.attr_records[2].status.value, 0x86, "the second entry should have the correct status")
    assert.are.equal(write_attr_resp.attr_records[2].attr_id.value, 0x0002, "the second entry data value should parse correctly")
    assert.are.equal(write_attr_resp:serialize(), frame, "the message should pack to the input")
  end)
end)

describe("test configure reporting command", function()
  local min_rep_int_32 = "\x20\x00"
  local max_rep_int_100 = "\x64\x00"
  local timeout_100 = "\x64\x00"
  local Ieee_addr_data_type = "\xF0"
  local Ieee_data_value = "\x08\x07\x06\x05\x04\x03\x02\x01"
  it("should parse a direction 0x00 non discrete config", function()
    local config_record_1 = direction_0 .. attr_id_1 .. uint16_data_type .. min_rep_int_32 .. max_rep_int_100 .. uint16_data_27
    local frame = config_record_1
    local config_report = zcl_cmds.ConfigureReporting.deserialize(buf_from_str(frame))
    assert.are.equal(#config_report.attr_config_records, 1, "there should be one entry")
    local rec = config_report.attr_config_records[1]
    assert.are.equal(rec.direction.value, 0, "the direction should be parsed")
    assert.are.equal(rec.attr_id.value, 0x0001, "the attr id should be parsed")
    assert.are.equal(rec.data_type.value, data_types.Uint16.ID, "the data type should be parsed")
    assert.are.equal(rec.minimum_reporting_interval.value, 32, "the minimum reporting interval should be parsed")
    assert.are.equal(rec.maximum_reporting_interval.value, 100, "the maximum reporting interval should be parsed")
    assert.are.equal(rec.reportable_change.value, 27, "the reportable change should be parsed")
    assert.is_nil(rec.timeout, "the timeout should be nil")
    assert.are.equal(config_report:serialize(), frame, "the message should pack to the input")
  end)
  it("should parse a direction 0x00 discrete config", function()
    local config_record_1 = direction_0 .. attr_id_1 .. Ieee_addr_data_type .. min_rep_int_32 .. max_rep_int_100
    local frame = config_record_1
    local config_report = zcl_cmds.ConfigureReporting.deserialize(buf_from_str(frame))
    assert.are.equal(#config_report.attr_config_records, 1, "there should be one entry")
    local rec = config_report.attr_config_records[1]
    assert.are.equal(rec.direction.value, 0, "the direction should be parsed")
    assert.are.equal(rec.attr_id.value, 0x0001, "the attr id should be parsed")
    assert.are.equal(rec.data_type.value, data_types.IeeeAddress.ID, "the data type should be parsed")
    assert.are.equal(rec.minimum_reporting_interval.value, 32, "the minimum reporting interval should be parsed")
    assert.are.equal(rec.maximum_reporting_interval.value, 100, "the maximum reporting interval should be parsed")
    assert.is_nil(rec.reportable_change, "the reportable change should be nil for discrete types")
    assert.is_nil(rec.timeout, "the timeout should be nil")
    assert.are.equal(config_report:serialize(), frame, "the message should pack to the input")
  end)
  it("should parse a direction 0x01 config", function()
    local config_record_1 = direction_1 .. attr_id_1 .. timeout_100
    local frame = config_record_1
    local config_report = zcl_cmds.ConfigureReporting.deserialize(buf_from_str(frame))
    assert.are.equal(#config_report.attr_config_records, 1, "there should be one entry")
    local rec = config_report.attr_config_records[1]
    assert.are.equal(rec.direction.value, 0x01, "the direction should be parsed")
    assert.are.equal(rec.attr_id.value, 0x0001, "the attr id should be parsed")
    assert.is_nil(rec.data_type, "the data type should be nil")
    assert.is_nil(rec.minimum_reporting_interval, "the minimum reporting interval should be nil")
    assert.is_nil(rec.maximum_reporting_interval, "the maximum reporting interval should be nil")
    assert.is_nil(rec.reportable_change, "the reportable change should be nil")
    assert.are.equal(rec.timeout.value, 100, "the timeout should be parsed correctly")
    assert.are.equal(config_report:serialize(), frame, "the message should pack to the input")
  end)
  it("should parse multiple records", function()
    local config_record_1 = direction_0 .. attr_id_1 .. Ieee_addr_data_type .. min_rep_int_32 .. max_rep_int_100
    local config_record_2 = direction_0 .. attr_id_1 .. uint16_data_type .. min_rep_int_32 .. max_rep_int_100 .. uint16_data_27
    local frame = config_record_1 .. config_record_2
    local config_report = zcl_cmds.ConfigureReporting.deserialize(buf_from_str(frame))
    assert.are.equal(#config_report.attr_config_records, 2, "there should be two entries")
    local rec = config_report.attr_config_records[1]
    assert.are.equal(rec.direction.value, 0, "the direction should be parsed")
    assert.are.equal(rec.attr_id.value, 0x0001, "the attr id should be parsed")
    assert.are.equal(rec.data_type.value, data_types.IeeeAddress.ID, "the data type should be parsed")
    assert.are.equal(rec.minimum_reporting_interval.value, 32, "the minimum reporting interval should be parsed")
    assert.are.equal(rec.maximum_reporting_interval.value, 100, "the maximum reporting interval should be parsed")
    assert.is_nil(rec.timeout, "the timeout should be nil")
    assert.is_nil(rec.reportable_change, "the reportable change should be nil for discrete types")
    rec = config_report.attr_config_records[2]
    assert.are.equal(rec.direction.value, 0, "the direction should be parsed")
    assert.are.equal(rec.attr_id.value, 0x0001, "the attr id should be parsed")
    assert.are.equal(rec.data_type.value, data_types.Uint16.ID, "the data type should be parsed")
    assert.are.equal(rec.minimum_reporting_interval.value, 32, "the minimum reporting interval should be parsed")
    assert.are.equal(rec.maximum_reporting_interval.value, 100, "the maximum reporting interval should be parsed")
    assert.are.equal(rec.reportable_change.value, 27, "the reportable change should be parsed")
    assert.is_nil(rec.timeout, "the timeout should be nil")
    assert.are.equal(config_report:serialize(), frame, "the message should pack to the input")
  end)
  it("should parse from command id", function()
    local config_record_1 = direction_0 .. attr_id_1 .. Ieee_addr_data_type .. min_rep_int_32 .. max_rep_int_100
    local config_record_2 = direction_0 .. attr_id_1 .. uint16_data_type .. min_rep_int_32 .. max_rep_int_100 .. uint16_data_27
    local frame = config_record_1 .. config_record_2
    local config_report = zcl_cmds.parse_global_zcl_command(0x06, buf_from_str(frame))
    assert.are.equal(#config_report.attr_config_records, 2, "there should be two entries")
    local rec = config_report.attr_config_records[1]
    assert.are.equal(rec.direction.value, 0, "the direction should be parsed")
    assert.are.equal(rec.attr_id.value, 0x0001, "the attr id should be parsed")
    assert.are.equal(rec.data_type.value, data_types.IeeeAddress.ID, "the data type should be parsed")
    assert.are.equal(rec.minimum_reporting_interval.value, 32, "the minimum reporting interval should be parsed")
    assert.are.equal(rec.maximum_reporting_interval.value, 100, "the maximum reporting interval should be parsed")
    assert.is_nil(rec.timeout, "the timeout should be nil")
    assert.is_nil(rec.reportable_change, "the reportable change should be nil for discrete types")
    rec = config_report.attr_config_records[2]
    assert.are.equal(rec.direction.value, 0, "the direction should be parsed")
    assert.are.equal(rec.attr_id.value, 0x0001, "the attr id should be parsed")
    assert.are.equal(rec.data_type.value, data_types.Uint16.ID, "the data type should be parsed")
    assert.are.equal(rec.minimum_reporting_interval.value, 32, "the minimum reporting interval should be parsed")
    assert.are.equal(rec.maximum_reporting_interval.value, 100, "the maximum reporting interval should be parsed")
    assert.are.equal(rec.reportable_change.value, 27, "the reportable change should be parsed")
    assert.is_nil(rec.timeout, "the timeout should be nil")
    assert.are.equal(config_report:serialize(), frame, "the message should pack to the input")
  end)
  local valid_discrete_config = {
    direction = data_types.Uint8(0x00),
    attr_id = data_types.AttributeId(0x0001),
    data_type = data_types.ZigbeeDataType(data_types.Uint16.ID),
    minimum_reporting_interval = data_types.Uint16(32),
    maximum_reporting_interval = data_types.Uint16(100),
    reportable_change = data_types.Uint16(27)
  }
  local shallow_copy = function(t)
    local out = {}
    for k,v in pairs(t) do
      out[k] = v
    end
    return out
  end
  it("should have a buildable direction 0x00 discrete config",function()
    local attr_config = zcl_cmds.ConfigureReporting.AttributeReportingConfiguration(valid_discrete_config)
    assert.are.equal(attr_config.direction.value, 0, "direction should be correct")
    assert.are.equal(attr_config.attr_id.value, 0x0001, "attr id should be correct")
    assert.are.equal(attr_config.data_type.value, data_types.Uint16.ID, "data type should be correct")
    assert.are.equal(attr_config.minimum_reporting_interval.value, 32, "min rep int should be correct")
    assert.are.equal(attr_config.maximum_reporting_interval.value, 100, "max rep int should be correct")
    assert.are.equal(attr_config.reportable_change.value, 27, "reportable change should be correct")
    assert.are.equal(attr_config:serialize(), direction_0 .. attr_id_1 .. uint16_data_type .. min_rep_int_32 .. max_rep_int_100 .. uint16_data_27)
  end)
  it("should reject invalid direction 0x00 discrete config",function()
    local invalid = shallow_copy(valid_discrete_config)
    invalid.reportable_change = nil
    local errfn = function()
      return zcl_cmds.ConfigureReporting.AttributeReportingConfiguration(invalid)
    end
    assert.has_error(errfn, "Error creating reportable_change: ...gine/lua_libs/st/zigbee/data_types/base_defs/UintABC.lua:44: Uint16 value must be an integer")

    invalid = shallow_copy(valid_discrete_config)
    invalid.reportable_change = data_types.Data8.deserialize(buf_from_str("\x00"))
    errfn = function()
      return zcl_cmds.ConfigureReporting.AttributeReportingConfiguration(invalid)
    end
    assert.has_error(errfn, "Expecting Uint16 (0x21) for \"reportable_change\" received Data8: 00")

    invalid = shallow_copy(valid_discrete_config)
    invalid.data_type = nil
    errfn = function()
      return zcl_cmds.ConfigureReporting.AttributeReportingConfiguration(invalid)
    end
    assert.has_error(errfn, "Error creating data_type: ...-engine/lua_libs/st/zigbee/data_types/ZigbeeDataType.lua:19: bad argument #3 to 'format' (number expected, got nil)")

    invalid = shallow_copy(valid_discrete_config)
    invalid.minimum_reporting_interval = nil
    errfn = function()
      return zcl_cmds.ConfigureReporting.AttributeReportingConfiguration(invalid)
    end
    assert.has_error(errfn, "Error creating minimum_reporting_interval: ...gine/lua_libs/st/zigbee/data_types/base_defs/UintABC.lua:44: Uint16 value must be an integer")

    invalid = shallow_copy(valid_discrete_config)
    invalid.maximum_reporting_interval = nil
    errfn = function()
      return zcl_cmds.ConfigureReporting.AttributeReportingConfiguration(invalid)
    end
    assert.has_error(errfn, "Error creating minimum_reporting_interval: ...gine/lua_libs/st/zigbee/data_types/base_defs/UintABC.lua:44: Uint16 value must be an integer")
  end)
  local valid_non_discrete_config = {
    direction = data_types.Uint8(0x00),
    attr_id = data_types.AttributeId(0x0001),
    data_type = data_types.ZigbeeDataType(data_types.IeeeAddress.ID),
    minimum_reporting_interval = data_types.Uint16(32),
    maximum_reporting_interval = data_types.Uint16(100)
  }
  it("should have a buildable direction 0x00 non discrete config",function()
    local attr_config = zcl_cmds.ConfigureReporting.AttributeReportingConfiguration(valid_non_discrete_config)
    assert.are.equal(attr_config.direction.value, 0, "direction should be correct")
    assert.are.equal(attr_config.attr_id.value, 0x0001, "attr id should be correct")
    assert.are.equal(attr_config.data_type.value, data_types.IeeeAddress.ID, "data type should be correct")
    assert.are.equal(attr_config.minimum_reporting_interval.value, 32, "min rep int should be correct")
    assert.are.equal(attr_config.maximum_reporting_interval.value, 100, "max rep int should be correct")
    assert.are.equal(attr_config:serialize(), direction_0 .. attr_id_1 .. Ieee_addr_data_type .. min_rep_int_32 .. max_rep_int_100)
  end)
  it("should reject invalid direction 0x00 non-discrete config",function()
    local invalid = shallow_copy(valid_non_discrete_config)
    invalid.data_type = nil
    local errfn = function()
      return zcl_cmds.ConfigureReporting.AttributeReportingConfiguration(invalid)
    end
    assert.has_error(errfn, "Error creating data_type: ...-engine/lua_libs/st/zigbee/data_types/ZigbeeDataType.lua:19: bad argument #3 to 'format' (number expected, got nil)")

    invalid = shallow_copy(valid_non_discrete_config)
    invalid.minimum_reporting_interval = nil
    errfn = function()
      return zcl_cmds.ConfigureReporting.AttributeReportingConfiguration(invalid)
    end
    assert.has_error(errfn, "Error creating minimum_reporting_interval: ...gine/lua_libs/st/zigbee/data_types/base_defs/UintABC.lua:44: Uint16 value must be an integer")

    invalid = shallow_copy(valid_non_discrete_config)
    invalid.maximum_reporting_interval = nil
    errfn = function()
      return zcl_cmds.ConfigureReporting.AttributeReportingConfiguration(invalid)
    end
    assert.has_error(errfn, "Error creating minimum_reporting_interval: ...gine/lua_libs/st/zigbee/data_types/base_defs/UintABC.lua:44: Uint16 value must be an integer")
  end)

  local valid_direction_1_config = {
    direction = data_types.Uint8(0x01),
    attr_id = data_types.AttributeId(0x0001),
    timeout = data_types.Uint16(100)
  }
  it("should have a buildable direction 0x01 config", function()
    local attr_config = zcl_cmds.ConfigureReporting.AttributeReportingConfiguration(valid_direction_1_config)
    assert.are.equal(attr_config.direction.value, 0x01, "direction should be correct")
    assert.are.equal(attr_config.attr_id.value, 0x0001, "attr id should be correct")
    assert.is_nil(attr_config.data_type,  "data type should be nil")
    assert.is_nil(attr_config.minimum_reporting_interval, "min rep int should be nil")
    assert.is_nil(attr_config.maximum_reporting_interval,"max rep int should be nil")
    assert.are.equal(attr_config.timeout.value, 100, "timeout should be correct")
    assert.are.equal(attr_config:serialize(), direction_1 .. attr_id_1 .. timeout_100)
  end)
  it("should reject invalid direction 0x01 config",function()
    local invalid = shallow_copy(valid_direction_1_config)
    invalid.timeout = nil
    local errfn = function()
      return zcl_cmds.ConfigureReporting.AttributeReportingConfiguration(invalid)
    end
    assert.has_error(errfn, "Error creating timeout: ...gine/lua_libs/st/zigbee/data_types/base_defs/UintABC.lua:44: Uint16 value must be an integer")
  end)
  it("should have a buildable config command", function()
    local attr_config_1 = zcl_cmds.ConfigureReporting.AttributeReportingConfiguration(valid_direction_1_config)
    local attr_config_2 = zcl_cmds.ConfigureReporting.AttributeReportingConfiguration(valid_discrete_config)
    local config_rep = zcl_cmds.ConfigureReporting({attr_config_1, attr_config_2})
    assert.are.equal(#config_rep.attr_config_records, 2, "there should be 2 entries")
    local attr_config = config_rep.attr_config_records[1]
    assert.are.equal(attr_config.direction.value, 0x01, "direction should be correct")
    assert.are.equal(attr_config.attr_id.value, 0x0001, "attr id should be correct")
    assert.is_nil(attr_config.data_type,  "data type should be nil")
    assert.is_nil(attr_config.minimum_reporting_interval, "min rep int should be nil")
    assert.is_nil(attr_config.maximum_reporting_interval,"max rep int should be nil")
    assert.are.equal(attr_config.timeout.value, 100, "timeout should be correct")
    assert.are.equal(attr_config:serialize(), direction_1 .. attr_id_1 .. timeout_100)
    attr_config = config_rep.attr_config_records[2]
    assert.are.equal(attr_config.direction.value, 0, "direction should be correct")
    assert.are.equal(attr_config.attr_id.value, 0x0001, "attr id should be correct")
    assert.are.equal(attr_config.data_type.value, data_types.Uint16.ID, "data type should be correct")
    assert.are.equal(attr_config.minimum_reporting_interval.value, 32, "min rep int should be correct")
    assert.are.equal(attr_config.maximum_reporting_interval.value, 100, "max rep int should be correct")
    assert.are.equal(attr_config.reportable_change.value, 27, "reportable change should be correct")
    assert.are.equal(attr_config:serialize(), direction_0 .. attr_id_1 .. uint16_data_type .. min_rep_int_32 .. max_rep_int_100 .. uint16_data_27)
  end)
end)

describe("test config reporting response message", function()
  it("should parse a global status record", function()
    local frame = success_status
    local config_rep_resp = zcl_cmds.ConfigureReportingResponse.deserialize(buf_from_str(frame))
    assert.are.equal(config_rep_resp.global_status.value, 0x00, "the global status should be set")
    assert.is_nil(config_rep_resp.config_records, "there should be no attr records")
    assert.are.equal(config_rep_resp:serialize(), frame, "the message should pack to the input")
  end)
  it("should handle single attribute status", function()
    local frame = success_status .. direction_0 .. attr_id_1
    local config_rep_resp = zcl_cmds.ConfigureReportingResponse.deserialize(buf_from_str(frame))
    assert.are.equal(#config_rep_resp.config_records, 1, "there should be one entries")
    assert.are.equal(config_rep_resp.config_records[1].status.value, 0x00, "the entry should have the correct status")
    assert.are.equal(config_rep_resp.config_records[1].direction.value, 0x00, "the entry should have the correct direction")
    assert.are.equal(config_rep_resp.config_records[1].attr_id.value, 0x0001, "the entry attr id should parse correctly")
    assert.are.equal(config_rep_resp:serialize(), frame, "the message should pack to the input")
  end)
  it("should handle multiple attribute records", function()
    local frame = success_status .. direction_0 .. attr_id_1 .. unsupported_attr_status .. direction_0 .. attr_id_2
    local config_rep_resp = zcl_cmds.ConfigureReportingResponse.deserialize(buf_from_str(frame))
    assert.are.equal(#config_rep_resp.config_records, 2, "there should be two entries")
    assert.are.equal(config_rep_resp.config_records[1].status.value, 0x00, "the first entry should have the correct status")
    assert.are.equal(config_rep_resp.config_records[1].direction.value, 0x00, "the first entry should have the correct direction")
    assert.are.equal(config_rep_resp.config_records[1].attr_id.value, 0x0001, "the first entry attr id should parse correctly")
    assert.are.equal(config_rep_resp.config_records[2].status.value, 0x86, "the second entry should have the correct status")
    assert.are.equal(config_rep_resp.config_records[2].direction.value, 0x00, "the second entry should have the correct direction")
    assert.are.equal(config_rep_resp.config_records[2].attr_id.value, 0x0002, "the second entry data value should parse correctly")
    assert.are.equal(config_rep_resp:serialize(), frame, "the message should pack to the input")
  end)
  it("should be correctly parsed from command id", function()
    local frame = success_status .. direction_0 .. attr_id_1 .. unsupported_attr_status .. direction_0 .. attr_id_2
    local config_rep_resp = zcl_cmds.parse_global_zcl_command(0x07, buf_from_str(frame))
    assert.are.equal(#config_rep_resp.config_records, 2, "there should be two entries")
    assert.are.equal(config_rep_resp.config_records[1].status.value, 0x00, "the first entry should have the correct status")
    assert.are.equal(config_rep_resp.config_records[1].direction.value, 0x00, "the first entry should have the correct direction")
    assert.are.equal(config_rep_resp.config_records[1].attr_id.value, 0x0001, "the first entry attr id should parse correctly")
    assert.are.equal(config_rep_resp.config_records[2].status.value, 0x86, "the second entry should have the correct status")
    assert.are.equal(config_rep_resp.config_records[2].direction.value, 0x00, "the second entry should have the correct direction")
    assert.are.equal(config_rep_resp.config_records[2].attr_id.value, 0x0002, "the second entry data value should parse correctly")
    assert.are.equal(config_rep_resp:serialize(), frame, "the message should pack to the input")
  end)
end)

describe("test read reporting configuration message", function()
  it("should parse a read reporting attribute record", function()
    local frame = direction_0 .. attr_id_1
    local read_reporting_config = zcl_cmds.ReadReportingConfiguration.deserialize(buf_from_str(frame))
    assert.are.equal(#read_reporting_config.read_reporting_records, 1, "there should be one entry")
    assert.are.equal(read_reporting_config.read_reporting_records[1].direction.value, 0x00, "the direction should parse correctly")
    assert.are.equal(read_reporting_config.read_reporting_records[1].attr_id.value, 0x0001, "the attr id should parse correctly")
    assert.are.equal(read_reporting_config:serialize(), frame, "the message should pack to the input")
  end)
  it("should handle multiple attribute ids", function()
    local frame = direction_0 .. attr_id_1 .. direction_0 .. attr_id_2
    local read_reporting_config = zcl_cmds.ReadReportingConfiguration.deserialize(buf_from_str(frame))
    assert.are.equal(#read_reporting_config.read_reporting_records, 2, "there should be two entries")
    assert.are.equal(read_reporting_config.read_reporting_records[1].direction.value, 0x00, "the first direction should parse correctly")
    assert.are.equal(read_reporting_config.read_reporting_records[1].attr_id.value, 0x0001, "the first attr id should parse correctly")
    assert.are.equal(read_reporting_config.read_reporting_records[2].direction.value, 0x00, "the second direction should parse correctly")
    assert.are.equal(read_reporting_config.read_reporting_records[2].attr_id.value, 0x0002, "the second attr id should parse correctly")
    assert.are.equal(read_reporting_config:serialize(), frame, "the message should pack to the input")
  end)
  it("should handle multiple attribute ids", function()
    local frame = direction_0 .. attr_id_1 .. direction_0 .. attr_id_2
    local read_reporting_config = zcl_cmds.parse_global_zcl_command(0x08, buf_from_str(frame))
    assert.are.equal(#read_reporting_config.read_reporting_records, 2, "there should be two entries")
    assert.are.equal(read_reporting_config.read_reporting_records[1].direction.value, 0x00, "the first direction should parse correctly")
    assert.are.equal(read_reporting_config.read_reporting_records[1].attr_id.value, 0x0001, "the first attr id should parse correctly")
    assert.are.equal(read_reporting_config.read_reporting_records[2].direction.value, 0x00, "the second direction should parse correctly")
    assert.are.equal(read_reporting_config.read_reporting_records[2].attr_id.value, 0x0002, "the second attr id should parse correctly")
    assert.are.equal(read_reporting_config:serialize(), frame, "the message should pack to the input")
  end)
  it("should be buildable from read reporting list", function()
    local read_reporting_record_1 = zcl_cmds.ReadReportingConfiguration.ReadReportingConfigurationAttributeRecord(data_types.Uint8(0x00), data_types.AttributeId(0x0001))
    local read_reporting_record_2 = zcl_cmds.ReadReportingConfiguration.ReadReportingConfigurationAttributeRecord(data_types.Uint8(0x01), data_types.AttributeId(0x0002))
    local read_reporting_cmd = zcl_cmds.ReadReportingConfiguration({read_reporting_record_1, read_reporting_record_2})
    assert.are.equal(#read_reporting_cmd.read_reporting_records, 2, "there should be two entries")
    assert.are.equal(read_reporting_cmd.read_reporting_records[1].direction.value, 0x00, "the first direction should be set correctly")
    assert.are.equal(read_reporting_cmd.read_reporting_records[1].attr_id.value, 0x0001, "the first attr id should be set correctly")
    assert.are.equal(read_reporting_cmd.read_reporting_records[2].direction.value, 0x01, "the second direction should be set correctly")
    assert.are.equal(read_reporting_cmd.read_reporting_records[2].attr_id.value, 0x0002, "the second attr id should be set correctly")
    assert.are.equal(read_reporting_cmd:serialize(), direction_0 .. attr_id_1 .. direction_1 .. attr_id_2, "the message should pack to the correct output")
  end)
  it("should reject an incorrect read record list", function()
    local errfn = function()
      return zcl_cmds.ReadReportingConfiguration.ReadReportingConfigurationAttributeRecord("asdf", data_types.AttributeId(0x0001))
    end
    assert.has_error(errfn, "Error creating direction: ...gine/lua_libs/st/zigbee/data_types/base_defs/UintABC.lua:44: Uint8 value must be an integer")

    errfn = function()
      return zcl_cmds.ReadReportingConfiguration.ReadReportingConfigurationAttributeRecord(data_types.Uint8(0x00), "asdf")
    end
    assert.has_error(errfn, "Error creating attr_id: ...gine/lua_libs/st/zigbee/data_types/base_defs/UintABC.lua:44: AttributeId value must be an integer")

    errfn = function()
      return zcl_cmds.ReadReportingConfiguration({})
    end
    assert.has_error(errfn, "ReadReportingConfiguration requires at least one read reporting config record")
  end)
end)

describe("test read reporting configuration message", function()
  it("Unknown command id should parse as a generic body", function()
    local frame = "\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0A\x0B\x0C\x0D\x0E\x0F\x10"
    local message = zcl_cmds.parse_global_zcl_command(0xFF, buf_from_str(frame))
    assert.are.equal(message:serialize(), frame, "should pack to the original body")
  end)
end)

describe("test read reportring response command", function()
  local min_rep_int_32 = "\x20\x00"
  local max_rep_int_100 = "\x64\x00"
  local timeout_100 = "\x64\x00"
  local Ieee_addr_data_type = "\xF0"
  it("should parse a direction 0x00 non discrete config", function()
    local config_record_1 = success_status .. direction_0 .. attr_id_1 .. uint16_data_type .. min_rep_int_32 .. max_rep_int_100 .. uint16_data_27
    local frame = config_record_1
    local read_report_config = zcl_cmds.ReadReportingConfigurationResponse.deserialize(buf_from_str(frame))
    assert.are.equal(#read_report_config.read_reporting_records, 1, "there should be one entry")
    local rec = read_report_config.read_reporting_records[1]
    assert.are.equal(rec.direction.value, 0, "the direction should be parsed")
    assert.are.equal(rec.attr_id.value, 0x0001, "the attr id should be parsed")
    assert.are.equal(rec.data_type.value, data_types.Uint16.ID, "the data type should be parsed")
    assert.are.equal(rec.minimum_reporting_interval.value, 32, "the minimum reporting interval should be parsed")
    assert.are.equal(rec.maximum_reporting_interval.value, 100, "the maximum reporting interval should be parsed")
    assert.are.equal(rec.reportable_change.value, 27, "the reportable change should be parsed")
    assert.is_nil(rec.timeout, "the timeout should be nil")
    assert.are.equal(read_report_config:serialize(), frame, "the message should pack to the input")
  end)
  it("should parse a direction 0x00 discrete config", function()
    local config_record_1 = success_status .. direction_0 .. attr_id_1 .. Ieee_addr_data_type .. min_rep_int_32 .. max_rep_int_100
    local frame = config_record_1
    local read_report_config_response = zcl_cmds.ReadReportingConfigurationResponse.deserialize(buf_from_str(frame))
    assert.are.equal(#read_report_config_response.read_reporting_records, 1, "there should be one entry")
    local rec = read_report_config_response.read_reporting_records[1]
    assert.are.equal(rec.direction.value, 0, "the direction should be parsed")
    assert.are.equal(rec.attr_id.value, 0x0001, "the attr id should be parsed")
    assert.are.equal(rec.data_type.value, data_types.IeeeAddress.ID, "the data type should be parsed")
    assert.are.equal(rec.minimum_reporting_interval.value, 32, "the minimum reporting interval should be parsed")
    assert.are.equal(rec.maximum_reporting_interval.value, 100, "the maximum reporting interval should be parsed")
    assert.is_nil(rec.reportable_change, "the reportable change should be nil for discrete types")
    assert.is_nil(rec.timeout, "the timeout should be nil")
    assert.are.equal(read_report_config_response:serialize(), frame, "the message should pack to the input")
  end)
  it("should parse a direction 0x01 config", function()
    local config_record_1 = success_status .. direction_1 .. attr_id_1 .. timeout_100
    local frame = config_record_1
    local read_report_config_response = zcl_cmds.ReadReportingConfigurationResponse.deserialize(buf_from_str(frame))
    assert.are.equal(#read_report_config_response.read_reporting_records, 1, "there should be one entry")
    local rec = read_report_config_response.read_reporting_records[1]
    assert.are.equal(rec.direction.value, 0x01, "the direction should be parsed")
    assert.are.equal(rec.attr_id.value, 0x0001, "the attr id should be parsed")
    assert.is_nil(rec.data_type, "the data type should be nil")
    assert.is_nil(rec.minimum_reporting_interval, "the minimum reporting interval should be nil")
    assert.is_nil(rec.maximum_reporting_interval, "the maximum reporting interval should be nil")
    assert.is_nil(rec.reportable_change, "the reportable change should be nil")
    assert.are.equal(rec.timeout.value, 100, "the timeout should be parsed correctly")
    assert.are.equal(read_report_config_response:serialize(), frame, "the message should pack to the input")
  end)
  it("should parse multiple records", function()
    local config_record_1 = success_status .. direction_0 .. attr_id_1 .. Ieee_addr_data_type .. min_rep_int_32 .. max_rep_int_100
    local config_record_2 = success_status .. direction_0 .. attr_id_1 .. uint16_data_type .. min_rep_int_32 .. max_rep_int_100 .. uint16_data_27
    local frame = config_record_1 .. config_record_2
    local read_reporting_config = zcl_cmds.ReadReportingConfigurationResponse.deserialize(buf_from_str(frame))
    assert.are.equal(#read_reporting_config.read_reporting_records, 2, "there should be two entries")
    local rec = read_reporting_config.read_reporting_records[1]
    assert.are.equal(rec.direction.value, 0, "the direction should be parsed")
    assert.are.equal(rec.attr_id.value, 0x0001, "the attr id should be parsed")
    assert.are.equal(rec.data_type.value, data_types.IeeeAddress.ID, "the data type should be parsed")
    assert.are.equal(rec.minimum_reporting_interval.value, 32, "the minimum reporting interval should be parsed")
    assert.are.equal(rec.maximum_reporting_interval.value, 100, "the maximum reporting interval should be parsed")
    assert.is_nil(rec.timeout, "the timeout should be nil")
    assert.is_nil(rec.reportable_change, "the reportable change should be nil for discrete types")
    rec = read_reporting_config.read_reporting_records[2]
    assert.are.equal(rec.direction.value, 0, "the direction should be parsed")
    assert.are.equal(rec.attr_id.value, 0x0001, "the attr id should be parsed")
    assert.are.equal(rec.data_type.value, data_types.Uint16.ID, "the data type should be parsed")
    assert.are.equal(rec.minimum_reporting_interval.value, 32, "the minimum reporting interval should be parsed")
    assert.are.equal(rec.maximum_reporting_interval.value, 100, "the maximum reporting interval should be parsed")
    assert.are.equal(rec.reportable_change.value, 27, "the reportable change should be parsed")
    assert.is_nil(rec.timeout, "the timeout should be nil")
    assert.are.equal(read_reporting_config:serialize(), frame, "the message should pack to the input")
  end)
  it("should parse from command id", function()
    local config_record_1 = success_status .. direction_0 .. attr_id_1 .. Ieee_addr_data_type .. min_rep_int_32 .. max_rep_int_100
    local config_record_2 = success_status .. direction_0 .. attr_id_1 .. uint16_data_type .. min_rep_int_32 .. max_rep_int_100 .. uint16_data_27
    local frame = config_record_1 .. config_record_2
    local read_reporting_config = zcl_cmds.parse_global_zcl_command(0x09, buf_from_str(frame))
    assert.are.equal(#read_reporting_config.read_reporting_records, 2, "there should be two entries")
    local rec = read_reporting_config.read_reporting_records[1]
    assert.are.equal(rec.direction.value, 0, "the direction should be parsed")
    assert.are.equal(rec.attr_id.value, 0x0001, "the attr id should be parsed")
    assert.are.equal(rec.data_type.value, data_types.IeeeAddress.ID, "the data type should be parsed")
    assert.are.equal(rec.minimum_reporting_interval.value, 32, "the minimum reporting interval should be parsed")
    assert.are.equal(rec.maximum_reporting_interval.value, 100, "the maximum reporting interval should be parsed")
    assert.is_nil(rec.timeout, "the timeout should be nil")
    assert.is_nil(rec.reportable_change, "the reportable change should be nil for discrete types")
    rec = read_reporting_config.read_reporting_records[2]
    assert.are.equal(rec.direction.value, 0, "the direction should be parsed")
    assert.are.equal(rec.attr_id.value, 0x0001, "the attr id should be parsed")
    assert.are.equal(rec.data_type.value, data_types.Uint16.ID, "the data type should be parsed")
    assert.are.equal(rec.minimum_reporting_interval.value, 32, "the minimum reporting interval should be parsed")
    assert.are.equal(rec.maximum_reporting_interval.value, 100, "the maximum reporting interval should be parsed")
    assert.are.equal(rec.reportable_change.value, 27, "the reportable change should be parsed")
    assert.is_nil(rec.timeout, "the timeout should be nil")
    assert.are.equal(read_reporting_config:serialize(), frame, "the message should pack to the input")
  end)
end)

describe("test default response message", function()
  it("should parse from bytes", function()
    local frame = "\x01" .. success_status
    local default_response = zcl_cmds.DefaultResponse.deserialize(buf_from_str(frame))
    assert.are.equal(default_response.cmd.value, 0x01, "the cmd id should parse correctly")
    assert.are.equal(default_response.status.value, 0x00, "the status should parse correctly")
    assert.are.equal(default_response:serialize(), frame, "the message should pack to the input")
  end)
  it("should be correctly parsed from command id", function()
    local frame = "\x01" .. success_status
    local default_response = zcl_cmds.parse_global_zcl_command(0x0B, buf_from_str(frame))
    assert.are.equal(default_response.cmd.value, 0x01, "the cmd id should parse correctly")
    assert.are.equal(default_response.status.value, 0x00, "the status should parse correctly")
    assert.are.equal(default_response:serialize(), frame, "the message should pack to the input")
  end)
end)
