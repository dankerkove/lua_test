local base64 = require "st.base64"
local utils = require "st.utils"
local json = require "dkjson"
local caps = require "st.capabilities"
local zcl_clusters = require "st.zigbee.zcl.clusters"
local device_module = require "st.device"
local zigbee_device = require "st.zigbee.device"
local zwave_device = require "st.zwave.device"
local ds = require "datastore"

require "integration_test.mock_datastore"

local mock_device_module = {}
mock_device_module.device_datastore = ds.init()

local zigbee_cluster_list = {}
for id, name in pairs(zcl_clusters.id_to_name_map) do
  table.insert(zigbee_cluster_list, id)
end

-- Global for usage from driver under test
devices = {
  _device_info_cache = {},
  -- Keep separate cache to guarantee consistent order of returns
  _device_id_cache = {},
  get_device_info = function(device_uuid)
    return devices._device_info_cache[device_uuid]
  end,
  get_device_list = function()
    return devices._device_id_cache
  end
}

mock_device_module.reset = function()
  devices._device_info_cache = {}
  devices._device_id_cache = {}
end


local function remove_unserializable_keys(tab)
  local out = {}
  for k,v in pairs(tab) do
    if type(v) == "table" then
      out[k] = remove_unserializable_keys(v)
    elseif type(v) == "function" then
      -- pass
    else
      out[k] = v
    end
  end
  return out
end

mock_device_module.add_test_device = function(device)
  if device.id == nil then
    error("Mock device requires UUID")
  end
  if device.profile == nil then
    -- TODO: Potentially revisit providing some default and/or some helper methods for setting this up
    error("No profile provided.  Device requires profile for correct behavior.")
  end

  devices._device_info_cache[device.id] = json.encode(getmetatable(device).raw_st_data)
  devices._device_id_cache[#devices._device_id_cache + 1] = device.id
end

local uuid_counter = 1
mock_device_module.build_test_generic_device = function(device_template)
  local device_defaults = {
    id = string.format("00000000-1111-2222-3333-%012d", uuid_counter),
    data = {},
    preferences = {},
  }
  uuid_counter = uuid_counter + 1
  utils.merge(device_template, device_defaults)

  local mock_device = {}
  if device_template.profile ~= nil then
    local profile_copy = utils.deep_copy(device_template.profile or {})
    for comp_id, comp in pairs(profile_copy.components) do
      comp.generate_test_message = function(capability_event)
        return {device_template.id, caps.raw_event_to_edge_event(comp.id, capability_event)}
      end
    end
    mock_device.profile = profile_copy
    if mock_device.profile.components.main ~= nil then
      mock_device.generate_test_message = mock_device.profile.components.main.generate_test_message
    else
      mock_device.generate_test_message = function(...)
        print("Device does not have a main component, generate the event for the specific component")
      end
    end
  end
  local raw_dev = utils.deep_copy(device_template)

  -- TODO figure out these driver deps
  local inner
  if device_template.network_type == device_module.NETWORK_TYPE_ZIGBEE then
    inner = zigbee_device.ZigbeeDevice({datastore = mock_device_module.device_datastore }, device_template)
  elseif device_template.network_type == device_module.NETWORK_TYPE_ZWAVE then
    inner = zwave_device.ZwaveDevice({datastore = mock_device_module.device_datastore }, device_template)
  else
    inner = device_module.Device:build({datastore = mock_device_module.device_datastore }, device_template)
  end

  local mock_mt = {
    inner = inner,
    raw_st_data = raw_dev,
  }

  mock_mt.__index = function(self, key)
    if mock_mt.inner[key] ~= nil then
      return mock_mt.inner[key]
    end
    return rawget(self, key)
  end

  setmetatable(mock_device, mock_mt)
  return mock_device
end

local zigbee_dni_counter = 1
local device_eui_counter = 1
mock_device_module.build_test_zigbee_device = function(device_template)

  local device_defaults = {
    device_network_id = string.format("%04d", zigbee_dni_counter),
    network_type = device_module.NETWORK_TYPE_ZIGBEE,
    zigbee_eui = base64.encode("\x24\xFD\x5B\x00\x00\x01\x95" .. string.pack("<B", device_eui_counter)),
    fingerprinted_endpoint_id=0,
  }
  utils.merge(device_template, device_defaults)
  -- Do this separately because we don't want to add this endpoint in the recursive merge if they explicitly set any
  -- endpoints
  if device_template.zigbee_endpoints == nil then
    device_template.zigbee_endpoints = {
      [0] = {id = 0, server_clusters = zigbee_cluster_list}
    }

  end
  local device = mock_device_module.build_test_generic_device(utils.deep_copy(device_template))

  device:set_field("zigbee_short_addr", zigbee_dni_counter)
  zigbee_dni_counter = zigbee_dni_counter + 1
  device_eui_counter = device_eui_counter + 1
  return device
end

mock_device_module.build_test_zwave_device = function(device_template)

  local device_defaults = {
    network_type = device_module.NETWORK_TYPE_ZWAVE,
  }
  utils.merge(device_template, device_defaults)
  local device = mock_device_module.build_test_generic_device(utils.deep_copy(device_template))

  return device
end

return mock_device_module
