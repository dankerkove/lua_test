local data_types = require "st.zigbee.data_types"
local utils = require "st.zigbee.utils"

-- DO NOT EDIT: this code is automatically generated by tools/zigbee-lib_generator/generate_clusters_from_xml.py
-- Script version: b'2cda4a8ebeb3328f48b89dd179d4e8623e7ad8f1'
-- ZCL XML version: 7.2

-----------------------------------------------------------
-- PollControl command SetLongPollInterval
-----------------------------------------------------------

--- @class st.zigbee.zcl.clusters.PollControl.SetLongPollInterval
--- @alias SetLongPollInterval
---
--- @field public ID number 0x02 the ID of this command
--- @field public NAME string "SetLongPollInterval" the name of this command
--- @field public new_long_poll_interval Uint32
local SetLongPollInterval = {}
SetLongPollInterval.NAME = "SetLongPollInterval"
SetLongPollInterval.ID = 0x02
SetLongPollInterval.args_def = {
  {
    name = "new_long_poll_interval",
    optional = false,
    data_type = data_types.Uint32,
    is_complex = false,
    default = 0x00000000,
  },
}

function SetLongPollInterval:get_fields()
  local fields = {}
  for _, v in ipairs(self.args_def) do
    if self[v.name] ~= nil then
      fields[#fields + 1] = self[v.name]
    end
  end
  return fields
end

SetLongPollInterval.get_length = utils.length_from_fields
SetLongPollInterval.serialize = utils.serialize_from_fields
SetLongPollInterval.pretty_print = utils.print_from_fields

--- Deserialize this command
---
--- @param buf buf the bytes of the command body
--- @return SetLongPollInterval
function SetLongPollInterval.deserialize(buf)
  local out = {}
  for _, v in ipairs(SetLongPollInterval.args_def) do
    if not v.optional or buf:remain() > 0 then
      out[v.name] = v.data_type.deserialize(buf)
    end
  end
  setmetatable(out, {__index = SetLongPollInterval})
  out:set_field_names()
  return out
end

function SetLongPollInterval:set_field_names()
  for _, v in ipairs(self.args_def) do
    if self[v.name] ~= nil then
      self[v.name].field_name = v.name
    end
  end
end

--- Build a version of this message as if it came from the device
---
--- @param device ZigbeeDevice the device to build the message from
--- @param new_long_poll_interval Uint32
--- @return ZigbeeMessageRx The full Zigbee message containing this command body
function SetLongPollInterval.build_test_rx(device, new_long_poll_interval)
  local out = {}
  local args = {new_long_poll_interval}
  for i,v in ipairs(SetLongPollInterval.args_def) do
    if v.optional and args[i] == nil then
      out[v.name] = nil
    elseif not v.optional and args[i] == nil then
      out[v.name] = data_types.validate_or_build_type(v.default, v.data_type, v.name)   
    else
      out[v.name] = data_types.validate_or_build_type(args[i], v.data_type, v.name)
    end
  end
  setmetatable(out, {__index = SetLongPollInterval})
  out:set_field_names()
  return SetLongPollInterval._cluster:build_test_rx_cluster_specific_command(device, out, "client")
end

--- Initialize the SetLongPollInterval command
---
--- @param self SetLongPollInterval the template class for this command
--- @param device ZigbeeDevice the device to build this message to
--- @param new_long_poll_interval Uint32
--- @return ZigbeeMessageTx the full command addressed to the device
function SetLongPollInterval:init(device, new_long_poll_interval)
  local out = {}
  local args = {new_long_poll_interval}
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
    __index = SetLongPollInterval,
    __tostring = SetLongPollInterval.pretty_print
  })
  out:set_field_names()
  return self._cluster:build_cluster_specific_command(device, out, "client")
end

function SetLongPollInterval:set_parent_cluster(cluster)
  self._cluster = cluster
  return self
end

setmetatable(SetLongPollInterval, {__call = SetLongPollInterval.init})

return SetLongPollInterval
