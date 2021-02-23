local data_types = require "st.zigbee.data_types"
local utils = require "st.zigbee.utils"
--- @type CcColorOptions
--- @alias CcColorOptionsType
local CcColorOptionsType = require "st.zigbee.generated.zcl_clusters.ColorControl.types.CcColorOptions"
--- @type CcMoveMode
--- @alias CcMoveModeType
local CcMoveModeType = require "st.zigbee.generated.zcl_clusters.ColorControl.types.CcMoveMode"

-- DO NOT EDIT: this code is automatically generated by tools/zigbee-lib_generator/generate_clusters_from_xml.py
-- Script version: b'2cda4a8ebeb3328f48b89dd179d4e8623e7ad8f1'
-- ZCL XML version: 7.2

-----------------------------------------------------------
-- ColorControl command MoveSaturation
-----------------------------------------------------------

--- @class st.zigbee.zcl.clusters.ColorControl.MoveSaturation
--- @alias MoveSaturation
---
--- @field public ID number 0x04 the ID of this command
--- @field public NAME string "MoveSaturation" the name of this command
--- @field public move_mode st.zigbee.zcl.clusters.ColorControl.types.CcMoveMode
--- @field public rate Uint8
--- @field public options_mask st.zigbee.zcl.clusters.ColorControl.types.CcColorOptions
--- @field public options_override st.zigbee.zcl.clusters.ColorControl.types.CcColorOptions
local MoveSaturation = {}
MoveSaturation.NAME = "MoveSaturation"
MoveSaturation.ID = 0x04
MoveSaturation.args_def = {
  {
    name = "move_mode",
    optional = false,
    data_type = CcMoveModeType,
    is_complex = false,
    default = 0x00,
  },
  {
    name = "rate",
    optional = false,
    data_type = data_types.Uint8,
    is_complex = false,
    default = 0x00,
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

function MoveSaturation:get_fields()
  local fields = {}
  for _, v in ipairs(self.args_def) do
    if self[v.name] ~= nil then
      fields[#fields + 1] = self[v.name]
    end
  end
  return fields
end

MoveSaturation.get_length = utils.length_from_fields
MoveSaturation.serialize = utils.serialize_from_fields
MoveSaturation.pretty_print = utils.print_from_fields

--- Deserialize this command
---
--- @param buf buf the bytes of the command body
--- @return MoveSaturation
function MoveSaturation.deserialize(buf)
  local out = {}
  for _, v in ipairs(MoveSaturation.args_def) do
    if not v.optional or buf:remain() > 0 then
      out[v.name] = v.data_type.deserialize(buf)
    end
  end
  setmetatable(out, {__index = MoveSaturation})
  out:set_field_names()
  return out
end

function MoveSaturation:set_field_names()
  for _, v in ipairs(self.args_def) do
    if self[v.name] ~= nil then
      self[v.name].field_name = v.name
    end
  end
end

--- Build a version of this message as if it came from the device
---
--- @param device ZigbeeDevice the device to build the message from
--- @param move_mode st.zigbee.zcl.clusters.ColorControl.types.CcMoveMode
--- @param rate Uint8
--- @param options_mask st.zigbee.zcl.clusters.ColorControl.types.CcColorOptions
--- @param options_override st.zigbee.zcl.clusters.ColorControl.types.CcColorOptions
--- @return ZigbeeMessageRx The full Zigbee message containing this command body
function MoveSaturation.build_test_rx(device, move_mode, rate, options_mask, options_override)
  local out = {}
  local args = {move_mode, rate, options_mask, options_override}
  for i,v in ipairs(MoveSaturation.args_def) do
    if v.optional and args[i] == nil then
      out[v.name] = nil
    elseif not v.optional and args[i] == nil then
      out[v.name] = data_types.validate_or_build_type(v.default, v.data_type, v.name)   
    else
      out[v.name] = data_types.validate_or_build_type(args[i], v.data_type, v.name)
    end
  end
  setmetatable(out, {__index = MoveSaturation})
  out:set_field_names()
  return MoveSaturation._cluster:build_test_rx_cluster_specific_command(device, out, "server")
end

--- Initialize the MoveSaturation command
---
--- @param self MoveSaturation the template class for this command
--- @param device ZigbeeDevice the device to build this message to
--- @param move_mode st.zigbee.zcl.clusters.ColorControl.types.CcMoveMode
--- @param rate Uint8
--- @param options_mask st.zigbee.zcl.clusters.ColorControl.types.CcColorOptions
--- @param options_override st.zigbee.zcl.clusters.ColorControl.types.CcColorOptions
--- @return ZigbeeMessageTx the full command addressed to the device
function MoveSaturation:init(device, move_mode, rate, options_mask, options_override)
  local out = {}
  local args = {move_mode, rate, options_mask, options_override}
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
    __index = MoveSaturation,
    __tostring = MoveSaturation.pretty_print
  })
  out:set_field_names()
  return self._cluster:build_cluster_specific_command(device, out, "server")
end

function MoveSaturation:set_parent_cluster(cluster)
  self._cluster = cluster
  return self
end

setmetatable(MoveSaturation, {__call = MoveSaturation.init})

return MoveSaturation
