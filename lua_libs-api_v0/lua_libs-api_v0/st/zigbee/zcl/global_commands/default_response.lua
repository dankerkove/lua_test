--- @type data_types
local data_types = require "st.zigbee.data_types"
local utils = require "st.zigbee.utils"
local Status = require "st.zigbee.generated.types.ZclStatus"

--- @module default_response
local default_response = {}

default_response.DEFAULT_RESPONSE_ID = 0x0B

--- @class DefaultResponse
---
--- @field public NAME string "DefaultResponse"
--- @field public ID number 0x0B The ID of the DefaultResponse ZCL command
--- @field public cmd ZCLCommandId the command ID that this is in response to
--- @field public status Status The status of the command this is a response to
local DefaultResponse = {
  ID = default_response.DEFAULT_RESPONSE_ID,
  NAME = "DefaultResponse",
}
DefaultResponse.__index = DefaultResponse
default_response.DefaultResponse = DefaultResponse

--- Parse a DefaultResponse from a byte string
--- @param buf Reader the bufto parse the record from
--- @return DefaultResponse the parsed default response
function DefaultResponse.deserialize(buf)
  local self = {}
  setmetatable(self, DefaultResponse)
  local fields = {
    { name = "cmd", type = data_types.ZCLCommandId },
    { name = "status", type = Status }
  }
  utils.deserialize_field_list(self, fields, buf)
  return self
end

--- A helper function used by common code to get all the component pieces of this message frame
---@return table An array formatted table with each component field in the order their bytes should be serialized
function DefaultResponse:get_fields()
  return {
    self.cmd,
    self.status
  }
end

--- @function DefaultResponse:get_length
--- @return number the length of this read attribute response record in bytes
DefaultResponse.get_length = utils.length_from_fields

--- @function DefaultResponse:serialize
--- @return string this DefaultResponse serialized
DefaultResponse.serialize = utils.serialize_from_fields

--- @function DefaultResponse:pretty_print
--- @return string this DefaultResponse as a human readable string
DefaultResponse.pretty_print = utils.print_from_fields
DefaultResponse.__tostring = DefaultResponse

--- Build a default response ZCL body
---
--- @param cls DefaultResponse the class being constructed
--- @param cmd number|Uint8 the command received
--- @param status number|st.zigbee.zcl.types.ZclStatus status of the command
--- @return DefaultResponse
function DefaultResponse.init(cls, cmd, status)
  local out = {}
  out.cmd = data_types.validate_or_build_type(cmd, data_types.Uint8, "cmd")
  out.status = data_types.validate_or_build_type(status, Status, "status")
  setmetatable(out, DefaultResponse)
  return out
end

setmetatable(DefaultResponse, { __call = DefaultResponse.init } )

return default_response
