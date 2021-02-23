local data_types = require "st.zigbee.data_types"
local utils = require "st.zigbee.utils"
local ZclStatus = require "st.zigbee.generated.types.ZclStatus"

-- DO NOT EDIT: this code is automatically generated by tools/zigbee-lib_generator/generate_clusters_from_xml.py
-- Script version: b'2cda4a8ebeb3328f48b89dd179d4e8623e7ad8f1'
-- ZCL XML version: 7.2

-----------------------------------------------------------
-- Commissioning command ResetStartupParametersResponse
-----------------------------------------------------------

--- @class st.zigbee.zcl.clusters.Commissioning.ResetStartupParametersResponse
--- @alias ResetStartupParametersResponse
---
--- @field public ID number 0x03 the ID of this command
--- @field public NAME string "ResetStartupParametersResponse" the name of this command
--- @field public status ZclStatus
local ResetStartupParametersResponse = {}
ResetStartupParametersResponse.NAME = "ResetStartupParametersResponse"
ResetStartupParametersResponse.ID = 0x03
ResetStartupParametersResponse.args_def = {
  {
    name = "status",
    optional = false,
    data_type = ZclStatus,
    is_complex = false,
  },
}

function ResetStartupParametersResponse:get_fields()
  local fields = {}
  for _, v in ipairs(self.args_def) do
    if self[v.name] ~= nil then
      fields[#fields + 1] = self[v.name]
    end
  end
  return fields
end

ResetStartupParametersResponse.get_length = utils.length_from_fields
ResetStartupParametersResponse.serialize = utils.serialize_from_fields
ResetStartupParametersResponse.pretty_print = utils.print_from_fields

--- Deserialize this command
---
--- @param buf buf the bytes of the command body
--- @return ResetStartupParametersResponse
function ResetStartupParametersResponse.deserialize(buf)
  local out = {}
  for _, v in ipairs(ResetStartupParametersResponse.args_def) do
    if not v.optional or buf:remain() > 0 then
      out[v.name] = v.data_type.deserialize(buf)
    end
  end
  setmetatable(out, {__index = ResetStartupParametersResponse})
  out:set_field_names()
  return out
end

function ResetStartupParametersResponse:set_field_names()
  for _, v in ipairs(self.args_def) do
    if self[v.name] ~= nil then
      self[v.name].field_name = v.name
    end
  end
end

--- Build a version of this message as if it came from the device
---
--- @param device ZigbeeDevice the device to build the message from
--- @param status ZclStatus
--- @return ZigbeeMessageRx The full Zigbee message containing this command body
function ResetStartupParametersResponse.build_test_rx(device, status)
  local out = {}
  local args = {status}
  for i,v in ipairs(ResetStartupParametersResponse.args_def) do
    if v.optional and args[i] == nil then
      out[v.name] = nil
    elseif not v.optional and args[i] == nil then
      out[v.name] = data_types.validate_or_build_type(v.default, v.data_type, v.name)   
    else
      out[v.name] = data_types.validate_or_build_type(args[i], v.data_type, v.name)
    end
  end
  setmetatable(out, {__index = ResetStartupParametersResponse})
  out:set_field_names()
  return ResetStartupParametersResponse._cluster:build_test_rx_cluster_specific_command(device, out, "client")
end

--- Initialize the ResetStartupParametersResponse command
---
--- @param self ResetStartupParametersResponse the template class for this command
--- @param device ZigbeeDevice the device to build this message to
--- @param status ZclStatus
--- @return ZigbeeMessageTx the full command addressed to the device
function ResetStartupParametersResponse:init(device, status)
  local out = {}
  local args = {status}
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
    __index = ResetStartupParametersResponse,
    __tostring = ResetStartupParametersResponse.pretty_print
  })
  out:set_field_names()
  return self._cluster:build_cluster_specific_command(device, out, "client")
end

function ResetStartupParametersResponse:set_parent_cluster(cluster)
  self._cluster = cluster
  return self
end

setmetatable(ResetStartupParametersResponse, {__call = ResetStartupParametersResponse.init})

return ResetStartupParametersResponse
