local timer = _envlibrequire "timer"
local internals = require "cosock.socket.internals"

local m = {}

local recvmethods = {
  wait = "timeout",
}

local sendmethods = {}
local passthrough = internals.passthroughbuilder(recvmethods, sendmethods)

m.create_oneshot = function(seconds)
  local inner_sock, err = timer.create_oneshot(seconds)
  if not inner_sock then return inner_sock, err end
  inner_sock:settimeout(0)
  return setmetatable({inner_sock = inner_sock, class = "timer{}"}, { __index = m})
end

m.create_interval = function(seconds)
  local inner_sock, err = timer.create_interval(seconds)
  if not inner_sock then return inner_sock, err end
  inner_sock:settimeout(0)
  return setmetatable({inner_sock = inner_sock, class = "timer{}"}, { __index = m})
end

m.cancel = passthrough("cancel")
m.wait = passthrough("wait")
m.handled = passthrough("handled")

function m:settimeout(timeout)
  self.timeout = timeout
end

internals.setuprealsocketwaker(m)

return m
