local MessageDispatcher = require "st.dispatcher"

local add_handlers_to_list = function(handler, list)
  local packed_handlers = {}
  if type(handler) == "function" then
    packed_handlers = { handler }
  elseif type(handler) == "table" then
    packed_handlers = handler
  end
  for _, h in ipairs(packed_handlers) do
    table.insert(list, h)
  end
end

--- @class DeviceLifecycleDispatcher : MessageDispatcher
---
--- This inherits from the MessageDispatcher and is intended to handle device lifecycle events
---
--- @field public name string A name of this level of dispatcher used for logging
--- @field public child_dispatchers DeviceLifecycleDispatcher[] those below this handler in the hierarchy
--- @field public default_handlers table The `device_lifecycle_handlers` structure from the Driver
--- @field public dispatcher_class_name string "DeviceLifecycleDispatcher"
local DeviceLifecycleDispatcher = {}

function DeviceLifecycleDispatcher.init(cls, name, dispatcher_filter, default_handlers)
  return MessageDispatcher.init(cls, name, dispatcher_filter, default_handlers, "DeviceLifecycleDispatcher")
end

--- Return a flat list of default handlers that can handle this capability command
---
--- These will be of the form of the `capability_handlers` on a driver  E.g.
--- `hander(driver, device, cap_command)`
---
--- @param driver Driver the driver context
--- @param device Device the device the message came from/is for
--- @param lifecycle_event string The event triggering this
--- @return function[] a flat list of the default handlers that can handle this message
function DeviceLifecycleDispatcher:find_default_handlers(driver, device, lifecycle_event)
  local handlers = {}
  add_handlers_to_list(self.default_handlers[lifecycle_event], handlers)
  return handlers
end

--- Return a multiline string representation of the dispatchers default handlers
---
--- @param self DeviceLifecycleDispatcher
--- @param indent number the indent level to allow for the hierarchy to be visually distinguishable
--- @return string the string representation
function DeviceLifecycleDispatcher.pretty_print_default_handlers(self, indent)
  indent = indent or 0
  local indent_str = string.rep(" ", indent)
  local out = string.format("%sdefault_handlers:\n", indent_str)
  for event, funcs in pairs(self.default_handlers) do
    out = out .. string.format("%s  %s:\n", indent_str, event)
  end
  return out
end

setmetatable(DeviceLifecycleDispatcher, {
  __index = MessageDispatcher,
  __call = DeviceLifecycleDispatcher.init
})

return DeviceLifecycleDispatcher
