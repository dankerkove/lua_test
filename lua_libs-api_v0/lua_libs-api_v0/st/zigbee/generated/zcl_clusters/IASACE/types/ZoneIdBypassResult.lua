local data_types = require "st.zigbee.data_types"
local UintABC = require "st.zigbee.data_types.base_defs.UintABC"

-- DO NOT EDIT: this code is automatically generated by tools/zigbee-lib_generator/generate_clusters_from_xml.py
-- Script version: b'2cda4a8ebeb3328f48b89dd179d4e8623e7ad8f1'
-- ZCL XML version: 7.2

--- @class st.zigbee.zcl.clusters.IASACE.types.ZoneIdBypassResult : UintABC
--- @alias ZoneIdBypassResult
---
--- @field public byte_length number 1
--- @field public ZONE_BYPASSED number 0
--- @field public ZONE_NOT_BYPASSED number 1
--- @field public NOT_ALLOWED number 2
--- @field public INVALID_ZONE_ID number 3
--- @field public UNKNOWN_ZONE_ID number 4
--- @field public INVALID_ARM_DISARM_CODE number 5
local ZoneIdBypassResult = {}
local new_mt = UintABC.new_mt({NAME = "ZoneIdBypassResult", ID = data_types.name_to_id_map["Uint8"]}, 1)
new_mt.__index.pretty_print = function(self)
  local name_lookup = {
    [self.ZONE_BYPASSED]           = "ZONE_BYPASSED",
    [self.ZONE_NOT_BYPASSED]       = "ZONE_NOT_BYPASSED",
    [self.NOT_ALLOWED]             = "NOT_ALLOWED",
    [self.INVALID_ZONE_ID]         = "INVALID_ZONE_ID",
    [self.UNKNOWN_ZONE_ID]         = "UNKNOWN_ZONE_ID",
    [self.INVALID_ARM_DISARM_CODE] = "INVALID_ARM_DISARM_CODE",
  }
  return string.format("%s: %s", self.NAME or self.field_name, name_lookup[self.value] or string.format("%d", self.value))
end
new_mt.__tostring = new_mt.__index.pretty_print
new_mt.__index.ZONE_BYPASSED           = 0x00
new_mt.__index.ZONE_NOT_BYPASSED       = 0x01
new_mt.__index.NOT_ALLOWED             = 0x02
new_mt.__index.INVALID_ZONE_ID         = 0x03
new_mt.__index.UNKNOWN_ZONE_ID         = 0x04
new_mt.__index.INVALID_ARM_DISARM_CODE = 0x05

setmetatable(ZoneIdBypassResult, new_mt)

return ZoneIdBypassResult
