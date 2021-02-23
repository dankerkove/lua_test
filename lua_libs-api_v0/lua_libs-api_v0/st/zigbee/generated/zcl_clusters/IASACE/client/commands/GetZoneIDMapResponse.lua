local data_types = require "st.zigbee.data_types"
local utils = require "st.zigbee.utils"

-- DO NOT EDIT: this code is automatically generated by tools/zigbee-lib_generator/generate_clusters_from_xml.py
-- Script version: b'2cda4a8ebeb3328f48b89dd179d4e8623e7ad8f1'
-- ZCL XML version: 7.2

-----------------------------------------------------------
-- IASACE command GetZoneIDMapResponse
-----------------------------------------------------------

--- @class st.zigbee.zcl.clusters.IASACE.GetZoneIDMapResponse
--- @alias GetZoneIDMapResponse
---
--- @field public ID number 0x01 the ID of this command
--- @field public NAME string "GetZoneIDMapResponse" the name of this command
--- @field public zone_id_map_section00 Bitmap16
--- @field public zone_id_map_section01 Bitmap16
--- @field public zone_id_map_section02 Bitmap16
--- @field public zone_id_map_section03 Bitmap16
--- @field public zone_id_map_section04 Bitmap16
--- @field public zone_id_map_section05 Bitmap16
--- @field public zone_id_map_section06 Bitmap16
--- @field public zone_id_map_section07 Bitmap16
--- @field public zone_id_map_section08 Bitmap16
--- @field public zone_id_map_section09 Bitmap16
--- @field public zone_id_map_section10 Bitmap16
--- @field public zone_id_map_section11 Bitmap16
--- @field public zone_id_map_section12 Bitmap16
--- @field public zone_id_map_section13 Bitmap16
--- @field public zone_id_map_section14 Bitmap16
--- @field public zone_id_map_section15 Bitmap16
local GetZoneIDMapResponse = {}
GetZoneIDMapResponse.NAME = "GetZoneIDMapResponse"
GetZoneIDMapResponse.ID = 0x01
GetZoneIDMapResponse.args_def = {
  {
    name = "zone_id_map_section00",
    optional = false,
    data_type = data_types.Bitmap16,
    is_complex = false,
    default = 0x0000,
  },
  {
    name = "zone_id_map_section01",
    optional = false,
    data_type = data_types.Bitmap16,
    is_complex = false,
    default = 0x0000,
  },
  {
    name = "zone_id_map_section02",
    optional = false,
    data_type = data_types.Bitmap16,
    is_complex = false,
    default = 0x0000,
  },
  {
    name = "zone_id_map_section03",
    optional = false,
    data_type = data_types.Bitmap16,
    is_complex = false,
    default = 0x0000,
  },
  {
    name = "zone_id_map_section04",
    optional = false,
    data_type = data_types.Bitmap16,
    is_complex = false,
    default = 0x0000,
  },
  {
    name = "zone_id_map_section05",
    optional = false,
    data_type = data_types.Bitmap16,
    is_complex = false,
    default = 0x0000,
  },
  {
    name = "zone_id_map_section06",
    optional = false,
    data_type = data_types.Bitmap16,
    is_complex = false,
    default = 0x0000,
  },
  {
    name = "zone_id_map_section07",
    optional = false,
    data_type = data_types.Bitmap16,
    is_complex = false,
    default = 0x0000,
  },
  {
    name = "zone_id_map_section08",
    optional = false,
    data_type = data_types.Bitmap16,
    is_complex = false,
    default = 0x0000,
  },
  {
    name = "zone_id_map_section09",
    optional = false,
    data_type = data_types.Bitmap16,
    is_complex = false,
    default = 0x0000,
  },
  {
    name = "zone_id_map_section10",
    optional = false,
    data_type = data_types.Bitmap16,
    is_complex = false,
    default = 0x0000,
  },
  {
    name = "zone_id_map_section11",
    optional = false,
    data_type = data_types.Bitmap16,
    is_complex = false,
    default = 0x0000,
  },
  {
    name = "zone_id_map_section12",
    optional = false,
    data_type = data_types.Bitmap16,
    is_complex = false,
    default = 0x0000,
  },
  {
    name = "zone_id_map_section13",
    optional = false,
    data_type = data_types.Bitmap16,
    is_complex = false,
    default = 0x0000,
  },
  {
    name = "zone_id_map_section14",
    optional = false,
    data_type = data_types.Bitmap16,
    is_complex = false,
    default = 0x0000,
  },
  {
    name = "zone_id_map_section15",
    optional = false,
    data_type = data_types.Bitmap16,
    is_complex = false,
    default = 0x0000,
  },
}

