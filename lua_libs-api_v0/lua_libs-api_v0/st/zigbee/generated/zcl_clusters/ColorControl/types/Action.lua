local data_types = require "st.zigbee.data_types"
local EnumABC = require "st.zigbee.data_types.base_defs.EnumABC"

-- DO NOT EDIT: this code is automatically generated by tools/zigbee-lib_generator/generate_clusters_from_xml.py
-- Script version: b'2cda4a8ebeb3328f48b89dd179d4e8623e7ad8f1'
-- ZCL XML version: 7.2

--- @class st.zigbee.zcl.clusters.ColorControl.types.Action : EnumABC
--- @alias Action
---
--- @field public byte_length number 1
--- @field public DEACTIVATE_COLOR_LOOP number 0
--- @field public ACTIVATE_COLOR_LOOP_FROM_COLOR_LOOP_START_ENHANCED_HUE number 1
--- @field public ACTIVATE_COLOR_LOOP_FROM_ENHANCED_CURRENT_HUE number 2
local Action = {}
local new_mt = EnumABC.new_mt({NAME = "Action", ID = data_types.name_to_id_map["Enum8"]}, 1)
new_mt.__index.pretty_print = function(self)
  local name_lookup = {
    [self.DEACTIVATE_COLOR_LOOP]                                  = "DEACTIVATE_COLOR_LOOP",
    [self.ACTIVATE_COLOR_LOOP_FROM_COLOR_LOOP_START_ENHANCED_HUE] = "ACTIVATE_COLOR_LOOP_FROM_COLOR_LOOP_START_ENHANCED_HUE",
    [self.ACTIVATE_COLOR_LOOP_FROM_ENHANCED_CURRENT_HUE]          = "ACTIVATE_COLOR_LOOP_FROM_ENHANCED_CURRENT_HUE",
  }
  return string.format("%s: %s", self.NAME or self.field_name, name_lookup[self.value] or string.format("%d", self.value))
end
new_mt.__tostring = new_mt.__index.pretty_print
new_mt.__index.DEACTIVATE_COLOR_LOOP                                  = 0x00
new_mt.__index.ACTIVATE_COLOR_LOOP_FROM_COLOR_LOOP_START_ENHANCED_HUE = 0x01
new_mt.__index.ACTIVATE_COLOR_LOOP_FROM_ENHANCED_CURRENT_HUE          = 0x02

setmetatable(Action, new_mt)

return Action
