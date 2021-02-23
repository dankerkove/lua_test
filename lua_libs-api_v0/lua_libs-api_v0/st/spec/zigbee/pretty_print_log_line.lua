local zb_messages = require "st.zigbee.messages"
local rex = require "rex_posix"
local caps = require "st.capabilities"
local utils = require "st.utils"
local buf_lib = require "st.buf"

local logline

function string:split()
  local pieces = {}
  local search_pos = 1
  local split_start, split_end = self:find(" ", search_pos)
  while split_start do
    table.insert(pieces, self:sub(search_pos, split_start - 1))
    search_pos = split_end + 1
    split_start, split_end = self:find(" ", search_pos)
  end
  table.insert(pieces, self:sub(search_pos))
  return pieces
end

local zcl_match = "\\[([A-Fa-f0-9]{4})\\] ZCL Rx: ep:([A-Fa-f0-9]{2}) prof:([A-Fa-f0-9]{4}) clus:([A-Fa-f0-9]{4}) lqi:([A-Fa-f0-9]{2}) rssi:(-?[0-9]+) fc:([A-Fa-f0-9]{2}) mc:([A-Fa-f0-9]{4}) seq:([A-Fa-f0-9]{2}) cmd:([A-Fa-f0-9]{2}) body:(.*)"
local zdo_match = "\\[([A-Fa-f0-9]{4})\\] ZDO Rx: ep:([A-Fa-f0-9]{2}) prof:([A-Fa-f0-9]{4}) clus:([A-Fa-f0-9]{4}) lqi:([A-Fa-f0-9]{2}) rssi:(-?[0-9]+) seq:([A-Fa-f0-9]{2}) body:(.*)"
repeat
  io.write("What is the log line? (q to quit)\n")
  logline = io.read()
  local dni, ep, prof, clus, lqi, rssi, fc, mc, seq, cmd, body
  local m_type = ""
  if string.find(logline, "ZCL") ~= nil then
    dni, ep, prof, clus, lqi, rssi, fc, mc, seq, cmd, body = rex.match(logline, zcl_match)
    m_type = "ZCL"
  elseif string.find(logline, "ZDO") ~= nil then
    dni, ep, prof, clus, lqi, rssi, seq, body = rex.match(logline, zdo_match)
    m_type = "ZDO"
  end
  local zbmess_bytes = ""
  if m_type ~= "" then
    zbmess_bytes = "\x00"
    zbmess_bytes = zbmess_bytes .. string.pack("<I2", tonumber(dni, 16))
    zbmess_bytes = zbmess_bytes .. string.pack("<I1", tonumber(ep, 16))
    zbmess_bytes = zbmess_bytes .. "\x00\x00\x01"
    zbmess_bytes = zbmess_bytes .. string.pack("<I2", tonumber(prof, 16))
    zbmess_bytes = zbmess_bytes .. string.pack("<I2", tonumber(clus, 16))
    zbmess_bytes = zbmess_bytes .. string.pack("<I1", tonumber(lqi, 16))
    zbmess_bytes = zbmess_bytes .. string.pack("<i1", tonumber(rssi))

    local body_byte_strs = body:split(" ")
    if m_type == "ZCL" then
      local fc_int = tonumber(fc, 16)
      if (fc_int & 0x04) ~= 0 then
        zbmess_bytes = zbmess_bytes .. string.pack("<I2", #body_byte_strs + 5)
      else
        zbmess_bytes = zbmess_bytes .. string.pack("<I2", #body_byte_strs + 3)
      end

      zbmess_bytes = zbmess_bytes .. string.pack("<I1", fc_int)
      if (fc_int & 0x04) ~= 0 then
        zbmess_bytes = zbmess_bytes .. string.pack("<I2", tonumber(mc, 16))
      end

      zbmess_bytes = zbmess_bytes .. string.pack("<I1", tonumber(seq, 16))
      zbmess_bytes = zbmess_bytes .. string.pack("<I1", tonumber(cmd, 16))
    elseif m_type == "ZDO" then
      zbmess_bytes = zbmess_bytes .. string.pack("<I2", #body_byte_strs + 3)
      zbmess_bytes = zbmess_bytes .. string.pack("<I1", tonumber(seq, 16))
    end
    for i, v in ipairs(body_byte_strs) do
      zbmess_bytes = zbmess_bytes .. string.pack("<I1", tonumber(v, 16))
    end
    local buf = buf_lib.Reader(zbmess_bytes)
    local parsed_message = zb_messages.ZigbeeMessageRx.deserialize(buf)
    io.write(parsed_message:pretty_print() .. "\n")
  end

until logline == "q"