function GetZoneIDMapResponse:get_fields()
  local fields = {}
  for _, v in ipairs(self.args_def) do
    if self[v.name] ~= nil then
      fields[#fields + 1] = self[v.name]
    end
  end
  return fields
end

GetZoneIDMapResponse.get_length = utils.length_from_fields
GetZoneIDMapResponse.serialize = utils.serialize_from_fields
GetZoneIDMapResponse.pretty_print = utils.print_from_fields

--- Deserialize this command
---
--- @param buf buf the bytes of the command body
--- @return GetZoneIDMapResponse
function GetZoneIDMapResponse.deserialize(buf)
  local out = {}
  for _, v in ipairs(GetZoneIDMapResponse.args_def) do
    if not v.optional or buf:remain() > 0 then
      out[v.name] = v.data_type.deserialize(buf)
    end
  end
  setmetatable(out, {__index = GetZoneIDMapResponse})
  out:set_field_names()
  return out
end

function GetZoneIDMapResponse:set_field_names()
  for _, v in ipairs(self.args_def) do
    if self[v.name] ~= nil then
      self[v.name].field_name = v.name
    end
  end
end

--- Build a version of this message as if it came from the device
---
--- @param device ZigbeeDevice the device to build the message from
--- @param zone_id_map_section00 Bitmap16
--- @param zone_id_map_section01 Bitmap16
--- @param zone_id_map_section02 Bitmap16
--- @param zone_id_map_section03 Bitmap16
--- @param zone_id_map_section04 Bitmap16
--- @param zone_id_map_section05 Bitmap16
--- @param zone_id_map_section06 Bitmap16
--- @param zone_id_map_section07 Bitmap16
--- @param zone_id_map_section08 Bitmap16
--- @param zone_id_map_section09 Bitmap16
--- @param zone_id_map_section10 Bitmap16
--- @param zone_id_map_section11 Bitmap16
--- @param zone_id_map_section12 Bitmap16
--- @param zone_id_map_section13 Bitmap16
--- @param zone_id_map_section14 Bitmap16
--- @param zone_id_map_section15 Bitmap16
--- @return ZigbeeMessageRx The full Zigbee message containing this command body
function GetZoneIDMapResponse.build_test_rx(device, zone_id_map_section00, zone_id_map_section01, zone_id_map_section02, zone_id_map_section03, zone_id_map_section04, zone_id_map_section05, zone_id_map_section06, zone_id_map_section07, zone_id_map_section08, zone_id_map_section09, zone_id_map_section10, zone_id_map_section11, zone_id_map_section12, zone_id_map_section13, zone_id_map_section14, zone_id_map_section15)
  local out = {}
  local args = {zone_id_map_section00, zone_id_map_section01, zone_id_map_section02, zone_id_map_section03, zone_id_map_section04, zone_id_map_section05, zone_id_map_section06, zone_id_map_section07, zone_id_map_section08, zone_id_map_section09, zone_id_map_section10, zone_id_map_section11, zone_id_map_section12, zone_id_map_section13, zone_id_map_section14, zone_id_map_section15}
  for i,v in ipairs(GetZoneIDMapResponse.args_def) do
    if v.optional and args[i] == nil then
      out[v.name] = nil
    elseif not v.optional and args[i] == nil then
      out[v.name] = data_types.validate_or_build_type(v.default, v.data_type, v.name)   
    else
      out[v.name] = data_types.validate_or_build_type(args[i], v.data_type, v.name)
    end
  end
  setmetatable(out, {__index = GetZoneIDMapResponse})
  out:set_field_names()
  return GetZoneIDMapResponse._cluster:build_test_rx_cluster_specific_command(device, out, "client")
end

--- Initialize the GetZoneIDMapResponse command
---
--- @param self GetZoneIDMapResponse the template class for this command
--- @param device ZigbeeDevice the device to build this message to
--- @param zone_id_map_section00 Bitmap16
--- @param zone_id_map_section01 Bitmap16
--- @param zone_id_map_section02 Bitmap16
--- @param zone_id_map_section03 Bitmap16
--- @param zone_id_map_section04 Bitmap16
--- @param zone_id_map_section05 Bitmap16
--- @param zone_id_map_section06 Bitmap16
--- @param zone_id_map_section07 Bitmap16
--- @param zone_id_map_section08 Bitmap16
--- @param zone_id_map_section09 Bitmap16
--- @param zone_id_map_section10 Bitmap16
--- @param zone_id_map_section11 Bitmap16
--- @param zone_id_map_section12 Bitmap16
--- @param zone_id_map_section13 Bitmap16
--- @param zone_id_map_section14 Bitmap16
--- @param zone_id_map_section15 Bitmap16
--- @return ZigbeeMessageTx the full command addressed to the device
function GetZoneIDMapResponse:init(device, zone_id_map_section00, zone_id_map_section01, zone_id_map_section02, zone_id_map_section03, zone_id_map_section04, zone_id_map_section05, zone_id_map_section06, zone_id_map_section07, zone_id_map_section08, zone_id_map_section09, zone_id_map_section10, zone_id_map_section11, zone_id_map_section12, zone_id_map_section13, zone_id_map_section14, zone_id_map_section15)
  local out = {}
  local args = {zone_id_map_section00, zone_id_map_section01, zone_id_map_section02, zone_id_map_section03, zone_id_map_section04, zone_id_map_section05, zone_id_map_section06, zone_id_map_section07, zone_id_map_section08, zone_id_map_section09, zone_id_map_section10, zone_id_map_section11, zone_id_map_section12, zone_id_map_section13, zone_id_map_section14, zone_id_map_section15}
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
    __index = GetZoneIDMapResponse,
    __tostring = GetZoneIDMapResponse.pretty_print
  })
  out:set_field_names()
  return self._cluster:build_cluster_specific_command(device, out, "client")
end

function GetZoneIDMapResponse:set_parent_cluster(cluster)
  self._cluster = cluster
  return self
end

setmetatable(GetZoneIDMapResponse, {__call = GetZoneIDMapResponse.init})

return GetZoneIDMapResponse
