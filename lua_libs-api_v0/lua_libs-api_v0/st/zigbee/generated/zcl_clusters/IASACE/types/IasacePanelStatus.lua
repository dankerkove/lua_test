local data_types = require "st.zigbee.data_types"
local EnumABC = require "st.zigbee.data_types.base_defs.EnumABC"

-- DO NOT EDIT: this code is automatically generated by tools/zigbee-lib_generator/generate_clusters_from_xml.py
-- Script version: b'2cda4a8ebeb3328f48b89dd179d4e8623e7ad8f1'
-- ZCL XML version: 7.2

--- @class st.zigbee.zcl.clusters.IASACE.types.IasacePanelStatus : EnumABC
--- @alias IasacePanelStatus
---
--- @field public byte_length number 1
--- @field public PANEL_DISARMED_READY_TO_ARM number 0
--- @field public ARMED_STAY number 1
--- @field public ARMED_NIGHT number 2
--- @field public ARMED_AWAY number 3
--- @field public EXIT_DELAY number 4
--- @field public ENTRY_DELAY number 5
--- @field public NOT_READY_TO_ARM number 6
--- @field public IN_ALARM number 7
--- @field public ARMING_STAY number 8
--- @field public ARMING_NIGHT number 9
--- @field public ARMING_AWAY number 10
local IasacePanelStatus = {}
local new_mt = EnumABC.new_mt({NAME = "IasacePanelStatus", ID = data_types.name_to_id_map["Enum8"]}, 1)
new_mt.__index.pretty_print = function(self)
  local name_lookup = {
    [self.PANEL_DISARMED_READY_TO_ARM] = "PANEL_DISARMED_READY_TO_ARM",
    [self.ARMED_STAY]                  = "ARMED_STAY",
    [self.ARMED_NIGHT]                 = "ARMED_NIGHT",
    [self.ARMED_AWAY]                  = "ARMED_AWAY",
    [self.EXIT_DELAY]                  = "EXIT_DELAY",
    [self.ENTRY_DELAY]                 = "ENTRY_DELAY",
    [self.NOT_READY_TO_ARM]            = "NOT_READY_TO_ARM",
    [self.IN_ALARM]                    = "IN_ALARM",
    [self.ARMING_STAY]                 = "ARMING_STAY",
    [self.ARMING_NIGHT]                = "ARMING_NIGHT",
    [self.ARMING_AWAY]                 = "ARMING_AWAY",
  }
  return string.format("%s: %s", self.NAME or self.field_name, name_lookup[self.value] or string.format("%d", self.value))
end
new_mt.__tostring = new_mt.__index.pretty_print
new_mt.__index.PANEL_DISARMED_READY_TO_ARM = 0x00
new_mt.__index.ARMED_STAY                  = 0x01
new_mt.__index.ARMED_NIGHT                 = 0x02
new_mt.__index.ARMED_AWAY                  = 0x03
new_mt.__index.EXIT_DELAY                  = 0x04
new_mt.__index.ENTRY_DELAY                 = 0x05
new_mt.__index.NOT_READY_TO_ARM            = 0x06
new_mt.__index.IN_ALARM                    = 0x07
new_mt.__index.ARMING_STAY                 = 0x08
new_mt.__index.ARMING_NIGHT                = 0x09
new_mt.__index.ARMING_AWAY                 = 0x0A

setmetatable(IasacePanelStatus, new_mt)

return IasacePanelStatus
