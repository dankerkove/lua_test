local it_utils = require "integration_test.utils"
local mock_generic_channel = require "integration_test.mock_generic_channel"

local MockZwaveChannel = {}

function MockZwaveChannel:__convert_to_receive_return(return_msg)
  local ret_val = {
    -- the order shall match expected order at
    -- zw::zw_cmd_handler()
    -- and
    -- st_zwave_socket:receive():
    -- 1) uuid, 2) encap 3) src_channel 4) dst_channels
    -- 5) cmd_class 6) cmd_id 7) payload
    return_msg[1], --device_uuid
    return_msg[2].encap,
    return_msg[2].src_channel,
    return_msg[2].dst_channels,
    return_msg[2].cmd_class,
    return_msg[2].cmd_id,
    return_msg[2].payload
  }
  return ret_val
end

setmetatable(MockZwaveChannel, {
  __index = mock_generic_channel,
})

local my_mock = mock_generic_channel.init(MockZwaveChannel, "zwave")

return my_mock

