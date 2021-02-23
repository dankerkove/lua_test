local data_types = require "st.zigbee.data_types"
local utils = require "st.zigbee.utils"

-- DO NOT EDIT: this code is automatically generated by tools/zigbee-lib_generator/generate_clusters_from_xml.py
-- Script version: b'2cda4a8ebeb3328f48b89dd179d4e8623e7ad8f1'
-- ZCL XML version: 7.2

-----------------------------------------------------------
-- PollControl command CheckIn
-----------------------------------------------------------

--- @class st.zigbee.zcl.clusters.PollControl.CheckIn
--- @alias CheckIn
---
--- @field public ID number 0x00 the ID of this command
--- @field public NAME string "CheckIn" the name of this command
local CheckIn = {}
CheckIn.NAME = "CheckIn"
CheckIn.ID = 0x00
CheckIn.args_def = {}

function CheckIn:get_fields()
  local fields = {}
  for _, v in ipairs(self.args_def) do
    if self[v.name] ~= nil then
      fields[#fields + 1] = self[v.name]
    end
  end
  return fields
end

CheckIn.get_length = utils.length_from_fields
CheckIn.serialize = utils.serialize_from_fields
CheckIn.pretty_print = utils.print_from_fields

--- Deserialize this command
---
--- @param buf buf the bytes of the command body
--- @return CheckIn
function CheckIn.deserialize(buf)
  local out = {}
  for _, v in ipairs(CheckIn.args_def) do
    if not v.optional or buf:remain() > 0 then
      out[v.name] = v.data_type.deserialize(buf)
    end
  end
  setmetatable(out, {__index = CheckIn})
  out:set_field_names()
  return out
end

function CheckIn:set_field_names()
  for _, v in ipairs(self.args_def) do
    if self[v.name] ~= nil then
      self[v.name].field_name = v.name
    end
  end
end

--- Build a version of this message as if it came from the device
---
--- @param device ZigbeeDevice the device to build the message from
--- @return ZigbeeMessageRx The full Zigbee message containing this command body
function CheckIn.build_test_rx(device)
  local out = {}
  local args = {}
  for i,v in ipairs(CheckIn.args_def) do
    if v.optional and args[i] == nil then
      out[v.name] = nil
    elseif not v.optional and args[i] == nil then
      out[v.name] = data_types.validate_or_build_type(v.default, v.data_type, v.name)   
    else
      out[v.name] = data_types.validate_or_build_type(args[i], v.data_type, v.name)
    end
  end
  setmetatable(out, {__index = CheckIn})
  out:set_field_names()
  return CheckIn._cluster:build_test_rx_cluster_specific_command(device, out, "server")
end

--- Initialize the CheckIn command
---
--- @param self CheckIn the template class for this command
--- @param device ZigbeeDevice the device to build this message to
--- @return ZigbeeMessageTx the full command addressed to the device
function CheckIn:init(device)
  local out = {}
  local args = {}
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
    __index = CheckIn,
    __tostring = CheckIn.pretty_print
  })
  out:set_field_names()
  return self._cluster:build_cluster_specific_command(device, out, "server")
end

function CheckIn:set_parent_cluster(cluster)
  self._cluster = cluster
  return self
end

setmetatable(CheckIn, {__call = CheckIn.init})

return CheckIn
