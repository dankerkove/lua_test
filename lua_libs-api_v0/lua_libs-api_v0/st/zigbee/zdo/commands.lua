local bind_request = require "st.zigbee.zdo.bind_request"
local bind_request_response = require "st.zigbee.zdo.bind_request_response"
local generic_body = require "st.zigbee.generic_body"
local binding_table_response = require "st.zigbee.zdo.binding_table_response"

--- @module zdo_commands
local zdo_commands = {}

zdo_commands.BindRequest = bind_request.BindRequest
zdo_commands.BindRequestResponse = bind_request_response.BindRequestResponse
zdo_commands.MgmtBindResponse = binding_table_response.MgmtBindResponse

zdo_commands.commands = {
  [zdo_commands.BindRequest.ID] = zdo_commands.BindRequest,
  [zdo_commands.BindRequestResponse.ID] = zdo_commands.BindRequestResponse,
  [zdo_commands.MgmtBindResponse.ID] = zdo_commands.MgmtBindResponse
}

--- Parse a stream of bytes into a zdo command object
--- @param command_cluster number the id of the command to parse
--- @param str string the bytes of the message to be parsed
--- @return table the command instance of the parsed body.  This will be a specific type in the ID is recognized a GenericBody otherwise
function zdo_commands.parse_zdo_command(command_cluster, str)
  if zdo_commands.commands[command_cluster] ~= nil then
    return zdo_commands.commands[command_cluster].deserialize(str)
  else
    return generic_body.GenericBody.deserialize(str)
  end
end

return zdo_commands
