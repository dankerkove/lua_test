local data_types = require "st.zigbee.data_types"
local UintABC = require "st.zigbee.data_types.base_defs.UintABC"

-- DO NOT EDIT: this code is automatically generated by tools/zigbee-lib_generator/generate_clusters_from_xml.py
-- Script version: b'2cda4a8ebeb3328f48b89dd179d4e8623e7ad8f1'
-- ZCL XML version: 7.2

--- @class st.zigbee.zcl.clusters.DoorLock.types.OperationEventCode : UintABC
--- @alias OperationEventCode
---
--- @field public byte_length number 1
--- @field public UNKNOWN_OR_MS number 0
--- @field public LOCK number 1
--- @field public UNLOCK number 2
--- @field public LOCK_FAILURE_INVALID_PIN_OR_ID number 3
--- @field public LOCK_FAILURE_INVALID_SCHEDULE number 4
--- @field public UNLOCK_FAILURE_INVALID_PIN_OR_ID number 5
--- @field public UNLOCK_FAILURE_INVALID_SCHEDULE number 6
--- @field public ONE_TOUCH_LOCK number 7
--- @field public KEY_LOCK number 8
--- @field public KEY_UNLOCK number 9
--- @field public AUTO_LOCK number 10
--- @field public SCHEDULE_LOCK number 11
--- @field public SCHEDULE_UNLOCK number 12
--- @field public MANUAL_LOCK number 13
--- @field public MANUAL_UNLOCK number 14
--- @field public NON_ACCESS_USER_OPERATIONAL_EVENT number 14
local OperationEventCode = {}
local new_mt = UintABC.new_mt({NAME = "OperationEventCode", ID = data_types.name_to_id_map["Uint8"]}, 1)
new_mt.__index.pretty_print = function(self)
  local name_lookup = {
    [self.UNKNOWN_OR_MS]                     = "UNKNOWN_OR_MS",
    [self.LOCK]                              = "LOCK",
    [self.UNLOCK]                            = "UNLOCK",
    [self.LOCK_FAILURE_INVALID_PIN_OR_ID]    = "LOCK_FAILURE_INVALID_PIN_OR_ID",
    [self.LOCK_FAILURE_INVALID_SCHEDULE]     = "LOCK_FAILURE_INVALID_SCHEDULE",
    [self.UNLOCK_FAILURE_INVALID_PIN_OR_ID]  = "UNLOCK_FAILURE_INVALID_PIN_OR_ID",
    [self.UNLOCK_FAILURE_INVALID_SCHEDULE]   = "UNLOCK_FAILURE_INVALID_SCHEDULE",
    [self.ONE_TOUCH_LOCK]                    = "ONE_TOUCH_LOCK",
    [self.KEY_LOCK]                          = "KEY_LOCK",
    [self.KEY_UNLOCK]                        = "KEY_UNLOCK",
    [self.AUTO_LOCK]                         = "AUTO_LOCK",
    [self.SCHEDULE_LOCK]                     = "SCHEDULE_LOCK",
    [self.SCHEDULE_UNLOCK]                   = "SCHEDULE_UNLOCK",
    [self.MANUAL_LOCK]                       = "MANUAL_LOCK",
    [self.MANUAL_UNLOCK]                     = "MANUAL_UNLOCK",
    [self.NON_ACCESS_USER_OPERATIONAL_EVENT] = "NON_ACCESS_USER_OPERATIONAL_EVENT",
  }
  return string.format("%s: %s", self.NAME or self.field_name, name_lookup[self.value] or string.format("%d", self.value))
end
new_mt.__tostring = new_mt.__index.pretty_print
new_mt.__index.UNKNOWN_OR_MS                     = 0x00
new_mt.__index.LOCK                              = 0x01
new_mt.__index.UNLOCK                            = 0x02
new_mt.__index.LOCK_FAILURE_INVALID_PIN_OR_ID    = 0x03
new_mt.__index.LOCK_FAILURE_INVALID_SCHEDULE     = 0x04
new_mt.__index.UNLOCK_FAILURE_INVALID_PIN_OR_ID  = 0x05
new_mt.__index.UNLOCK_FAILURE_INVALID_SCHEDULE   = 0x06
new_mt.__index.ONE_TOUCH_LOCK                    = 0x07
new_mt.__index.KEY_LOCK                          = 0x08
new_mt.__index.KEY_UNLOCK                        = 0x09
new_mt.__index.AUTO_LOCK                         = 0x0A
new_mt.__index.SCHEDULE_LOCK                     = 0x0B
new_mt.__index.SCHEDULE_UNLOCK                   = 0x0C
new_mt.__index.MANUAL_LOCK                       = 0x0D
new_mt.__index.MANUAL_UNLOCK                     = 0x0E
new_mt.__index.NON_ACCESS_USER_OPERATIONAL_EVENT = 0x0E

setmetatable(OperationEventCode, new_mt)

return OperationEventCode
