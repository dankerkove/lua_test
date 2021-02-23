local data_types = require "st.zigbee.data_types"
local utils = require "st.zigbee.utils"
local ZclStatus = require "st.zigbee.generated.types.ZclStatus"
--- @type ImageTypeId
--- @alias ImageTypeIdType
local ImageTypeIdType = require "st.zigbee.generated.zcl_clusters.OTAUpgrade.types.ImageTypeId"

-- DO NOT EDIT: this code is automatically generated by tools/zigbee-lib_generator/generate_clusters_from_xml.py
-- Script version: b'2cda4a8ebeb3328f48b89dd179d4e8623e7ad8f1'
-- ZCL XML version: 7.2

-----------------------------------------------------------
-- OTAUpgrade command UpgradeEndRequest
-----------------------------------------------------------

--- @class st.zigbee.zcl.clusters.OTAUpgrade.UpgradeEndRequest
--- @alias UpgradeEndRequest
---
--- @field public ID number 0x06 the ID of this command
--- @field public NAME string "UpgradeEndRequest" the name of this command
--- @field public status ZclStatus
--- @field public manufacturer_code Uint16
--- @field public image_type st.zigbee.zcl.clusters.OTAUpgrade.types.ImageTypeId
--- @field public file_version Uint32
local UpgradeEndRequest = {}
UpgradeEndRequest.NAME = "UpgradeEndRequest"
UpgradeEndRequest.ID = 0x06
UpgradeEndRequest.args_def = {
  {
    name = "status",
    optional = false,
    data_type = ZclStatus,
    is_complex = false,
  },
  {
    name = "manufacturer_code",
    optional = false,
    data_type = data_types.Uint16,
    is_complex = false,
    default = 0x0000,
  },
  {
    name = "image_type",
    optional = false,
    data_type = ImageTypeIdType,
    is_complex = false,
    default = 0x0000,
  },
  {
    name = "file_version",
    optional = false,
    data_type = data_types.Uint32,
    is_complex = false,
    default = 0x00000000,
  },
}

function UpgradeEndRequest:get_fields()
  local fields = {}
  for _, v in ipairs(self.args_def) do
    if self[v.name] ~= nil then
      fields[#fields + 1] = self[v.name]
    end
  end
  return fields
end

UpgradeEndRequest.get_length = utils.length_from_fields
UpgradeEndRequest.serialize = utils.serialize_from_fields
UpgradeEndRequest.pretty_print = utils.print_from_fields

--- Deserialize this command
---
--- @param buf buf the bytes of the command body
--- @return UpgradeEndRequest
function UpgradeEndRequest.deserialize(buf)
  local out = {}
  for _, v in ipairs(UpgradeEndRequest.args_def) do
    if not v.optional or buf:remain() > 0 then
      out[v.name] = v.data_type.deserialize(buf)
    end
  end
  setmetatable(out, {__index = UpgradeEndRequest})
  out:set_field_names()
  return out
end

function UpgradeEndRequest:set_field_names()
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
--- @param manufacturer_code Uint16
--- @param image_type st.zigbee.zcl.clusters.OTAUpgrade.types.ImageTypeId
--- @param file_version Uint32
--- @return ZigbeeMessageRx The full Zigbee message containing this command body
function UpgradeEndRequest.build_test_rx(device, status, manufacturer_code, image_type, file_version)
  local out = {}
  local args = {status, manufacturer_code, image_type, file_version}
  for i,v in ipairs(UpgradeEndRequest.args_def) do
    if v.optional and args[i] == nil then
      out[v.name] = nil
    elseif not v.optional and args[i] == nil then
      out[v.name] = data_types.validate_or_build_type(v.default, v.data_type, v.name)   
    else
      out[v.name] = data_types.validate_or_build_type(args[i], v.data_type, v.name)
    end
  end
  setmetatable(out, {__index = UpgradeEndRequest})
  out:set_field_names()
  return UpgradeEndRequest._cluster:build_test_rx_cluster_specific_command(device, out, "server")
end

--- Initialize the UpgradeEndRequest command
---
--- @param self UpgradeEndRequest the template class for this command
--- @param device ZigbeeDevice the device to build this message to
--- @param status ZclStatus
--- @param manufacturer_code Uint16
--- @param image_type st.zigbee.zcl.clusters.OTAUpgrade.types.ImageTypeId
--- @param file_version Uint32
--- @return ZigbeeMessageTx the full command addressed to the device
function UpgradeEndRequest:init(device, status, manufacturer_code, image_type, file_version)
  local out = {}
  local args = {status, manufacturer_code, image_type, file_version}
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
    __index = UpgradeEndRequest,
    __tostring = UpgradeEndRequest.pretty_print
  })
  out:set_field_names()
  return self._cluster:build_cluster_specific_command(device, out, "server")
end

function UpgradeEndRequest:set_parent_cluster(cluster)
  self._cluster = cluster
  return self
end

setmetatable(UpgradeEndRequest, {__call = UpgradeEndRequest.init})

return UpgradeEndRequest
