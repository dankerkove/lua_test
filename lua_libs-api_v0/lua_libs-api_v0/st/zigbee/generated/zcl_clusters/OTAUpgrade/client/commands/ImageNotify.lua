local data_types = require "st.zigbee.data_types"
local utils = require "st.zigbee.utils"
--- @type PayloadType
--- @alias PayloadTypeType
local PayloadTypeType = require "st.zigbee.generated.zcl_clusters.OTAUpgrade.types.PayloadType"

-- DO NOT EDIT: this code is automatically generated by tools/zigbee-lib_generator/generate_clusters_from_xml.py
-- Script version: b'2cda4a8ebeb3328f48b89dd179d4e8623e7ad8f1'
-- ZCL XML version: 7.2

-----------------------------------------------------------
-- OTAUpgrade command ImageNotify
-----------------------------------------------------------

--- @class st.zigbee.zcl.clusters.OTAUpgrade.ImageNotify
--- @alias ImageNotify
---
--- @field public ID number 0x00 the ID of this command
--- @field public NAME string "ImageNotify" the name of this command
--- @field public payload_type st.zigbee.zcl.clusters.OTAUpgrade.PayloadType
--- @field public query_jitter Uint8
--- @field public manufacturer_code Uint16
--- @field public image_type Uint16
--- @field public new_file_version Uint32
local ImageNotify = {}
ImageNotify.NAME = "ImageNotify"
ImageNotify.ID = 0x00
ImageNotify.args_def = {
  {
    name = "payload_type",
    optional = false,
    data_type = PayloadTypeType,
    is_complex = false,
  },
  {
    name = "query_jitter",
    optional = false,
    data_type = data_types.Uint8,
    is_complex = false,
    default = 0x00,
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
    data_type = data_types.Uint16,
    is_complex = false,
    default = 0x0000,
  },
  {
    name = "new_file_version",
    optional = false,
    data_type = data_types.Uint32,
    is_complex = false,
    default = 0x00000000,
  },
}

function ImageNotify:get_fields()
  local fields = {}
  for _, v in ipairs(self.args_def) do
    if self[v.name] ~= nil then
      fields[#fields + 1] = self[v.name]
    end
  end
  return fields
end

ImageNotify.get_length = utils.length_from_fields
ImageNotify.serialize = utils.serialize_from_fields
ImageNotify.pretty_print = utils.print_from_fields

--- Deserialize this command
---
--- @param buf buf the bytes of the command body
--- @return ImageNotify
function ImageNotify.deserialize(buf)
  local out = {}
  for _, v in ipairs(ImageNotify.args_def) do
    if not v.optional or buf:remain() > 0 then
      out[v.name] = v.data_type.deserialize(buf)
    end
  end
  setmetatable(out, {__index = ImageNotify})
  out:set_field_names()
  return out
end

function ImageNotify:set_field_names()
  for _, v in ipairs(self.args_def) do
    if self[v.name] ~= nil then
      self[v.name].field_name = v.name
    end
  end
end

--- Build a version of this message as if it came from the device
---
--- @param device ZigbeeDevice the device to build the message from
--- @param payload_type st.zigbee.zcl.clusters.OTAUpgrade.PayloadType
--- @param query_jitter Uint8
--- @param manufacturer_code Uint16
--- @param image_type Uint16
--- @param new_file_version Uint32
--- @return ZigbeeMessageRx The full Zigbee message containing this command body
function ImageNotify.build_test_rx(device, payload_type, query_jitter, manufacturer_code, image_type, new_file_version)
  local out = {}
  local args = {payload_type, query_jitter, manufacturer_code, image_type, new_file_version}
  for i,v in ipairs(ImageNotify.args_def) do
    if v.optional and args[i] == nil then
      out[v.name] = nil
    elseif not v.optional and args[i] == nil then
      out[v.name] = data_types.validate_or_build_type(v.default, v.data_type, v.name)   
    else
      out[v.name] = data_types.validate_or_build_type(args[i], v.data_type, v.name)
    end
  end
  setmetatable(out, {__index = ImageNotify})
  out:set_field_names()
  return ImageNotify._cluster:build_test_rx_cluster_specific_command(device, out, "client")
end

--- Initialize the ImageNotify command
---
--- @param self ImageNotify the template class for this command
--- @param device ZigbeeDevice the device to build this message to
--- @param payload_type st.zigbee.zcl.clusters.OTAUpgrade.PayloadType
--- @param query_jitter Uint8
--- @param manufacturer_code Uint16
--- @param image_type Uint16
--- @param new_file_version Uint32
--- @return ZigbeeMessageTx the full command addressed to the device
function ImageNotify:init(device, payload_type, query_jitter, manufacturer_code, image_type, new_file_version)
  local out = {}
  local args = {payload_type, query_jitter, manufacturer_code, image_type, new_file_version}
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
    __index = ImageNotify,
    __tostring = ImageNotify.pretty_print
  })
  out:set_field_names()
  return self._cluster:build_cluster_specific_command(device, out, "client")
end

function ImageNotify:set_parent_cluster(cluster)
  self._cluster = cluster
  return self
end

setmetatable(ImageNotify, {__call = ImageNotify.init})

return ImageNotify
