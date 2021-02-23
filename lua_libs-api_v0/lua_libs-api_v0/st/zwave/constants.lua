--- @class st.zwave.constants
--- @alias constants
--- @field public TEMPERATURE_SCALE string
--- @field public DEFAULT_DIMMING_DURATION number
--- @field public DEFAULT_POST_DIMMING_DELAY number
--- @field public MIN_DIMMING_GET_STATUS_DELAY number
--- @field public DEFAULT_GET_STATUS_DELAY number
local constants = {}

constants.TEMPERATURE_SCALE = "_temperature_scale"
constants.DEFAULT_DIMMING_DURATION = 1 --seconds
constants.DEFAULT_POST_DIMMING_DELAY = 2 --seconds
constants.MIN_DIMMING_GET_STATUS_DELAY = 5 --seconds
constants.DEFAULT_GET_STATUS_DELAY = 1 --seconds

return constants
