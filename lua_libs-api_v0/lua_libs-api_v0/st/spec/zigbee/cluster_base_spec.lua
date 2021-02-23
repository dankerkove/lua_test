local cluster_base = require "st.zigbee.cluster_base"
local data_types = require "st.zigbee.data_types"
local zcl_global_commands = require "st.zigbee.zcl.global_commands"
local buf_lib = require "st.buf"

local device = {device_network_id="DEAD", zigbee_short_addr = 0xDEAD, fingerprinted_endpoint_id=0x01}
device.get_short_address = function(self)
  return self.zigbee_short_addr
end
device.get_endpoint = function(self)
  return self.fingerprinted_endpoint_id
end
local test_cluster = {
  ID = 0x0001,
  NAME = "TestCluster"
}
setmetatable(test_cluster, cluster_base)

describe("test non-complex, non-writable, non-discrete attribute", function()
  local test_attr = test_cluster:build_cluster_attribute(0x0000, "TestAttribute", data_types.Uint8, false, false)
  it("should correctly build the attribute", function()
    assert.are.equal(test_attr.NAME, "TestAttribute", "name should be correct")
    assert.are.equal(test_attr.ID, 0x0000, "ID should be correct")
  end)
  it("should be buildable from values", function()
    local attr = test_attr:new_value(1)
    assert.are.equal(attr.value, 1, "value should be correct")
    assert.are.equal(attr.ID, data_types.Uint8.ID, "ID should match attribute type")
  end)
  it("should be readable", function()
    local read_cmd = test_attr:read(device)
    assert.are.equal(read_cmd.address_header.cluster.value, test_cluster.ID, "command should be for correct cluster")
    assert.are.equal(read_cmd.body.zcl_header.frame_ctrl:is_cluster_specific_set(), false, "should be a global command")
    assert.are.equal(read_cmd.body.zcl_header.cmd.value, zcl_global_commands.ReadAttribute.ID, "command should be a read attribute")
    assert.are.equal(#read_cmd.body.zcl_body.attr_ids, 1, "command should be for 1 attribute")
    assert.are.equal(read_cmd.body.zcl_body.attr_ids[1].value, 0x0000, "command should read the right attribute")
  end)
  it("should be configurable", function()
    local config_cmd = test_attr:configure_reporting(device, 1, 300, 1)
    assert.are.equal(config_cmd.address_header.cluster.value, test_cluster.ID, "command should be for correct cluster")
    assert.are.equal(config_cmd.body.zcl_header.frame_ctrl:is_cluster_specific_set(), false, "should be a global command")
    assert.are.equal(config_cmd.body.zcl_header.cmd.value, zcl_global_commands.ConfigureReporting.ID, "command should be a configure reporting")
    assert.are.equal(#config_cmd.body.zcl_body.attr_config_records, 1, "should have a single config record")
    assert.are.equal(config_cmd.body.zcl_body.attr_config_records[1].attr_id.value, 0x0000, "should be a config for the correct attribute")
    assert.are.equal(config_cmd.body.zcl_body.attr_config_records[1].minimum_reporting_interval.value, 1, "should have the correct minimum reporting interval")
    assert.are.equal(config_cmd.body.zcl_body.attr_config_records[1].maximum_reporting_interval.value, 300, "should have the correct maximum reporting interval")
    assert.are.equal(config_cmd.body.zcl_body.attr_config_records[1].reportable_change.value, 1, "should have a reportable change of the correct value")
  end)
  it("should error on a write call", function()
    local errfn = function()
      return test_attr:write(device)
    end
    assert.has_error(errfn, "Attribute TestAttribute is not writable.")
  end)
end)

describe("test non-complex, writable, discrete attribute", function()
  local test_attr = test_cluster:build_cluster_attribute(0x0000, "TestAttribute", data_types.AttributeId, true, false)
  it("should correctly build the attribute", function()
    assert.are.equal(test_attr.NAME, "TestAttribute", "name should be correct")
    assert.are.equal(test_attr.ID, 0x0000, "ID should be correct")
  end)
  it("should be buildable from values", function()
    local attr = test_attr:new_value(1)
    assert.are.equal(attr.value, 1, "value should be correct")
    assert.are.equal(attr.ID, data_types.AttributeId.ID, "ID should match attribute type")
  end)
  it("should be readable", function()
    local read_cmd = test_attr:read(device)
    assert.are.equal(read_cmd.address_header.cluster.value, test_cluster.ID, "command should be for correct cluster")
    assert.are.equal(read_cmd.body.zcl_header.frame_ctrl:is_cluster_specific_set(), false, "should be a global command")
    assert.are.equal(read_cmd.body.zcl_header.cmd.value, zcl_global_commands.ReadAttribute.ID, "command should be a read attribute")
    assert.are.equal(#read_cmd.body.zcl_body.attr_ids, 1, "command should be for 1 attribute")
    assert.are.equal(read_cmd.body.zcl_body.attr_ids[1].value, 0x0000, "command should read the right attribute")
  end)
  it("should be configurable", function()
    local config_cmd = test_attr:configure_reporting(device, 1, 300)
    assert.are.equal(config_cmd.address_header.cluster.value, test_cluster.ID, "command should be for correct cluster")
    assert.are.equal(config_cmd.body.zcl_header.frame_ctrl:is_cluster_specific_set(), false, "should be a global command")
    assert.are.equal(config_cmd.body.zcl_header.cmd.value, zcl_global_commands.ConfigureReporting.ID, "command should be a configure reporting")
    assert.are.equal(#config_cmd.body.zcl_body.attr_config_records, 1, "should have a single config record")
    assert.are.equal(config_cmd.body.zcl_body.attr_config_records[1].attr_id.value, 0x0000, "should be a config for the correct attribute")
    assert.are.equal(config_cmd.body.zcl_body.attr_config_records[1].minimum_reporting_interval.value, 1, "should have the correct minimum reporting interval")
    assert.are.equal(config_cmd.body.zcl_body.attr_config_records[1].maximum_reporting_interval.value, 300, "should have the correct maximum reporting interval")
    assert.are.equal(config_cmd.body.zcl_body.attr_config_records[1].reportable_change, nil, "should not have a reportable change")
  end)
  it("should be writable", function()
    local write_cmd = test_attr:write(device, 0xBEEF)
    assert.are.equal(write_cmd.address_header.cluster.value, test_cluster.ID, "command should be for correct cluster")
    assert.are.equal(write_cmd.body.zcl_header.frame_ctrl:is_cluster_specific_set(), false, "should be a global command")
    assert.are.equal(write_cmd.body.zcl_header.cmd.value, zcl_global_commands.WriteAttribute.ID, "command should be a read attribute")
    assert.are.equal(#write_cmd.body.zcl_body.attr_records, 1, "command should be for 1 attribute")
    assert.are.equal(write_cmd.body.zcl_body.attr_records[1].data_type.value, data_types.AttributeId.ID, "command should read the right attribute type")
    assert.are.equal(write_cmd.body.zcl_body.attr_records[1].data.value, 0xBEEF, "command should read the right attribute value")
  end)
end)

describe("test complex, writable, non-discrete attribute", function()
  local test_attr = test_cluster:build_cluster_attribute(0x0000, "TestAttribute", data_types.TimeOfDay, true, true)
  it("should correctly build the attribute", function()
    assert.are.equal(test_attr.NAME, "TestAttribute", "name should be correct")
    assert.are.equal(test_attr.ID, 0x0000, "ID should be correct")
  end)
  it("should be buildable from values", function()
    local attr = test_attr:new_value(1, 2, 3, 4)
    assert.are.equal(attr.value, nil, "value should be correct")
    assert.are.equal(attr.hours.value, 1, "attribute should be built correctly")
    assert.are.equal(attr.minutes.value, 2, "attribute should be built correctly")
    assert.are.equal(attr.seconds.value, 3, "attribute should be built correctly")
    assert.are.equal(attr.hundredths.value, 4, "attribute should be built correctly")
    assert.are.equal(attr.ID, data_types.TimeOfDay.ID, "ID should match attribute type")
  end)
  it("should be readable", function()
    local read_cmd = test_attr:read(device)
    assert.are.equal(read_cmd.address_header.cluster.value, test_cluster.ID, "command should be for correct cluster")
    assert.are.equal(read_cmd.body.zcl_header.frame_ctrl:is_cluster_specific_set(), false, "should be a global command")
    assert.are.equal(read_cmd.body.zcl_header.cmd.value, zcl_global_commands.ReadAttribute.ID, "command should be a read attribute")
    assert.are.equal(#read_cmd.body.zcl_body.attr_ids, 1, "command should be for 1 attribute")
    assert.are.equal(read_cmd.body.zcl_body.attr_ids[1].value, 0x0000, "command should read the right attribute")
  end)
  it("should be configurable", function()
    local config_cmd = test_attr:configure_reporting(device, 1, 300, test_attr:new_value(1,2,3,4))
    assert.are.equal(config_cmd.address_header.cluster.value, test_cluster.ID, "command should be for correct cluster")
    assert.are.equal(config_cmd.body.zcl_header.frame_ctrl:is_cluster_specific_set(), false, "should be a global command")
    assert.are.equal(config_cmd.body.zcl_header.cmd.value, zcl_global_commands.ConfigureReporting.ID, "command should be a configure reporting")
    assert.are.equal(#config_cmd.body.zcl_body.attr_config_records, 1, "should have a single config record")
    assert.are.equal(config_cmd.body.zcl_body.attr_config_records[1].attr_id.value, 0x0000, "should be a config for the correct attribute")
    assert.are.equal(config_cmd.body.zcl_body.attr_config_records[1].minimum_reporting_interval.value, 1, "should have the correct minimum reporting interval")
    assert.are.equal(config_cmd.body.zcl_body.attr_config_records[1].maximum_reporting_interval.value, 300, "should have the correct maximum reporting interval")
    assert.are.equal(config_cmd.body.zcl_body.attr_config_records[1].reportable_change.hours.value, 1, "should have a reportable change with correct hours")
    assert.are.equal(config_cmd.body.zcl_body.attr_config_records[1].reportable_change.minutes.value, 2, "should have a reportable change with correct minutes")
    assert.are.equal(config_cmd.body.zcl_body.attr_config_records[1].reportable_change.seconds.value, 3, "should have a reportable change with correct seconds")
    assert.are.equal(config_cmd.body.zcl_body.attr_config_records[1].reportable_change.hundredths.value, 4, "should have a reportable change with correct hundredths")
  end)
  it("should reject configuration of complex type with raw values", function()
    local errfn = function()
      return test_attr:configure_reporting(device, 1, 300, 1, 2, 3, 4)
    end
    assert.has_error(errfn, "TestAttribute is of complex type TimeOfDay and should be built before passing in.")
  end)
  it("should be writable", function()
    local write_cmd = test_attr:write(device, test_attr:new_value(1,2,3,4))
    assert.are.equal(write_cmd.address_header.cluster.value, test_cluster.ID, "command should be for correct cluster")
    assert.are.equal(write_cmd.body.zcl_header.frame_ctrl:is_cluster_specific_set(), false, "should be a global command")
    assert.are.equal(write_cmd.body.zcl_header.cmd.value, zcl_global_commands.WriteAttribute.ID, "command should be a read attribute")
    assert.are.equal(#write_cmd.body.zcl_body.attr_records, 1, "command should be for 1 attribute")
    assert.are.equal(write_cmd.body.zcl_body.attr_records[1].data_type.value, data_types.TimeOfDay.ID, "command should read the right attribute type")
    assert.are.equal(write_cmd.body.zcl_body.attr_records[1].data.value, nil, "command should read the right attribute value")
    assert.are.equal(write_cmd.body.zcl_body.attr_records[1].data.hours.value, 1, "attribute should be built correctly")
    assert.are.equal(write_cmd.body.zcl_body.attr_records[1].data.minutes.value, 2, "attribute should be built correctly")
    assert.are.equal(write_cmd.body.zcl_body.attr_records[1].data.seconds.value, 3, "attribute should be built correctly")
    assert.are.equal(write_cmd.body.zcl_body.attr_records[1].data.hundredths.value, 4, "attribute should be built correctly")
  end)
end)

describe("test command without complex or optional args", function()
  local arg_list = {
    {
      name = "timeout_in_seconds",
      optional = false,
      data_type = data_types.Uint16,
      is_complex = false,
    },
    {
      name = "pin",
      optional = false,
      data_type = data_types.CharString,
      is_complex = false,
    }
  }
  local body_byte_string = "\x01\x00\x04\x41\x42\x43\x44"
  local test_com = test_cluster:build_cluster_command_table("TestCommand", 0x00, arg_list)
  it("should be built correctly", function()
    assert.are.equal(test_com.NAME, "TestCommand", "Name is correct")
    assert.are.equal(test_com.ID, 0x00, "ID should be correct")
  end)
  it("should be parsable from bytes", function()
    local parsed = test_com.deserialize(buf_lib.Reader(body_byte_string))
    assert.are.equal(parsed.timeout_in_seconds.value, 0x0001, "should parse first argument")
    assert.are.equal(parsed.pin.value, "ABCD", "should parse second argument")
    assert.are.equal(parsed:serialize(), body_byte_string, "should be packable ")
    assert.are.equal(parsed:pretty_print(), "< TestCommand || timeout_in_seconds: 0x0001, pin: \"ABCD\" >", "should be pretty printable")
  end)
  it("should be constructable from args", function()
    local built = test_com(device, 0x0001, "ABCD")
    assert.are.equal(built.body.zcl_body.timeout_in_seconds.value, 0x0001, "should parse first argument")
    assert.are.equal(built.body.zcl_body.pin.value, "ABCD", "should parse second argument")
    assert.are.equal(built.body.zcl_body:serialize(), body_byte_string, "should be packable ")
    assert.are.equal(built.address_header.dest_addr.value, device:get_short_address(), "should be addressed to the device")
    assert.are.equal(built.address_header.dest_endpoint.value, device.fingerprinted_endpoint_id, "should have the device endpoint")
    assert.are.equal(built.body.zcl_header.cmd.value, 0x00, "should use the correct command id")
    assert.is_true(built.body.zcl_header.frame_ctrl:is_cluster_specific_set(), "should be marked as cluster specific")
  end)
end)

describe("test command with complex and optional args", function()
  local arg_list = {
    {
      name = "time_of_day",
      optional = false,
      data_type = data_types.TimeOfDay,
      is_complex = true,
    },
    {
      name = "pin",
      optional = true,
      data_type = data_types.CharString,
      is_complex = false,
    }
  }
  local body_byte_string = "\x01\x02\x03\x04"
  local test_com = test_cluster:build_cluster_command_table("TestCommand", 0x00, arg_list)
  it("should be built correctly", function()
    assert.are.equal(test_com.NAME, "TestCommand", "Name is correct")
    assert.are.equal(test_com.ID, 0x00, "ID should be correct")
  end)
  it("should be parsable from bytes", function()
    local parsed = test_com.deserialize(buf_lib.Reader(body_byte_string))
    assert.are.equal(parsed.time_of_day.hours.value, 1, "should parse first argument")
    assert.are.equal(parsed.time_of_day.minutes.value, 2, "should parse first argument")
    assert.are.equal(parsed.time_of_day.seconds.value, 3, "should parse first argument")
    assert.are.equal(parsed.time_of_day.hundredths.value, 4, "should parse first argument")
    assert.are.equal(parsed.pin, nil, "should accept a nil optional arg")
    assert.are.equal(parsed:serialize(), body_byte_string, "should be packable ")
    assert.are.equal(parsed:pretty_print(), "< TestCommand || time_of_day: 01:02:03.04 >", "should be pretty printable")
  end)
  it("should be constructable from args not including optional args", function()
    local built = test_com(device, data_types.TimeOfDay(1,2,3,4))
    assert.are.equal(built.body.zcl_body.time_of_day.hours.value, 1, "should parse first argument")
    assert.are.equal(built.body.zcl_body.time_of_day.minutes.value, 2, "should parse first argument")
    assert.are.equal(built.body.zcl_body.time_of_day.seconds.value, 3, "should parse first argument")
    assert.are.equal(built.body.zcl_body.time_of_day.hundredths.value, 4, "should parse first argument")
    assert.are.equal(built.body.zcl_body.pin, nil, "should accept nil optional arg")
    assert.are.equal(built.body.zcl_body:serialize(), body_byte_string, "should be packable ")
    assert.are.equal(built.address_header.dest_addr.value, device:get_short_address(), "should be addressed to the device")
    assert.are.equal(built.address_header.dest_endpoint.value, device.fingerprinted_endpoint_id, "should have the device endpoint")
    assert.are.equal(built.body.zcl_header.cmd.value, 0x00, "should use the correct command id")
    assert.is_true(built.body.zcl_header.frame_ctrl:is_cluster_specific_set(), "should be marked as cluster specific")
  end)
  it("Should reject complex args with raw values", function()
    local errfn = function()
      return test_com(device, 1,2,3,4)
    end
    assert.has_error(errfn, "TestCommand received too many arguments")
    errfn = function()
      return test_com(device, 1)
    end
    assert.has_error(errfn, "Error creating time_of_day: ...gine/lua_libs/st/zigbee/data_types/base_defs/UintABC.lua:44: Uint8 value must be an integer")
  end)
end)
