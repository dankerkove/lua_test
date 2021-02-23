local data_types = require "st.zigbee.data_types"
local EnumABC = require "st.zigbee.data_types.base_defs.EnumABC"

-- DO NOT EDIT: this code is automatically generated by tools/zigbee-lib_generator/generate_clusters_from_xml.py
-- Script version: b'2cda4a8ebeb3328f48b89dd179d4e8623e7ad8f1'
-- ZCL XML version: 7.2

--- @class st.zigbee.zcl.clusters.IASWD.types.SquawkMode : EnumABC
--- @alias SquawkMode
---
--- @field public byte_length number 1
--- @field public SOUND_FOR_SYSTEM_IS_ARMED number 0
--- @field public SOUND_FOR_SYSTEM_IS_DISARMED number 1
local SquawkMode = {}
local new_mt = EnumABC.new_mt({NAME = "SquawkMode", ID = data_types.name_to_id_map["Enum8"]}, 1)
new_mt.__index.pretty_print = function(self)
  local name_lookup = {
    [self.SOUND_FOR_SYSTEM_IS_ARMED]    = "SOUND_FOR_SYSTEM_IS_ARMED",
    [self.SOUND_FOR_SYSTEM_IS_DISARMED] = "SOUND_FOR_SYSTEM_IS_DISARMED",
  }
  return string.format("%s: %s", self.NAME or self.field_name, name_lookup[self.value] or string.format("%d", self.value))
end
new_mt.__tostring = new_mt.__index.pretty_print
new_mt.__index.SOUND_FOR_SYSTEM_IS_ARMED    = 0x00
new_mt.__index.SOUND_FOR_SYSTEM_IS_DISARMED = 0x01

setmetatable(SquawkMode, new_mt)

return SquawkMode
