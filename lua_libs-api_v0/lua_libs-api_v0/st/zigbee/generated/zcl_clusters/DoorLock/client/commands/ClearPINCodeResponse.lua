local data_types = require "st.zigbee.data_types"
local utils = require "st.zigbee.utils"
--- @type DrlkPassFailStatus
--- @alias DrlkPassFailStatusType
local DrlkPassFailStatusType = require "st.zigbee.generated.zcl_clusters.DoorLock.types.DrlkPassFailStatus"

-- DO NOT EDIT: this code is automatically generated by tools/zigbee-lib_generator/generate_clusters_from_xml.py
-- Script version: b'2cda4a8ebeb3328f48b89dd179d4e8623e7ad8f1'
-- ZCL XML version: 7.2

-----------------------------------------------------------
-- DoorLock command ClearPINCodeResponse
-----------------------------------------------------------

--- @class st.zigbee.zcl.clusters.DoorLock.ClearPINCodeResponse
--- @alias ClearPINCodeResponse
---
--- @field public ID number 0x07 the ID of this command
--- @field public NAME string "ClearPINCodeResponse" the name of this command
--- @field public status st.zigbee.zcl.clusters.DoorLock.types.DrlkPassFailStatus
local ClearPINCodeResponse = {}
ClearPINCodeResponse.NAME = "ClearPINCodeResponse"
ClearPINCodeResponse.ID = 0x07
ClearPINCodeResponse.args_def = {
  {
    name = "status",
    optional = false,
    data_type = DrlkPassFailStatusType,
    is_complex = false,
    default = 0x00,
  },
}

function ClearPINCodeResponse:get_fields()
  local fields = {}
  for _, v in ipairs(self.args_def) do
    if self[v.name] ~= nil then
      fields[#fields + 1] = self[v.name]
    end
  end
  return fields
end

ClearPINCodeResponse.get_length = utils.length_from_fields
ClearPINCodeResponse.serialize = utils.serialize_from_fields
ClearPINCodeResponse.pretty_print = utils.print_from_fields

--- Deserialize this command
---
--- @param buf buf the bytes of the command body
--- @return ClearPINCodeResponse
function ClearPINCodeResponse.deserialize(buf)
  local out = {}
  for _, v in ipairs(ClearPINCodeResponse.args_def) do
    if not v.optional or buf:remain() > 0 then
      out[v.name] = v.data_type.deserialize(buf)
    end
  end
  setmetatable(out, {__index = ClearPINCodeResponse})
  out:set_field_names()
  return out
end

function ClearPINCodeResponse:set_field_names()
  for _, v in ipairs(self.args_def) do
    if self[v.name] ~= nil then
      self[v.name].field_name = v.name
    end
  end
end

--- Build a version of this message as if it came from the device
---
--- @param device ZigbeeDevice the device to build the message from
--- @param status st.zigbee.zcl.clusters.DoorLock.types.DrlkPassFailStatus
--- @return ZigbeeMessageRx The full Zigbee message containing this command body
function ClearPINCodeResponse.build_test_rx(device, status)
  local out = {}
  local args = {status}
  for i,v in ipairs(ClearPINCodeResponse.args_def) do
    if v.optional and args[i] == nil then
      out[v.name] = nil
    elseif not v.optional and args[i] == nil then
      out[v.name] = data_types.validate_or_build_type(v.default, v.data_type, v.name)   
    else
      out[v.name] = data_types.validate_or_build_type(args[i], v.data_type, v.name)
    end
  end
  setmetatable(out, {__index = ClearPINCodeResponse})
  out:set_field_names()
  return ClearPINCodeResponse._cluster:build_test_rx_cluster_specific_command(device, out, "client")
end

--- Initialize the ClearPINCodeResponse command
---
--- @param self ClearPINCodeResponse the template class for this command
--- @param device ZigbeeDevice the device to build this message to
--- @param status st.zigbee.zcl.clusters.DoorLock.types.DrlkPassFailStatus
--- @return ZigbeeMessageTx the full command addressed to the device
function ClearPINCodeResponse:init(device, status)
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
    __index = ClearPINCodeResponse,
    __tostring = ClearPINCodeResponse.pretty_print
  })
  out:set_field_names()
  return self._cluster:build_cluster_specific_command(device, out, "client")
end

function ClearPINCodeResponse:set_parent_cluster(cluster)
  self._cluster = cluster
  return self
end

setmetatable(ClearPINCodeResponse, {__call = ClearPINCodeResponse.init})

return ClearPINCodeResponse
