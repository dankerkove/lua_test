local data_types = require "st.zigbee.data_types"
local utils = require "st.zigbee.utils"
--- @type CcDirection
--- @alias CcDirectionType
local CcDirectionType = require "st.zigbee.generated.zcl_clusters.ColorControl.types.CcDirection"
--- @type CcColorOptions
--- @alias CcColorOptionsType
local CcColorOptionsType = require "st.zigbee.generated.zcl_clusters.ColorControl.types.CcColorOptions"

-- DO NOT EDIT: this code is automatically generated by tools/zigbee-lib_generator/generate_clusters_from_xml.py
-- Script version: b'2cda4a8ebeb3328f48b89dd179d4e8623e7ad8f1'
-- ZCL XML version: 7.2

-----------------------------------------------------------
-- ColorControl command MoveToHue
-----------------------------------------------------------

--- @class st.zigbee.zcl.clusters.ColorControl.MoveToHue
--- @alias MoveToHue
---
--- @field public ID number 0x00 the ID of this command
--- @field public NAME string "MoveToHue" the name of this command
--- @field public hue Uint8
--- @field public direction st.zigbee.zcl.clusters.ColorControl.types.CcDirection
--- @field public transition_time Uint16
--- @field public options_mask st.zigbee.zcl.clusters.ColorControl.types.CcColorOptions
--- @field public options_override st.zigbee.zcl.clusters.ColorControl.types.CcColorOptions
local MoveToHue = {}
MoveToHue.NAME = "MoveToHue"
MoveToHue.ID = 0x00
MoveToHue.args_def = {
  {
    name = "hue",
    optional = false,
    data_type = data_types.Uint8,
    is_complex = false,
    default = 0x00,
  },
  {
    name = "direction",
    optional = false,
    data_type = CcDirectionType,
    is_complex = false,
    default = 0x00,
  },
  {
    name = "transition_time",
    optional = false,
    data_type = data_types.Uint16,
    is_complex = false,
    default = 0x0000,
  },
  {
    name = "options_mask",
    optional = false,
    data_type = CcColorOptionsType,
    is_complex = false,
    default = 0x00,
  },
  {
    name = "options_override",
    optional = false,
    data_type = CcColorOptionsType,
    is_complex = false,
    default = 0x00,
  },
}

function MoveToHue:get_fields()
  local fields = {}
  for _, v in ipairs(self.args_def) do
    if self[v.name] ~= nil then
      fields[#fields + 1] = self[v.name]
    end
  end
  return fields
end

MoveToHue.get_length = utils.length_from_fields
MoveToHue.serialize = utils.serialize_from_fields
MoveToHue.pretty_print = utils.print_from_fields

--- Deserialize this command
---
--- @param buf buf the bytes of the command body
--- @return MoveToHue
function MoveToHue.deserialize(buf)
  local out = {}
  for _, v in ipairs(MoveToHue.args_def) do
    if not v.optional or buf:remain() > 0 then
      out[v.name] = v.data_type.deserialize(buf)
    end
  end
  setmetatable(out, {__index = MoveToHue})
  out:set_field_names()
  return out
end

function MoveToHue:set_field_names()
  for _, v in ipairs(self.args_def) do
    if self[v.name] ~= nil then
      self[v.name].field_name = v.name
    end
  end
end

--- Build a version of this message as if it came from the device
---
--- @param device ZigbeeDevice the device to build the message from
--- @param hue Uint8
--- @param direction st.zigbee.zcl.clusters.ColorControl.types.CcDirection
--- @param transition_time Uint16
--- @param options_mask st.zigbee.zcl.clusters.ColorControl.types.CcColorOptions
--- @param options_override st.zigbee.zcl.clusters.ColorControl.types.CcColorOptions
--- @return ZigbeeMessageRx The full Zigbee message containing this command body
function MoveToHue.build_test_rx(device, hue, direction, transition_time, options_mask, options_override)
  local out = {}
  local args = {hue, direction, transition_time, options_mask, options_override}
  for i,v in ipairs(MoveToHue.args_def) do
    if v.optional and args[i] == nil then
      out[v.name] = nil
    elseif not v.optional and args[i] == nil then
      out[v.name] = data_types.validate_or_build_type(v.default, v.data_type, v.name)   
    else
      out[v.name] = data_types.validate_or_build_type(args[i], v.data_type, v.name)
    end
  end
  setmetatable(out, {__index = MoveToHue})
  out:set_field_names()
  return MoveToHue._cluster:build_test_rx_cluster_specific_command(device, out, "server")
end

--- Initialize the MoveToHue command
---
--- @param self MoveToHue the template class for this command
--- @param device ZigbeeDevice the device to build this message to
--- @param hue Uint8
--- @param direction st.zigbee.zcl.clusters.ColorControl.types.CcDirection
--- @param transition_time Uint16
--- @param options_mask st.zigbee.zcl.clusters.ColorControl.types.CcColorOptions
--- @param options_override st.zigbee.zcl.clusters.ColorControl.types.CcColorOptions
--- @return ZigbeeMessageTx the full command addressed to the device
function MoveToHue:init(device, hue, direction, transition_time, options_mask, options_override)
  local out = {}
  local args = {hue, direction, transition_time, options_mask, options_override}
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
    __index = MoveToHue,
    __tostring = MoveToHue.pretty_print
  })
  out:set_field_names()
  return self._cluster:build_cluster_specific_command(device, out, "server")
end

function MoveToHue:set_parent_cluster(cluster)
  self._cluster = cluster
  return self
end

setmetatable(MoveToHue, {__call = MoveToHue.init})

return MoveToHue
