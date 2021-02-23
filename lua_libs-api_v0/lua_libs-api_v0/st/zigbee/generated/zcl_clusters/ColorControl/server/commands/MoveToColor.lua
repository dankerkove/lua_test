local data_types = require "st.zigbee.data_types"
local utils = require "st.zigbee.utils"
--- @type CcColorOptions
--- @alias CcColorOptionsType
local CcColorOptionsType = require "st.zigbee.generated.zcl_clusters.ColorControl.types.CcColorOptions"

-- DO NOT EDIT: this code is automatically generated by tools/zigbee-lib_generator/generate_clusters_from_xml.py
-- Script version: b'2cda4a8ebeb3328f48b89dd179d4e8623e7ad8f1'
-- ZCL XML version: 7.2

-----------------------------------------------------------
-- ColorControl command MoveToColor
-----------------------------------------------------------

--- @class st.zigbee.zcl.clusters.ColorControl.MoveToColor
--- @alias MoveToColor
---
--- @field public ID number 0x07 the ID of this command
--- @field public NAME string "MoveToColor" the name of this command
--- @field public color_x Uint16
--- @field public color_y Uint16
--- @field public transition_time Uint16
--- @field public options_mask st.zigbee.zcl.clusters.ColorControl.types.CcColorOptions
--- @field public options_override st.zigbee.zcl.clusters.ColorControl.types.CcColorOptions
local MoveToColor = {}
MoveToColor.NAME = "MoveToColor"
MoveToColor.ID = 0x07
MoveToColor.args_def = {
  {
    name = "color_x",
    optional = false,
    data_type = data_types.Uint16,
    is_complex = false,
    default = 0x0000,
  },
  {
    name = "color_y",
    optional = false,
    data_type = data_types.Uint16,
    is_complex = false,
    default = 0x0000,
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

function MoveToColor:get_fields()
  local fields = {}
  for _, v in ipairs(self.args_def) do
    if self[v.name] ~= nil then
      fields[#fields + 1] = self[v.name]
    end
  end
  return fields
end

MoveToColor.get_length = utils.length_from_fields
MoveToColor.serialize = utils.serialize_from_fields
MoveToColor.pretty_print = utils.print_from_fields

--- Deserialize this command
---
--- @param buf buf the bytes of the command body
--- @return MoveToColor
function MoveToColor.deserialize(buf)
  local out = {}
  for _, v in ipairs(MoveToColor.args_def) do
    if not v.optional or buf:remain() > 0 then
      out[v.name] = v.data_type.deserialize(buf)
    end
  end
  setmetatable(out, {__index = MoveToColor})
  out:set_field_names()
  return out
end

function MoveToColor:set_field_names()
  for _, v in ipairs(self.args_def) do
    if self[v.name] ~= nil then
      self[v.name].field_name = v.name
    end
  end
end

--- Build a version of this message as if it came from the device
---
--- @param device ZigbeeDevice the device to build the message from
--- @param color_x Uint16
--- @param color_y Uint16
--- @param transition_time Uint16
--- @param options_mask st.zigbee.zcl.clusters.ColorControl.types.CcColorOptions
--- @param options_override st.zigbee.zcl.clusters.ColorControl.types.CcColorOptions
--- @return ZigbeeMessageRx The full Zigbee message containing this command body
function MoveToColor.build_test_rx(device, color_x, color_y, transition_time, options_mask, options_override)
  local out = {}
  local args = {color_x, color_y, transition_time, options_mask, options_override}
  for i,v in ipairs(MoveToColor.args_def) do
    if v.optional and args[i] == nil then
      out[v.name] = nil
    elseif not v.optional and args[i] == nil then
      out[v.name] = data_types.validate_or_build_type(v.default, v.data_type, v.name)   
    else
      out[v.name] = data_types.validate_or_build_type(args[i], v.data_type, v.name)
    end
  end
  setmetatable(out, {__index = MoveToColor})
  out:set_field_names()
  return MoveToColor._cluster:build_test_rx_cluster_specific_command(device, out, "server")
end

--- Initialize the MoveToColor command
---
--- @param self MoveToColor the template class for this command
--- @param device ZigbeeDevice the device to build this message to
--- @param color_x Uint16
--- @param color_y Uint16
--- @param transition_time Uint16
--- @param options_mask st.zigbee.zcl.clusters.ColorControl.types.CcColorOptions
--- @param options_override st.zigbee.zcl.clusters.ColorControl.types.CcColorOptions
--- @return ZigbeeMessageTx the full command addressed to the device
function MoveToColor:init(device, color_x, color_y, transition_time, options_mask, options_override)
  local out = {}
  local args = {color_x, color_y, transition_time, options_mask, options_override}
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
    __index = MoveToColor,
    __tostring = MoveToColor.pretty_print
  })
  out:set_field_names()
  return self._cluster:build_cluster_specific_command(device, out, "server")
end

function MoveToColor:set_parent_cluster(cluster)
  self._cluster = cluster
  return self
end

setmetatable(MoveToColor, {__call = MoveToColor.init})

return MoveToColor
