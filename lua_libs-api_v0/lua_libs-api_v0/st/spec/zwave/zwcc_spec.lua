local zw = require "st.zwave"
local TRIALS = 1000 -- number of random values to validate for each test

describe("test command class module instantiation", function()
  it("should successfully load modules into memory", function()
    for _,cc in pairs(require "st.zwave.CommandClass") do
      local module = zw.load_cc(cc)
    end
  end)
end)

describe("test construction with zw.Command, used from-mesh", function()
  it("should successfully construct all commands", function()
    -- test construction for all known commands
    for _,cc in pairs(require "st.zwave.CommandClass") do
      local module = zw.load_cc(cc)
      if module ~= nil then
        for cmd,_ in pairs(module._lut[0]) do
          local constructed = zw.Command(cc, cmd, {})
          assert(constructed.err == nil, constructed.err)
          tostring(constructed)
        end
      end
    end
    -- test a random sampling of possible single-byte command class code points
    for _=1,TRIALS do
      local cc = math.random(0, 0xF0)
      local cmd = math.random(0, 0xFF)
      local constructed = zw.Command(cc, cmd, {})
      tostring(constructed)
    end
    -- test a random sampling of possible two-byte command class code points
    for _=1,TRIALS do
      local msb = math.random(0, 0xFF)
      local lsb = math.random(0xF1, 0xFF)
      local cc = (msb << 8) + lsb
      local cmd = math.random(0, 0xFF)
      local constructed = zw.Command(cc, cmd, {})
      tostring(constructed)
    end
  end)
end)

describe("test versioned, command-specific constructrors, used to-mesh", function()
  it("should successfully construct all supported commands", function()
    for _,cc in pairs(require "st.zwave.CommandClass") do
      local module = zw.load_cc(cc)
      if module ~= nil then
        for version,cmds in pairs(module._lut) do
          if version > 0 then
            for _,constructor in pairs(cmds) do
              local constructed = constructor(module, {})
              tostring(constructed)
	    end
          end
        end
      end
    end
  end)
end)

describe("test dynamically-versioned constructors", function()
  it("should successfully construct all supported commands", function()
    for _,cc in pairs(require "st.zwave.CommandClass") do
      local module = zw.load_cc(cc)
      if module ~= nil then
        local function find_highest_version(module)
          local highest = 0
	  for v,_ in pairs(zw._versions[cc]) do
	    if v > highest then
	      highest = v
	    end
	  end
	  return highest
        end
        module = module({version = find_highest_version(module), strict = false})
        for _,constructor in pairs(module._lut[0]) do
          local constructed = constructor(module, {})
          tostring(constructed)
        end
      end
    end
  end)
end)

describe("test inheritance for renamed command classes", function()
  it("renamed command classes should have access to their predecessors", function()
    local utils = require "st.utils"
    local renamed = {
      ["Notification"] = "Alarm",
      ["MultiChannel"] = "MultiInstance",
      ["MultiChannelAssociation"] = "MultiInstanceAssociation"
    }
    for new_name,old_name in pairs(renamed) do
      local new_module = require ("st.zwave.CommandClass." .. new_name)
      local old_module = require ("st.zwave.CommandClass." .. old_name)
      for version,cmds in pairs(old_module._lut) do
        if version > 0 then
          for cmd_id,cmd in pairs(cmds) do
            local constructed = cmd(new_module, {})
            tostring(constructed)
            local vmodule = new_module({version = version, strict = false})
            constructred = vmodule._lut[0][cmd_id](vmodule, {})
          end
        else
        end
      end
    end
  end)
end)
