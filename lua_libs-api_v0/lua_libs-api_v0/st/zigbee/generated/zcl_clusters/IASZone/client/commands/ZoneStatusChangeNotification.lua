local data_types = require "st.zigbee.data_types"
local utils = require "st.zigbee.utils"
local IasZoneStatus = require "st.zigbee.generated.types.IasZoneStatus"

-- DO NOT EDIT: this code is automatically generated by tools/zigbee-lib_generator/generate_clusters_from_xml.py
-- Script version: b'2cda4a8ebeb3328f48b89dd179d4e8623e7ad8f1'
-- ZCL XML version: 7.2

-----------------------------------------------------------
-- IASZone command ZoneStatusChangeNotification
-----------------------------------------------------------

--- @class st.zigbee.zcl.clusters.IASZone.ZoneStatusChangeNotification
--- @alias ZoneStatusChangeNotification
---
--- @field public ID number 0x00 the ID of this command
--- @field public NAME string "ZoneStatusChangeNotification" the name of this command
--- @field public zone_status IasZoneStatus
--- @field public extended_status Bitmap8
--- @field public zone_id Uint8
--- @field public delay Uint16
local ZoneStatusChangeNotification = {}
ZoneStatusChangeNotification.NAME = "ZoneStatusChangeNotification"
ZoneStatusChangeNotification.ID = 0x00
ZoneStatusChangeNotification.args_def = {
  {
    name = "zone_status",
    optional = false,
    data_type = IasZoneStatus,
    is_complex = false,
  },
  {
    name = "extended_status",
    optional = false,
    data_type = data_types.Bitmap8,
    is_complex = false,
    default = 0x00,
  },
  {
    name = "zone_id",
    optional = false,
    data_type = data_types.Uint8,
    is_complex = false,
    default = 0x00,
  },
  {
    name = "delay",
    optional = false,
    data_type = data_types.Uint16,
    is_complex = false,
    default = 0x0000,
  },
}

function ZoneStatusChangeNotification:get_fields()
  local fields = {}
  for _, v in ipairs(self.args_def) do
    if self[v.name] ~= nil then
      fields[#fields + 1] = self[v.name]
    end
  end
  return fields
end

ZoneStatusChangeNotification.get_length = utils.length_from_fields
ZoneStatusChangeNotification.serialize = utils.serialize_from_fields
ZoneStatusChangeNotification.pretty_print = utils.print_from_fields

--- Deserialize this command
---
--- @param buf buf the bytes of the command body
--- @return ZoneStatusChangeNotification
function ZoneStatusChangeNotification.deserialize(buf)
  local out = {}
  for _, v in ipairs(ZoneStatusChangeNotification.args_def) do
    if not v.optional or buf:remain() > 0 then
      out[v.name] = v.data_type.deserialize(buf)
    end
  end
  setmetatable(out, {__index = ZoneStatusChangeNotification})
  out:set_field_names()
  return out
end

function ZoneStatusChangeNotification:set_field_names()
  for _, v in ipairs(self.args_def) do
    if self[v.name] ~= nil then
      self[v.name].field_name = v.name
    end
  end
end

--- Build a version of this message as if it came from the device
---
--- @param device ZigbeeDevice the device to build the message from
--- @param zone_status IasZoneStatus
--- @param extended_status Bitmap8
--- @param zone_id Uint8
--- @param delay Uint16
--- @return ZigbeeMessageRx The full Zigbee message containing this command body
function ZoneStatusChangeNotification.build_test_rx(device, zone_status, extended_status, zone_id, delay)
  local out = {}
  local args = {zone_status, extended_status, zone_id, delay}
  for i,v in ipairs(ZoneStatusChangeNotification.args_def) do
    if v.optional and args[i] == nil then
      out[v.name] = nil
    elseif not v.optional and args[i] == nil then
      out[v.name] = data_types.validate_or_build_type(v.default, v.data_type, v.name)   
    else
      out[v.name] = data_types.validate_or_build_type(args[i], v.data_type, v.name)
    end
  end
  setmetatable(out, {__index = ZoneStatusChangeNotification})
  out:set_field_names()
  return ZoneStatusChangeNotification._cluster:build_test_rx_cluster_specific_command(device, out, "client")
end

--- Initialize the ZoneStatusChangeNotification command
---
--- @param self ZoneStatusChangeNotification the template class for this command
--- @param device ZigbeeDevice the device to build this message to
--- @param zone_status IasZoneStatus
--- @param extended_status Bitmap8
--- @param zone_id Uint8
--- @param delay Uint16
--- @return ZigbeeMessageTx the full command addressed to the device
function ZoneStatusChangeNotification:init(device, zone_status, extended_status, zone_id, delay)
  local out = {}
  local args = {zone_status, extended_status, zone_id, delay}
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
    __index = ZoneStatusChangeNotification,
    __tostring = ZoneStatusChangeNotification.pretty_print
  })
  out:set_field_names()
  return self._cluster:build_cluster_specific_command(device, out, "client")
end

function ZoneStatusChangeNotification:set_parent_cluster(cluster)
  self._cluster = cluster
  return self
end

setmetatable(ZoneStatusChangeNotification, {__call = ZoneStatusChangeNotification.init})

return ZoneStatusChangeNotification
