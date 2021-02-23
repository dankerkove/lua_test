local data_types = require "st.zigbee.data_types"
local utils = require "st.zigbee.utils"
--- @type TlStatus
--- @alias TlStatusType
local TlStatusType = require "st.zigbee.generated.zcl_clusters.TouchlinkCommissioning.types.TlStatus"

-- DO NOT EDIT: this code is automatically generated by tools/zigbee-lib_generator/generate_clusters_from_xml.py
-- Script version: b'2cda4a8ebeb3328f48b89dd179d4e8623e7ad8f1'
-- ZCL XML version: 7.2

-----------------------------------------------------------
-- TouchlinkCommissioning command NetworkJoinEndDeviceResponse
-----------------------------------------------------------

--- @class st.zigbee.zcl.clusters.TouchlinkCommissioning.NetworkJoinEndDeviceResponse
--- @alias NetworkJoinEndDeviceResponse
---
--- @field public ID number 0x15 the ID of this command
--- @field public NAME string "NetworkJoinEndDeviceResponse" the name of this command
--- @field public inter_pan_transaction_identifier Uint32
--- @field public status st.zigbee.zcl.clusters.TouchlinkCommissioning.types.TlStatus
local NetworkJoinEndDeviceResponse = {}
NetworkJoinEndDeviceResponse.NAME = "NetworkJoinEndDeviceResponse"
NetworkJoinEndDeviceResponse.ID = 0x15
NetworkJoinEndDeviceResponse.args_def = {
  {
    name = "inter_pan_transaction_identifier",
    optional = false,
    data_type = data_types.Uint32,
    is_complex = false,
    default = 0x00000000,
  },
  {
    name = "status",
    optional = false,
    data_type = TlStatusType,
    is_complex = false,
    default = 0x00,
  },
}

function NetworkJoinEndDeviceResponse:get_fields()
  local fields = {}
  for _, v in ipairs(self.args_def) do
    if self[v.name] ~= nil then
      fields[#fields + 1] = self[v.name]
    end
  end
  return fields
end

NetworkJoinEndDeviceResponse.get_length = utils.length_from_fields
NetworkJoinEndDeviceResponse.serialize = utils.serialize_from_fields
NetworkJoinEndDeviceResponse.pretty_print = utils.print_from_fields

--- Deserialize this command
---
--- @param buf buf the bytes of the command body
--- @return NetworkJoinEndDeviceResponse
function NetworkJoinEndDeviceResponse.deserialize(buf)
  local out = {}
  for _, v in ipairs(NetworkJoinEndDeviceResponse.args_def) do
    if not v.optional or buf:remain() > 0 then
      out[v.name] = v.data_type.deserialize(buf)
    end
  end
  setmetatable(out, {__index = NetworkJoinEndDeviceResponse})
  out:set_field_names()
  return out
end

function NetworkJoinEndDeviceResponse:set_field_names()
  for _, v in ipairs(self.args_def) do
    if self[v.name] ~= nil then
      self[v.name].field_name = v.name
    end
  end
end

--- Build a version of this message as if it came from the device
---
--- @param device ZigbeeDevice the device to build the message from
--- @param inter_pan_transaction_identifier Uint32
--- @param status st.zigbee.zcl.clusters.TouchlinkCommissioning.types.TlStatus
--- @return ZigbeeMessageRx The full Zigbee message containing this command body
function NetworkJoinEndDeviceResponse.build_test_rx(device, inter_pan_transaction_identifier, status)
  local out = {}
  local args = {inter_pan_transaction_identifier, status}
  for i,v in ipairs(NetworkJoinEndDeviceResponse.args_def) do
    if v.optional and args[i] == nil then
      out[v.name] = nil
    elseif not v.optional and args[i] == nil then
      out[v.name] = data_types.validate_or_build_type(v.default, v.data_type, v.name)   
    else
      out[v.name] = data_types.validate_or_build_type(args[i], v.data_type, v.name)
    end
  end
  setmetatable(out, {__index = NetworkJoinEndDeviceResponse})
  out:set_field_names()
  return NetworkJoinEndDeviceResponse._cluster:build_test_rx_cluster_specific_command(device, out, "client")
end

--- Initialize the NetworkJoinEndDeviceResponse command
---
--- @param self NetworkJoinEndDeviceResponse the template class for this command
--- @param device ZigbeeDevice the device to build this message to
--- @param inter_pan_transaction_identifier Uint32
--- @param status st.zigbee.zcl.clusters.TouchlinkCommissioning.types.TlStatus
--- @return ZigbeeMessageTx the full command addressed to the device
function NetworkJoinEndDeviceResponse:init(device, inter_pan_transaction_identifier, status)
  local out = {}
  local args = {inter_pan_transaction_identifier, status}
  if #args > #self.args_def then
    error(self.NAME .. " received too many arguments")
  end
  for i,v in ipairs(self.args_def) do
    if v.optional and args[i] == nil then
      out[v.name] = nil
    elseif not v.optional and args[i] == nil then
      out[v.name] = data_types.validate_or_build_type(v.default, v.data_type, v.name)   
    else
      out[v.name] = data_types.validate_or_build_type(args[i], v.data_type, v.name)
    end
  end
  setmetatable(out, {
    __index = NetworkJoinEndDeviceResponse,
    __tostring = NetworkJoinEndDeviceResponse.pretty_print
  })
  out:set_field_names()
  return self._cluster:build_cluster_specific_command(device, out, "client")
end

function NetworkJoinEndDeviceResponse:set_parent_cluster(cluster)
  self._cluster = cluster
  return self
end

setmetatable(NetworkJoinEndDeviceResponse, {__call = NetworkJoinEndDeviceResponse.init})

return NetworkJoinEndDeviceResponse
