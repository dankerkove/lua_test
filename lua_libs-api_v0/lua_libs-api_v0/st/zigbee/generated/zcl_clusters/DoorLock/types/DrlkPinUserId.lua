-- DO NOT EDIT: this code is automatically generated by tools/zigbee-lib_generator/generate_clusters_from_xml.py
-- Script version: b'2cda4a8ebeb3328f48b89dd179d4e8623e7ad8f1'
-- ZCL XML version: 7.2

local data_types = require "st.zigbee.data_types"
local UintABC = require "st.zigbee.data_types.base_defs.UintABC"

-- THIS CODE IS AUTOMATICALLY GENERATED by tools/generate_clusters_from_xml.py.  DO NOT MANUALLY EDIT.

--- @class st.zigbee.zcl.clusters.DoorLock.types.DrlkPinUserId : Uint16
---
local DrlkPinUserId = {}
local new_mt = UintABC.new_mt({NAME = "DrlkPinUserId", ID = data_types.name_to_id_map["Uint16"]}, 2)
setmetatable(DrlkPinUserId, new_mt)
return DrlkPinUserId
