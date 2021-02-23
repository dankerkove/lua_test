local Error = require 'luxure.error'.Error

---A map of the key value pairs from the header portion
---of an HTTP request
local Headers = {}

Headers.__index = Headers

local function _append(t, key, value)
    if not t[key] then
        t[key] = value
    elseif type(t[key]) == 'string' then
        t[key] = {t[key], value}
    else
        table.insert(t[key], value)
    end
end

---Serialize a key value pair
---@param key string
---@param value string
---@return string
local function serialize_header(key, value)
    local utils = require 'luxure.utils'
    if type(value) == "table" then
        value = value[#value]
    end
    -- special case for MD5
    key = string.gsub(key, 'md5', 'mD5')
    -- special case for ETag
    key = string.gsub(key, 'etag', 'ETag')
    if #key < 3 then
        return string.format("%s: %s", key:upper(), value)
    end
    -- special case for WWW-*
    key = string.gsub(key, 'www', 'WWW')
    local replaced = key:sub(1, 1):upper() .. string.gsub(key:sub(2), '_(%l)', function (c)
        return '-' .. c:upper()
    end)
    return string.format("%s: %s", replaced, value)
end

function Headers:serialize()
    local ret = ""
    for key, value in pairs(self) do
        ret = ret .. serialize_header(key, value) .. "\r\n"
    end
    return ret
end

function Headers:append_chunk(text)
    if string.match(text, "^%s+") ~= nil then
        Error.assert(self.last_key, 'Header continuation with no key')
        local existing = self[self.last_key]
        self[self.last_key] = string.format('%s %s', existing, text)
        return
    end
    for raw_key, value in string.gmatch(text, "([0-9a-zA-Z\\-]+): (.+);?") do
        local key = Headers.normalize_key(raw_key)
        self:append(key, value)
    end
end

--- Constructor for a Headers instance with the provided text
function Headers.from_chunk(text)
    local headers = Headers.new()
    headers:append_chunk(text)
    return headers
end

--- Bare constructor
function Headers.new(base)
    local ret = base or {
        last_key = nil,
    }
    setmetatable(ret, Headers)
    return ret
end

--- Parse and append the provided text as HTTP headers
---
--- @param text string
function Headers:append_from(text)
    for raw_key, value in string.gmatch(text, "([a-zA-Z\\-]+): (.+)") do
        local key = Headers.normalize_key(raw_key)
        self:append(key, value)
    end
end

--- Convert a standard header key to the normalized
--- lua identifer used by this collection
--- @param key string
--- @return string
function Headers.normalize_key(key)
    local lower = string.lower(key)
    local normalized = string.gsub(lower, "-", "_")
    return normalized
end

--- Insert a single key value pair to the collection
function Headers:append(key, value)
    _append(self, key, value)
    self.last_key = key
end

--- Get a header from the map of headers
---
--- This will first normalize the provided key. For example
--- "Content-Type" will be normalized to `content_type`.
--- If more than one value is provided for that header, the
--- last value will be provided
--- @param key string
--- @return string
function Headers:get_one(key)
    local k = Headers.normalize_key(key or "")
    local value = self[k]
    if type(value) == 'table' then
        return value[#value]
    else
        return value
    end
end

--- Get a header from the map of headers
---
--- This will first normalize the provided key. For example
--- "Content-Type" will be normalized to `content_type`.
--- If more than one value is provided for that header
--- @param key string
--- @return table a list of the provided values
function Headers:get_all(key)
    local k = Headers.normalize_key(key or "")
    local values = self[k]
    if type(values) == "string" then
        return {values}
    end
    return self[k]
end

return {
    Headers = Headers,
    serialize_header = serialize_header,
}
