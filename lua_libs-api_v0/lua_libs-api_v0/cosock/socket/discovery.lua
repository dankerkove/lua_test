local lsocket = require "socket"
local internals = require "cosock.socket.internals"

local m = {}

local recvmethods = {
  receive = "timeout",
}

local sendmethods = {}

setmetatable(m, {__call = function()
  local inner_sock, err = lsocket.discovery()
  if not inner_sock then return inner_sock, err end
  inner_sock:settimeout(0)
  return setmetatable({inner_sock = inner_sock, class = "discovery{}"}, { __index = m})
end})

local passthrough = internals.passthroughbuilder(recvmethods, sendmethods)

m.receive = passthrough("receive")

function m:settimeout(timeout)
  self.timeout = timeout
end

internals.setuprealsocketwaker(m)

return m
