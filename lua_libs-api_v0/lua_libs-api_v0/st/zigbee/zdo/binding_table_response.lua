local data_types = require "st.zigbee.data_types"
local utils = require "st.zigbee.utils"
local Status = require "st.zigbee.generated.types.ZclStatus"

--- @module mgmt_bind_response
local mgmt_bind_response = {}

mgmt_bind_response.MGMT_BIND_RESPONSE = 0x8033

--- @class BindingTableListRecord
---
--- @field public NAME string "BindingTableListRecord"
--- @field public src_addr Uint16 the source address to bind to
--- @field public src_endpoint Uint8 the source endpoint to bind to
--- @field public cluster_id ClusterId the cluster to bind
--- @field public dest_addr_mode Uint8 a field describing which addressing method will be used for the destination address
--- @field public dest_address Uint16 or IeeeAddress this will be Uin16 if dest_addr_mode is 0x01, or IeeeAddress if it is 0x03
--- @field public dest_endpoint Uint8 This is only present if dest_addr_mode is 0x03 for long addresses
local BindingTableListRecord = {
  NAME = "BindingTableListRecord",
  DEST_ADDR_MODE_SHORT = 0x01,
  DEST_ADDR_MODE_LONG = 0x03,
}
BindingTableListRecord.__index = BindingTableListRecord
mgmt_bind_response.BindingTableListRecord = BindingTableListRecord

--- Parse a BindingTableListRecord from a byte string
--- @param buf Reader the buf to parse the record from
--- @return BindingTableListRecord the parsed attribute record
function BindingTableListRecord.deserialize(buf)
  local self = {}
  setmetatable(self, BindingTableListRecord)
  local fields = {
    { name = "src_addr", type = data_types.IeeeAddress },
    { name = "src_endpoint", type = data_types.Uint8 },
    { name = "cluster_id", type = data_types.ClusterId },
    { name = "dest_addr_mode", type = data_types.Uint8 },
  }
  utils.deserialize_field_list(self, fields, buf)
  if (self.dest_addr_mode.value == mgmt_bind_response.BindingTableListRecord.DEST_ADDR_MODE_SHORT) then
    self.dest_addr = data_types.Uint16.deserialize(buf, "dest_addr")
  elseif (self.dest_addr_mode.value == mgmt_bind_response.BindingTableListRecord.DEST_ADDR_MODE_LONG) then
    self.dest_addr = data_types.IeeeAddress.deserialize(buf, "dest_addr")

    self.dest_endpoint = data_types.Uint8.deserialize(buf, "dest_endpoint")
  else
    error(string.format("Unexpected destination address type %d in binding table response", self.dest_addr_mode.value))
  end
  return self
end

--- A helper function used by common code to get all the component pieces of this message frame
---@return table An array formatted table with each component field in the order their bytes should be serialized
function BindingTableListRecord:get_fields()
  local out_fields = {}
  out_fields[#out_fields + 1] = self.src_addr
  out_fields[#out_fields + 1] = self.src_endpoint
  out_fields[#out_fields + 1] = self.cluster_id
  out_fields[#out_fields + 1] = self.dest_addr_mode
  out_fields[#out_fields + 1] = self.dest_addr
  if (self.dest_addr_mode.value == mgmt_bind_response.BindingTableListRecord.DEST_ADDR_MODE_LONG) then
    out_fields[#out_fields + 1] = self.dest_endpoint
  end
  return out_fields
end

--- @function BindingTableListRecord:get_length
--- @return number the length of this BindingTableListRecord in bytes
BindingTableListRecord.get_length = utils.length_from_fields

--- @function BindingTableListRecord:serialize
--- @return string this BindingTableListRecord serialized
BindingTableListRecord.serialize = utils.serialize_from_fields

--- @function BindingTableListRecord:pretty_print
--- @return string this BindingTableListRecord as a human readable string
BindingTableListRecord.pretty_print = utils.print_from_fields
BindingTableListRecord.__tostring = BindingTableListRecord.pretty_print

--- @class MgmtBindResponse
---
--- @field public NAME string "MgmtBindResponse"
--- @field public ID number 0x8033 the cluster ID for the MgmtBindResponse ZDO command
--- @field public status Status the status of this read additional fields are not present if not SUCCESS
--- @field public total_binding_table_entry_count Uint8 the total number of entries in the binding table
--- @field public start_index Uint8 The index of the binding table records in this message begin with
--- @field public binding_table_list_count Uint8 the number of binding table entries present in this response
--- @field public binding_table_entries BindingTableListRecord[] the list of binding table entries
local MgmtBindResponse = {
  BindingTableListRecord = BindingTableListRecord,
  ID = mgmt_bind_response.MGMT_BIND_RESPONSE,
  NAME = "MgmtBindResponse",
}
MgmtBindResponse.__index = MgmtBindResponse
mgmt_bind_response.MgmtBindResponse = MgmtBindResponse

--- Parse a MgmtBindResponse from a byte string
--- @param buf Reader the buf to parse the record from
--- @return MgmtBindResponse the parsed attribute record
function MgmtBindResponse.deserialize(buf)
  local self = {}
  setmetatable(self, MgmtBindResponse)
  self.status = data_types.Uint8.deserialize(buf, "Status")

  if self.status.value == Status.SUCCESS then
    self.total_binding_table_entry_count = data_types.Uint8.deserialize(buf, "TotalBindingTableEntryCount")
    self.start_index = data_types.Uint8.deserialize(buf, "StartIndex")
    self.binding_table_list_count = data_types.Uint8.deserialize(buf, "BindingTableListCount")

    self.binding_table_entries = {}
    while buf:remain() > 0 do
      self.binding_table_entries[#self.binding_table_entries + 1] = mgmt_bind_response.BindingTableListRecord.deserialize(buf)
    end
  end
  return self
end

--- A helper function used by common code to get all the component pieces of this message frame
---@return table An array formatted table with each component field in the order their bytes should be serialized
function MgmtBindResponse:get_fields()
  local out_fields = {}
  out_fields[#out_fields + 1] = self.status
  if self.status.value == Status.SUCCESS then
    out_fields[#out_fields + 1] = self.total_binding_table_entry_count
    out_fields[#out_fields + 1] = self.start_index
    out_fields[#out_fields + 1] = self.binding_table_list_count
    for _, v in ipairs(self.binding_table_entries) do
      out_fields[#out_fields + 1] = v
    end
  end
  return out_fields
end

--- @function MgmtBindResponse:get_length
--- @return number the length of this MgmtBindResponse in bytes
MgmtBindResponse.get_length = utils.length_from_fields

--- @function MgmtBindResponse:serialize
--- @return string this MgmtBindResponse serialized
MgmtBindResponse.serialize = utils.serialize_from_fields

--- @function MgmtBindResponse:pretty_print
--- @return string this MgmtBindResponse as a human readable string
MgmtBindResponse.pretty_print = utils.print_from_fields
MgmtBindResponse.__tostring = MgmtBindResponse.pretty_print

setmetatable(mgmt_bind_response.MgmtBindResponse, { __call = mgmt_bind_response.MgmtBindResponse.from_values })

return mgmt_bind_response
