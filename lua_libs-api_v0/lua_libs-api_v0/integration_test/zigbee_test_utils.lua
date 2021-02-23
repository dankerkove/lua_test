local report_attr = require "st.zigbee.zcl.global_commands.report_attribute"
local read_attr = require "st.zigbee.zcl.global_commands.read_attribute"
local config_reporting = require "st.zigbee.zcl.global_commands.configure_reporting"
local messages = require "st.zigbee.messages"
local data_types = require "st.zigbee.data_types"
local zb_const = require "st.zigbee.constants"
local FrameCtrl = require "st.zigbee.zcl.frame_ctrl"
local bind_request = require "st.zigbee.zdo.bind_request"
local base64 = require "st.base64"
local zdo_messages = require "st.zigbee.zdo"
local zcl_messages = require "st.zigbee.zcl"
local generic_body = require "st.zigbee.generic_body"
local buf = require "st.buf"
local int_test = require "integration_test"

local zigbee_test_utils = {
  mock_hub_eui = "\x00\x01\x02\x03\x04\x05\x07\x08"
}

zigbee_test_utils.build_custom_command_id = function(device, cluster, cmd_id, mfg_code, payload)

  local header_args = {
    frame_ctrl = FrameCtrl(0x01),
    cmd = data_types.ZCLCommandId(cmd_id)
  }

  local zclh = zcl_messages.ZclHeader(header_args)
  if mfg_code ~= nil then
    header_args.frame_ctrl = FrameCtrl(FrameCtrl.MFG_SPECIFIC)
    header_args.mfg_code = data_types.validate_or_build_type(mfg_code, data_types.Uint16, "mfg_code")
    zclh.frame_ctrl:set_cluster_specific()
  end

  local addrh = messages.AddressHeader(
      device:get_short_address(),
      device.fingerprinted_endpoint_id,
      zb_const.HUB.ADDR,
      zb_const.HUB.ENDPOINT,
      zb_const.HA_PROFILE_ID,
      cluster
  )

  local payload_body = generic_body.GenericBody.deserialize(buf.Reader(payload))

  local message_body = zcl_messages.ZclMessageBody({
    zcl_header = zclh,
    zcl_body = payload_body
  })

  local send_message = messages.ZigbeeMessageRx({
    address_header = addrh,
    body = message_body
  })

  return send_message
end

zigbee_test_utils.build_attribute_report = function(device, cluster, attr_list, mfg_code)
  local attr_records = {}
  for i, args in ipairs(attr_list) do
    attr_records[#attr_records + 1] = report_attr.ReportAttributeAttributeRecord(table.unpack(args))
  end
  local report_body = report_attr.ReportAttribute(attr_records)

  local header_args = { cmd = data_types.ZCLCommandId(report_body.ID) }
  if mfg_code ~= nil then
    header_args.frame_ctrl = FrameCtrl(FrameCtrl.MFG_SPECIFIC)
    header_args.mfg_code = data_types.validate_or_build_type(mfg_code, data_types.Uint16, "mfg_code")
  end
  local zclh = zcl_messages.ZclHeader(header_args)
  local addrh = messages.AddressHeader(
      device:get_short_address(),
      device.fingerprinted_endpoint_id,
      zb_const.HUB.ADDR,
      zb_const.HUB.ENDPOINT,
      zb_const.HA_PROFILE_ID,
      cluster
  )
  local message_body = zcl_messages.ZclMessageBody({
    zcl_header = zclh,
    zcl_body = report_body
  })
  local report = messages.ZigbeeMessageRx({
    address_header = addrh,
    body = message_body
  })
  return report
end

zigbee_test_utils.build_attribute_read = function(device, cluster_id, attr_list, mfg_code)
  local read_body = read_attr.ReadAttribute(attr_list)

  local header_args = {
    cmd = data_types.ZCLCommandId(read_body.ID)
  }
  if mfg_code ~= nil then
    header_args.frame_ctrl = FrameCtrl(FrameCtrl.MFG_SPECIFIC)
    header_args.mfg_code = data_types.validate_or_build_type(mfg_code, data_types.Uint16, "mfg_code")
  end
  local zclh = zcl_messages.ZclHeader(header_args)
  local addrh = messages.AddressHeader(
      zb_const.HUB.ADDR,
      zb_const.HUB.ENDPOINT,
      device:get_short_address(),
      device.fingerprinted_endpoint_id,
      zb_const.HA_PROFILE_ID,
      cluster_id
  )
  local message_body = zcl_messages.ZclMessageBody({
    zcl_header = zclh,
    zcl_body = read_body
  })
  return messages.ZigbeeMessageTx({
    address_header = addrh,
    body = message_body
  })
end

function zigbee_test_utils.build_bind_request(device, hub_eui, cluster)
  local addr_header = messages.AddressHeader(zb_const.HUB.ADDR, zb_const.HUB.ENDPOINT, device:get_short_address(), device.fingerprinted_endpoint_id, zb_const.ZDO_PROFILE_ID, bind_request.BindRequest.ID)
  -- TODO: How best to handle test device zigbee_eui
  local bind_req = bind_request.BindRequest(device.zigbee_eui, device.fingerprinted_endpoint_id, cluster, bind_request.ADDRESS_MODE_64_BIT, hub_eui, zb_const.HUB.ENDPOINT)
  local message_body = zdo_messages.ZdoMessageBody({
    zdo_body = bind_req
  })
  return messages.ZigbeeMessageTx({
    address_header = addr_header,
    body = message_body
  })
end

function zigbee_test_utils.build_attr_config(device, cluster, attr, min_int, max_int, data_type, rep_change, mfg_code)
  local conf_record = config_reporting.ConfigureReporting.AttributeReportingConfiguration(
      {
        direction = data_types.Uint8(0),
        attr_id = data_types.AttributeId(attr),
        minimum_reporting_interval = data_types.Uint16(min_int),
        maximum_reporting_interval = data_types.Uint16(max_int),
        data_type = data_types.ZigbeeDataType(data_type.ID),
        reportable_change = rep_change
      }
  )
  local config_rep_body = config_reporting.ConfigureReporting({ conf_record })
  local addr_header = messages.AddressHeader(zb_const.HUB.ADDR, zb_const.HUB.ENDPOINT, device:get_short_address(), device.fingerprinted_endpoint_id, zb_const.HA_PROFILE_ID, cluster)
  local zcl_header = zcl_messages.ZclHeader(
      {
        cmd = data_types.ZCLCommandId(config_rep_body.ID)
      }
  )
  if mfg_code ~= nil then
    zcl_header.frame_ctrl:set_mfg_specific()
    zcl_header.mfg_code = data_types.Uint16(mfg_code)
  end
  local message_body = zcl_messages.ZclMessageBody({
    zcl_header = zcl_header,
    zcl_body = config_rep_body
  })
  return messages.ZigbeeMessageTx(
      {
        address_header = addr_header,
        body = message_body
      }
  )
end

function zigbee_test_utils.init_noop_health_check_timer()
  int_test.timer.__create_and_queue_never_fire_timer("interval", "health_check")
end

function zigbee_test_utils.init_noop_config_check_timer()
  int_test.timer.__create_and_queue_never_fire_timer("oneshot", "config_check")
end

return zigbee_test_utils
