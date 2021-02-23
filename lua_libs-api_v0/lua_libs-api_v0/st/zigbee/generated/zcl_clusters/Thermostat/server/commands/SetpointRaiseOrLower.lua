local data_types = require "st.zigbee.data_types"
local utils = require "st.zigbee.utils"
--- @type Mode
--- @alias ModeType
local ModeType = require "st.zigbee.generated.zcl_clusters.Thermostat.types.Mode"

-- DO NOT EDIT: this code is automatically generated by tools/zigbee-lib_generator/generate_clusters_from_xml.py
-- Script version: b'2cda4a8ebeb3328f48b89dd179d4e8623e7ad8f1'
-- ZCL XML version: 7.2

-----------------------------------------------------------
-- Thermostat command SetpointRaiseOrLower
-----------------------------------------------------------

--- @class st.zigbee.zcl.clusters.Thermostat.SetpointRaiseOrLower
--- @alias SetpointRaiseOrLower
---
--- @field public ID number 0x00 the ID of this command
--- @field public NAME string "SetpointRaiseOrLower" the name of this command
--- @field public mode st.zigbee.zcl.clusters.Thermostat.Mode
--- @field public amount Int8
local SetpointRaiseOrLower = {}
SetpointRaiseOrLower.NAME = "SetpointRaiseOrLower"
SetpointRaiseOrLower.ID = 0x00
SetpointRaiseOrLower.args_def = {
  {
    name = "mode",
    optional = false,
    data_type = ModeType,
    is_complex = false,
  },
  {
    name = "amount",
    optional = false,
    data_type = data_types.Int8,
    is_complex = false,
    default = 0x00,
  },
}

function SetpointRaiseOrLower:get_fields()
  local fields = {}
  for _, v in ipairs(self.args_def) do
    if self[v.name] ~= nil then
      fields[#fields + 1] = self[v.name]
    end
  end
  return fields
end

SetpointRaiseOrLower.get_length = utils.length_from_fields
SetpointRaiseOrLower.serialize = utils.serialize_from_fields
SetpointRaiseOrLower.pretty_print = utils.print_from_fields

--- Deserialize this command
---
--- @param buf buf the bytes of the command body
--- @return SetpointRaiseOrLower
function SetpointRaiseOrLower.deserialize(buf)
  local out = {}
  for _, v in ipairs(SetpointRaiseOrLower.args_def) do
    if not v.optional or buf:remain() > 0 then
      out[v.name] = v.data_type.deserialize(buf)
    end
  end
  setmetatable(out, {__index = SetpointRaiseOrLower})
  out:set_field_names()
  return out
end

function SetpointRaiseOrLower:set_field_names()
  for _, v in ipairs(self.args_def) do
    if self[v.name] ~= nil then
      self[v.name].field_name = v.name
    end
  end
end

--- Build a version of this message as if it came from the device
---
--- @param device ZigbeeDevice the device to build the message from
--- @param mode st.zigbee.zcl.clusters.Thermostat.Mode
--- @param amount Int8
--- @return ZigbeeMessageRx The full Zigbee message containing this command body
function SetpointRaiseOrLower.build_test_rx(device, mode, amount)
  local out = {}
  local args = {mode, amount}
  for i,v in ipairs(SetpointRaiseOrLower.args_def) do
    if v.optional and args[i] == nil then
      out[v.name] = nil
    elseif not v.optional and args[i] == nil then
      out[v.name] = data_types.validate_or_build_type(v.default, v.data_type, v.name)   
    else
      out[v.name] = data_types.validate_or_build_type(args[i], v.data_type, v.name)
    end
  end
  setmetatable(out, {__index = SetpointRaiseOrLower})
  out:set_field_names()
  return SetpointRaiseOrLower._cluster:build_test_rx_cluster_specific_command(device, out, "server")
end

--- Initialize the SetpointRaiseOrLower command
---
--- @param self SetpointRaiseOrLower the template class for this command
--- @param device ZigbeeDevice the device to build this message to
--- @param mode st.zigbee.zcl.clusters.Thermostat.Mode
--- @param amount Int8
--- @return ZigbeeMessageTx the full command addressed to the device
function SetpointRaiseOrLower:init(device, mode, amount)
  local out = {}
  local args = {mode, amount}
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
    __index = SetpointRaiseOrLower,
    __tostring = SetpointRaiseOrLower.pretty_print
  })
  out:set_field_names()
  return self._cluster:build_cluster_specific_command(device, out, "server")
end

function SetpointRaiseOrLower:set_parent_cluster(cluster)
  self._cluster = cluster
  return self
end

setmetatable(SetpointRaiseOrLower, {__call = SetpointRaiseOrLower.init})

return SetpointRaiseOrLower
