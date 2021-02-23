local data_types = require "st.zigbee.data_types"
local utils = require "st.zigbee.utils"
local TlVersion = require "st.zigbee.generated.types.TlVersion"


-- DO NOT EDIT: this code is automatically generated by tools/zigbee-lib_generator/generate_clusters_from_xml.py
-- Script version: b'2cda4a8ebeb3328f48b89dd179d4e8623e7ad8f1'
-- ZCL XML version: 7.2

--- @class st.zigbee.zcl.clusters.TouchlinkCommissioning.types.TlDeviceInformationRecord
--- @alias TlDeviceInformationRecord 
--- @field public NAME TlDeviceInformationRecord
--- @field public ieee_address IeeeAddress
--- @field public endpoint_identifier Uint8
--- @field public profile_indentifier Uint16
--- @field public device_identifier Uint16
--- @field public version TlVersion
--- @field public group_identifier_count Uint8
--- @field public sort Uint8
local TlDeviceInformationRecord = {}
TlDeviceInformationRecord.NAME = "TlDeviceInformationRecord"
TlDeviceInformationRecord.get_fields = function(self)
  local out = {}
  out[#out + 1] = self.ieee_address
  if self.endpoint_identifier ~= nil then
    out[#out + 1] = self.endpoint_identifier
  end
  if self.profile_indentifier ~= nil then
    out[#out + 1] = self.profile_indentifier
  end
  if self.device_identifier ~= nil then
    out[#out + 1] = self.device_identifier
  end
  if self.version ~= nil then
    out[#out + 1] = self.version
  end
  if self.group_identifier_count ~= nil then
    out[#out + 1] = self.group_identifier_count
  end
  if self.sort ~= nil then
    out[#out + 1] = self.sort
  end
  return out
end
TlDeviceInformationRecord.set_field_names = function(self)
  self.ieee_address.field_name = "ieee_address"
  if self.endpoint_identifier ~= nil then
    self.endpoint_identifier.field_name = "endpoint_identifier"
  end
  if self.profile_indentifier ~= nil then
    self.profile_indentifier.field_name = "profile_indentifier"
  end
  if self.device_identifier ~= nil then
    self.device_identifier.field_name = "device_identifier"
  end
  if self.version ~= nil then
    self.version.field_name = "version"
  end
  if self.group_identifier_count ~= nil then
    self.group_identifier_count.field_name = "group_identifier_count"
  end
  if self.sort ~= nil then
    self.sort.field_name = "sort"
  end
end

--- @function TlDeviceInformationRecord:get_length
--- @return number the length in bytes of this frame
TlDeviceInformationRecord.get_length = utils.length_from_fields

--- @function TlDeviceInformationRecord:serialize
--- @return string this class serialized to bytes
TlDeviceInformationRecord.serialize = utils.serialize_from_fields

--- @function TlDeviceInformationRecord:pretty_print
--- @return string this class in a human readable format
TlDeviceInformationRecord.pretty_print = utils.print_from_fields

--- @function TlDeviceInformationRecord.deserialize
--- @param buf Reader the buf to parse this class from
--- @return number the length in bytes of this frame
TlDeviceInformationRecord.deserialize = function(buf)
  local o = {}
  o.ieee_address = data_types.IeeeAddress.deserialize(buf)
  o.endpoint_identifier = nil
  if buf:remain() > 0 then
    o.endpoint_identifier = data_types.Uint8.deserialize(buf)
  end
  o.profile_indentifier = nil
  if buf:remain() > 0 then
    o.profile_indentifier = data_types.Uint16.deserialize(buf)
  end
  o.device_identifier = nil
  if buf:remain() > 0 then
    o.device_identifier = data_types.Uint16.deserialize(buf)
  end
  o.version = nil
  if buf:remain() > 0 then
    o.version = TlVersion.deserialize(buf)
  end
  o.group_identifier_count = nil
  if buf:remain() > 0 then
    o.group_identifier_count = data_types.Uint8.deserialize(buf)
  end
  o.sort = nil
  if buf:remain() > 0 then
    o.sort = data_types.Uint8.deserialize(buf)
  end
  setmetatable(o, {
    __index = TlDeviceInformationRecord,
    __tostring = TlDeviceInformationRecord.pretty_print,
  })
  o:set_field_names()
  return o
end

--- @function TlDeviceInformationRecord.from_values
--- @param ieee_address IeeeAddress
--- @param endpoint_identifier Uint8
--- @param profile_indentifier Uint16
--- @param device_identifier Uint16
--- @param version TlVersion
--- @param group_identifier_count Uint8
--- @param sort Uint8
TlDeviceInformationRecord.from_values = function(orig, ieee_address, endpoint_identifier, profile_indentifier, device_identifier, version, group_identifier_count, sort)
  local o = {}
    o.ieee_address = data_types.IeeeAddress(ieee_address)
    if endpoint_identifier ~= nil then
      o.endpoint_identifier = data_types.Uint8(endpoint_identifier)
    end
    if profile_indentifier ~= nil then
      o.profile_indentifier = data_types.Uint16(profile_indentifier)
    end
    if device_identifier ~= nil then
      o.device_identifier = data_types.Uint16(device_identifier)
    end
    if version ~= nil then
      o.version = TlVersion(version)
    end
    if group_identifier_count ~= nil then
      o.group_identifier_count = data_types.Uint8(group_identifier_count)
    end
    if sort ~= nil then
      o.sort = data_types.Uint8(sort)
    end
  setmetatable(o, {
    __index = orig,
    __tostring = orig.pretty_print
  })
  o:set_field_names()
  return o
end

setmetatable(TlDeviceInformationRecord, {__call = TlDeviceInformationRecord.from_values})
return TlDeviceInformationRecord
