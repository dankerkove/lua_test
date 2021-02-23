--- @class st.zwave.defaults
--- @alias default_handlers
local default_handlers = {}

--- Register for default handlers based upon the passed capabilities.
---
--- @param driver st.zwave.Driver
--- @param capabilities table capabilities for which to register defaults
function default_handlers.register_for_default_handlers(driver, capabilities)
  driver.zwave_handlers = driver.zwave_handlers or {}
  driver.capability_handlers = driver.capability_handlers or {}
  local handlers_to_add = {}
  for _, cap in ipairs(capabilities) do
    pcall(function()
      local require_path = "st.zwave.defaults." .. cap.ID
      local entry = require(require_path)
      if entry ~= nil then
        -- collect Z-Wave handlers
        for cc, commands in pairs(entry.zwave_handlers or {}) do
          for command, handler in pairs(commands) do
            handlers_to_add[cc] = handlers_to_add[cc] or {}
            handlers_to_add[cc][command] = handlers_to_add[cc][command] or {}
            table.insert(handlers_to_add[cc][command], handler)
          end
        end

        -- collect capability handlers
        for command, handler in pairs(entry.capability_handlers or {}) do
          driver.capability_handlers[cap.ID] = driver.capability_handlers[cap.ID] or {}
          driver.capability_handlers[cap.ID][command.NAME] = driver.capability_handlers[cap.ID][command.NAME] or handler
        end

        -- collect default get_refresh_commands functions
        if type(entry.get_refresh_commands) == "function" then
          driver.get_refresh_commands_defaults = driver.get_refresh_commands_defaults or {}
          driver.get_refresh_commands_defaults[cap.ID] = entry.get_refresh_commands
        end
      end
    end)
  end

  -- we collect all the relevant default handlers above and add them here, because we only want
  -- to add them if they're not present in the driver's own definitions
  for cc, commands in pairs(handlers_to_add) do
    for command,_ in pairs(commands) do
      driver.zwave_handlers[cc] = driver.zwave_handlers[cc] or {}
      driver.zwave_handlers[cc][command] = driver.zwave_handlers[cc][command] or handlers_to_add[cc][command]
    end
  end

end

return default_handlers
