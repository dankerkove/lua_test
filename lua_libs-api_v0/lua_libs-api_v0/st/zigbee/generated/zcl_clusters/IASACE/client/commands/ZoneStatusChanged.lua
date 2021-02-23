local data_types = require "st.zigbee.data_types"
local utils = require "st.zigbee.utils"
local IasZoneStatus = require "st.zigbee.generated.types.IasZoneStatus"
--- @type IasaceAudibleNotification
--- @alias IasaceAudibleNotificationType
local IasaceAudibleNotificationType = require "st.zigbee.generated.zcl_clusters.IASACE.types.IasaceAudibleNotification"

-- DO NOT EDIT: this code is automatically generated by tools/zigbee-lib_generator/generate_clusters_from_xml.py
-- Script version: b'2cda4a8ebeb3328f48b89dd179d4e8623e7ad8f1'
-- ZCL XML version: 7.2

-----------------------------------------------------------
-- IASACE command ZoneStatusChanged
-----------------------------------------------------------

--- @class st.zigbee.zcl.clusters.IASACE.ZoneStatusChanged
--- @alias ZoneStatusChanged
---
--- @field public ID number 0x03 the ID of this command
--- @field public NAME string "ZoneStatusChanged" the name of this command
--- @field public zone_id Uint8
--- @field public zone_status IasZoneStatus
--- @field public audible_notification st.zigbee.zcl.clusters.IASACE.types.IasaceAudibleNotification
--- @field public zone_label CharString
local ZoneStatusChanged = {}
ZoneStatusChanged.NAME = "ZoneStatusChanged"
ZoneStatusChanged.ID = 0x03
ZoneStatusChanged.args_def = {
  {
    name = "zone_id",
    optional = false,
    data_type = data_types.Uint8,
    is_complex = false,
    default = 0x00,
  },
  {
    name = "zone_status",
    optional = false,
    data_type = IasZoneStatus,
    is_complex = false,
  },
  {
    name = "audible_notification",
    optional = false,
    data_type = IasaceAudibleNotificationType,
    is_complex = false,
    default = 0x00,
  },
  {
    name = "zone_label",
    optional = false,
    data_type = data_types.CharString,
    is_complex = false,
    default = "",
  },
}

function ZoneStatusChanged:get_fields()
  local fields = {}
  for _, v in ipairs(self.args_def) do
    if self[v.name] ~= nil then
      fields[#fields + 1] = self[v.name]
    end
  end
  return fields
end

ZoneStatusChanged.get_length = utils.length_from_fields
ZoneStatusChanged.serialize = utils.serialize_from_fields
ZoneStatusChanged.pretty_print = utils.print_from_fields

--- Deserialize this command
---
--- @param buf buf the bytes of the command body
--- @return ZoneStatusChanged
function ZoneStatusChanged.deserialize(buf)
  local out = {}
  for _, v in ipairs(ZoneStatusChanged.args_def) do
    if not v.optional or buf:remain() > 0 then
      out[v.name] = v.data_type.deserialize(buf)
    end
  end
  setmetatable(out, {__index = ZoneStatusChanged})
  out:set_field_names()
  return out
end

function ZoneStatusChanged:set_field_names()
  for _, v in ipairs(self.args_def) do
    if self[v.name] ~= nil then
      self[v.name].field_name = v.name
    end
  end
end

--- Build a version of this message as if it came from the device
---
--- @param device ZigbeeDevice the device to build the message from
--- @param zone_id Uint8
--- @param zone_status IasZoneStatus
--- @param audible_notification st.zigbee.zcl.clusters.IASACE.types.IasaceAudibleNotification
--- @param zone_label CharString
--- @return ZigbeeMessageRx The full Zigbee message containing this command body
function ZoneStatusChanged.build_test_rx(device, zone_id, zone_status, audible_notification, zone_label)
  local out = {}
  local args = {zone_id, zone_status, audible_notification, zone_label}
  for i,v in ipairs(ZoneStatusChanged.args_def) do
    if v.optional and args[i] == nil then
      out[v.name] = nil
    elseif not v.optional and args[i] == nil then
      out[v.name] = data_types.validate_or_build_type(v.default, v.data_type, v.name)   
    else
      out[v.name] = data_types.validate_or_build_type(args[i], v.data_type, v.name)
    end
  end
  setmetatable(out, {__index = ZoneStatusChanged})
  out:set_field_names()
  return ZoneStatusChanged._cluster:build_test_rx_cluster_specific_command(device, out, "client")
end

--- Initialize the ZoneStatusChanged command
---
--- @param self ZoneStatusChanged the template class for this command
--- @param device ZigbeeDevice the device to build this message to
--- @param zone_id Uint8
--- @param zone_status IasZoneStatus
--- @param audible_notification st.zigbee.zcl.clusters.IASACE.types.IasaceAudibleNotification
--- @param zone_label CharString
--- @return ZigbeeMessageTx the full command addressed to the device
function ZoneStatusChanged:init(device, zone_id, zone_status, audible_notification, zone_label)
  local out = {}
  local args = {zone_id, zone_status, audible_notification, zone_label}
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
    __index = ZoneStatusChanged,
    __tostring = ZoneStatusChanged.pretty_print
  })
  out:set_field_names()
  return self._cluster:build_cluster_specific_command(device, out, "client")
end

function ZoneStatusChanged:set_parent_cluster(cluster)
  self._cluster = cluster
  return self
end

setmetatable(ZoneStatusChanged, {__call = ZoneStatusChanged.init})

return ZoneStatusChanged
