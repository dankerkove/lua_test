
local constants = {}

constants.HA_PROFILE_ID = 0x0104
constants.ZLL_PROFILE_ID = 0xC05E
constants.SMARTHINGS_PROFILE_ID = 0xFC01
constants.ZDO_PROFILE_ID = 0x0000
constants.DEFAULT_ENDPOINT = 0x00
constants.ZIGBEE_DEVICE_POWER_MULTIPLIER = "_power_multiplier"
constants.ZIGBEE_DEVICE_POWER_DIVISOR = "_power_divisor"
constants.ZIGBEE_DEVICE_ENERGY_MULTIPLIER = "_energy_multiplier"
constants.ZIGBEE_DEVICE_ENERGY_DIVISOR = "_energy_divisor"
constants.ZIGBEE_DEVICE_CONFIGURED_KEY = "_device_configured"

--- @class IAS_ZONE_CONFIGURE_TYPE
--- @field public CUSTOM number 0
--- @field public AUTO_ENROLL_RESPONSE number 1
--- @field public TRIP_TO_PAIR number 2
--- @field public AUTO_ENROLL_REQUEST number 3
constants.IAS_ZONE_CONFIGURE_TYPE = {
  CUSTOM = 0,
  AUTO_ENROLL_RESPONSE = 1,
  TRIP_TO_PAIR = 2,
  AUTO_ENROLL_REQUEST = 3,
}

constants.HUB = {
  ADDR = 0x0000,
  ENDPOINT = 0x01
}

return constants