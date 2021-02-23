local st_utils = require "st.utils"
local it_utils = require "integration_test.utils"
local json = require "dkjson"
local mock_generic_channel = require "integration_test.mock_generic_channel"

local MockCapabilityChannel = {}

function MockCapabilityChannel:__check_message_equality(expected, received)
  local decoded = json.decode(received[2])
  local parsed_received = {received[1], decoded}
  return st_utils.stringify_table(expected) == st_utils.stringify_table(parsed_received)
end

function MockCapabilityChannel:__error_messages_not_equal(expected, received)
  local decoded = json.decode(received[2])
  local parsed_received = {received[1], decoded}
  local error_message = string.format(
      "capability message channel send was expecting:\n%s\nbut received:\n%s",
      st_utils.stringify_table(expected),
      st_utils.stringify_table(parsed_received)
  )
  error({ code = it_utils.UNIT_TEST_FAILURE, msg = error_message, fatal = true })
end

function MockCapabilityChannel:__error_unexpected_message(received)
  local decoded = json.decode(received[2])
  local parsed_received = {received[1], decoded}
  local error_message = string.format(
      "capability message channel send was given unexpected message:\n",
      st_utils.stringify_table(parsed_received)
  )
  error({ code = it_utils.UNIT_TEST_FAILURE, msg = error_message, fatal = true })
end

function MockCapabilityChannel:__convert_to_receive_return(return_msg)
  return { return_msg[1], json.encode(return_msg[2]) }
end

setmetatable(MockCapabilityChannel, {
  __index = mock_generic_channel,
})

local my_mock = mock_generic_channel.init(MockCapabilityChannel, "capability")

return my_mock
