local data_types = require "st.zigbee.data_types"
local utils = require "st.zigbee.utils"

-- DO NOT EDIT: this code is automatically generated by tools/zigbee-lib_generator/generate_clusters_from_xml.py
-- Script version: b'2cda4a8ebeb3328f48b89dd179d4e8623e7ad8f1'
-- ZCL XML version: 7.2

-----------------------------------------------------------
-- DoorLock command UnlockDoor
-----------------------------------------------------------

--- @class st.zigbee.zcl.clusters.DoorLock.UnlockDoor
--- @alias UnlockDoor
---
--- @field public ID number 0x01 the ID of this command
--- @field public NAME string "UnlockDoor" the name of this command
--- @field public pin_or_rfid_code OctetString
local UnlockDoor = {}
UnlockDoor.NAME = "UnlockDoor"
UnlockDoor.ID = 0x01
UnlockDoor.args_def = {
  {
    name = "pin_or_rfid_code",
    optional = false,
    data_type = data_types.OctetString,
    is_complex = false,
    default = "",
  },
}

function UnlockDoor:get_fields()
  local fields = {}
  for _, v in ipairs(self.args_def) do
    if self[v.name] ~= nil then
      fields[#fields + 1] = self[v.name]
    end
  end
  return fields
end

UnlockDoor.get_length = utils.length_from_fields
UnlockDoor.serialize = utils.serialize_from_fields
UnlockDoor.pretty_print = utils.print_from_fields

--- Deserialize this command
---
--- @param buf buf the bytes of the command body
--- @return UnlockDoor
function UnlockDoor.deserialize(buf)
  local out = {}
  for _, v in ipairs(UnlockDoor.args_def) do
    if not v.optional or buf:remain() > 0 then
      out[v.name] = v.data_type.deserialize(buf)
    end
  end
  setmetatable(out, {__index = UnlockDoor})
  out:set_field_names()
  return out
end

function UnlockDoor:set_field_names()
  for _, v in ipairs(self.args_def) do
    if self[v.name] ~= nil then
      self[v.name].field_name = v.name
    end
  end
end

--- Build a version of this message as if it came from the device
---
--- @param device ZigbeeDevice the device to build the message from
--- @param pin_or_rfid_code OctetString
--- @return ZigbeeMessageRx The full Zigbee message containing this command body
function UnlockDoor.build_test_rx(device, pin_or_rfid_code)
  local out = {}
  local args = {pin_or_rfid_code}
  for i,v in ipairs(UnlockDoor.args_def) do
    if v.optional and args[i] == nil then
      out[v.name] = nil
    elseif not v.optional and args[i] == nil then
      out[v.name] = data_types.validate_or_build_type(v.default, v.data_type, v.name)   
    else
      out[v.name] = data_types.validate_or_build_type(args[i], v.data_type, v.name)
    end
  end
  setmetatable(out, {__index = UnlockDoor})
  out:set_field_names()
  return UnlockDoor._cluster:build_test_rx_cluster_specific_command(device, out, "server")
end

--- Initialize the UnlockDoor command
---
--- @param self UnlockDoor the template class for this command
--- @param device ZigbeeDevice the device to build this message to
--- @param pin_or_rfid_code OctetString
--- @return ZigbeeMessageTx the full command addressed to the device
function UnlockDoor:init(device, pin_or_rfid_code)
  local out = {}
  local args = {pin_or_rfid_code}
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
    __index = UnlockDoor,
    __tostring = UnlockDoor.pretty_print
  })
  out:set_field_names()
  return self._cluster:build_cluster_specific_command(device, out, "server")
end

function UnlockDoor:set_parent_cluster(cluster)
  self._cluster = cluster
  return self
end

setmetatable(UnlockDoor, {__call = UnlockDoor.init})

return UnlockDoor
