local it_utils = require "integration_test.utils"
local zb_utils = require "st.zigbee.utils"
local mock_generic_channel = require "integration_test.mock_generic_channel"

local MockZigbeeChannel = {}

function MockZigbeeChannel:__error_messages_not_equal(expected, received)
  local error_message = string.format(
      "Zigbee message channel send was expecting:\n%s\nbut received:\n%s",
      expected[2]:pretty_print(zb_utils.MULTILINE_FORMAT_CONFIG, 1),
      received[2]:pretty_print(zb_utils.MULTILINE_FORMAT_CONFIG, 1)
  )
  error({ code = it_utils.UNIT_TEST_FAILURE, msg = error_message, fatal = true })
end

function MockZigbeeChannel:__error_unexpected_message(received)
  local error_message = string.format(
      "Zigbee message channel send was given unexpected message:\n%s",
      received[2]:pretty_print(zb_utils.MULTILINE_FORMAT_CONFIG, 1)
  )
  error({ code = it_utils.UNIT_TEST_FAILURE, msg = error_message, fatal = true })
end

function MockZigbeeChannel:__convert_to_receive_return(return_msg)
  return { return_msg[1], return_msg[2]:serialize() }
end

function MockZigbeeChannel:__print_unsent_messages()
    for _, message in ipairs(self.__send_queue) do
      print(string.format(
          "%s was not sent expected message:\n    %s",
          self.__name,
          message[2]:pretty_print(zb_utils.MULTILINE_FORMAT_CONFIG, 1)
      ))
    end
end

setmetatable(MockZigbeeChannel, {
  __index = mock_generic_channel,
})

local my_mock = mock_generic_channel.init(MockZigbeeChannel, "zigbee")

return my_mock