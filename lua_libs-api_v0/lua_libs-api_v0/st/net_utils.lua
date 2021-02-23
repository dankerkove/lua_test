---@class st.net_utils
local net_utils = {}

--- Validate dotted-decimal IPv4 address string
---@param ipv4_addr string to validate
---@return true if valid IPv4 address, false otherwise
function net_utils.validate_ipv4_string(ipv4_addr)
    if ipv4_addr == nil or type(ipv4_addr) ~= "string" then
        return false
    end

    -- verify dotted-decimal format
    local octets = {ipv4_addr:match("(%d+)%.(%d+)%.(%d+)%.(%d+)")}
    if #octets ~= 4 then
        return false
    end

    -- verify each octet is between 0 and 255
    for _, octet in pairs(octets) do
        if (tonumber(octet) < 0 or tonumber(octet) > 255) then
            return false
        end
    end

    return true
end

--- Validate port number
---@param port number to validate
---@return true if valid port number, false otherwise
function net_utils.validate_port(port)
    if port == nil or type(port) ~= "number" then
        return false
    end

    if port < 0 or port > 65535 then
        return false
    end

    return true
end

--- Convert IPv4 decimal value to dotted-decimal string
---@param ipv4_integer decimal representation of IPv4 address
---@return converted IPv4 value if successful, nil otherwise
function net_utils.convert_ipv4_decimal_to_string(ipv4_integer)
    if ipv4_integer == nil or type(ipv4_integer) ~= "number" then
        return nil
    end

    -- Bounds check
    if ipv4_integer < 0 or ipv4_integer > 0xFFFFFFFF then -- uint32 MAX (4294967295) or 255.255.255.255
        return nil
    end

    return ((ipv4_integer >> 24) & 0xFF) .. "." .. ((ipv4_integer >> 16) & 0xFF) .. "." .. ((ipv4_integer >> 8) & 0xFF) .. "." .. (ipv4_integer & 0xFF)
end

--- Converts a hex string to a valid dotted-decimal IPv4 address
--- Note: This will be primarily used to update older LAN devices that
--- have hex representations for their IPv4 address. This utility function
--- could be removed in the future when no longer in use.
---@param hex_ip IP address string represented in hex
---@return converted dotted-decimal IP address if valid, nil otherwise
function net_utils.convert_ipv4_hex_to_dotted_decimal(hex_ip)
    if #hex_ip ~= 8 then
        return nil
    end

    local converted_ip = ""
    local num_octet = 1
    for octet in hex_ip:gmatch("%w%w") do
        octet = tonumber(octet, 16)
        if octet ~= nil then
            if num_octet < 4 then
                converted_ip = converted_ip .. octet .. "."
            else
                converted_ip = converted_ip .. octet
            end
        else
            return nil
        end

        num_octet = num_octet + 1
    end

    if net_utils.validate_ipv4_string(converted_ip) then
        return converted_ip
    else
        return nil
    end
end

return net_utils
