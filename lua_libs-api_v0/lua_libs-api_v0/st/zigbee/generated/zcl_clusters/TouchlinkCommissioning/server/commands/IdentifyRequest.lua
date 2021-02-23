local data_types = require "st.zigbee.data_types"
local utils = require "st.zigbee.utils"

-- DO NOT EDIT: this code is automatically generated by tools/zigbee-lib_generator/generate_clusters_from_xml.py
-- Script version: b'2cda4a8ebeb3328f48b89dd179d4e8623e7ad8f1'
-- ZCL XML version: 7.2

-----------------------------------------------------------
-- TouchlinkCommissioning command IdentifyRequest
-----------------------------------------------------------

--- @class st.zigbee.zcl.clusters.TouchlinkCommissioning.IdentifyRequest
--- @alias IdentifyRequest
---
--- @field public ID number 0x06 the ID of this command
--- @field public NAME string "IdentifyRequest" the name of this command
--- @field public inter_pan_transaction_identifier Uint32
--- @field public identify_duration Uint16
local IdentifyRequest = {}
IdentifyRequest.NAME = "IdentifyRequest"
IdentifyRequest.ID = 0x06
IdentifyRequest.args_def = {
  {
    name = "inter_pan_transaction_identifier",
    optional = false,
    data_type = data_types.Uint32,
    is_complex = false,
    default = 0x00000000,
  },
  {
    name = "identify_duration",
    optional = false,
    data_type = data_types.Uint16,
    is_complex = false,
    default = 0x0000,
  },
}

function IdentifyRequest:get_fields()
  local fields = {}
  for _, v in ipairs(self.args_def) do
    if self[v.name] ~= nil then
      fields[#fields + 1] = self[v.name]
    end
  end
  return fields
end

IdentifyRequest.get_length = utils.length_from_fields
IdentifyRequest.serialize = utils.serialize_from_fields
IdentifyRequest.pretty_print = utils.print_from_fields

--- Deserialize this command
---
--- @param buf buf the bytes of the command body
--- @return IdentifyRequest
function IdentifyRequest.deserialize(buf)
  local out = {}
  for _, v in ipairs(IdentifyRequest.args_def) do
    if not v.optional or buf:remain() > 0 then
      out[v.name] = v.data_type.deserialize(buf)
    end
  end
  setmetatable(out, {__index = IdentifyRequest})
  out:set_field_names()
  return out
end

function IdentifyRequest:set_field_names()
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
--- @param identify_duration Uint16
--- @return ZigbeeMessageRx The full Zigbee message containing this command body
function IdentifyRequest.build_test_rx(device, inter_pan_transaction_identifier, identify_duration)
  local out = {}
  local args = {inter_pan_transaction_identifier, identify_duration}
  for i,v in ipairs(IdentifyRequest.args_def) do
    if v.optional and args[i] == nil then
      out[v.name] = nil
    elseif not v.optional and args[i] == nil then
      out[v.name] = data_types.validate_or_build_type(v.default, v.data_type, v.name)   
    else
      out[v.name] = data_types.validate_or_build_type(args[i], v.data_type, v.name)
    end
  end
  setmetatable(out, {__index = IdentifyRequest})
  out:set_field_names()
  return IdentifyRequest._cluster:build_test_rx_cluster_specific_command(device, out, "server")
end

--- Initialize the IdentifyRequest command
---
--- @param self IdentifyRequest the template class for this command
--- @param device ZigbeeDevice the device to build this message to
--- @param inter_pan_transaction_identifier Uint32
--- @param identify_duration Uint16
--- @return ZigbeeMessageTx the full command addressed to the device
function IdentifyRequest:init(device, inter_pan_transaction_identifier, identify_duration)
  local out = {}
  local args = {inter_pan_transaction_identifier, identify_duration}
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
    __index = IdentifyRequest,
    __tostring = IdentifyRequest.pretty_print
  })
  out:set_field_names()
  return self._cluster:build_cluster_specific_command(device, out, "server")
end

function IdentifyRequest:set_parent_cluster(cluster)
  self._cluster = cluster
  return self
end

setmetatable(IdentifyRequest, {__call = IdentifyRequest.init})

return IdentifyRequest
