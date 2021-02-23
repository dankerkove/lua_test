local data_types = require "st.zigbee.data_types"
local EnumABC = require "st.zigbee.data_types.base_defs.EnumABC"

-- DO NOT EDIT: this code is automatically generated by tools/zigbee-lib_generator/generate_clusters_from_xml.py
-- Script version: b'2cda4a8ebeb3328f48b89dd179d4e8623e7ad8f1'
-- ZCL XML version: 7.2

--- @class st.zigbee.zcl.clusters.DoorLock.types.EventType : EnumABC
--- @alias EventType
---
--- @field public byte_length number 1
--- @field public OPERATION number 0
--- @field public PROGRAMMING number 1
--- @field public ALARM number 2
local EventType = {}
local new_mt = EnumABC.new_mt({NAME = "EventType", ID = data_types.name_to_id_map["Enum8"]}, 1)
new_mt.__index.pretty_print = function(self)
  local name_lookup = {
    [self.OPERATION]   = "OPERATION",
    [self.PROGRAMMING] = "PROGRAMMING",
    [self.ALARM]       = "ALARM",
  }
  return string.format("%s: %s", self.NAME or self.field_name, name_lookup[self.value] or string.format("%d", self.value))
end
new_mt.__tostring = new_mt.__index.pretty_print
new_mt.__index.OPERATION   = 0x00
new_mt.__index.PROGRAMMING = 0x01
new_mt.__index.ALARM       = 0x02

setmetatable(EventType, new_mt)

return EventType
