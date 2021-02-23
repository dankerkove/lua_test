local buf = require "st.buf"
local utils = require "st.utils"
local TRIALS = 1000 -- number of random values to validate for each test

local function int_helper(tv, endianness, signedness, width)
  local writer = buf.Writer()
  writer["write" .. endianness .. "_" .. signedness .. width](writer, tv)
  local reader = buf.Reader(writer.buf)
  assert.are.equal(tv, reader["read" .. endianness .. "_" .. signedness .. width](reader, "out"))
  assert.are.equal(tv, reader.parsed.out)
  assert.are.equal(reader.buf, writer.buf)
end

describe("test 8-bit integers", function()
  it("should return the original 8-bit test values", function()
    for _=1,TRIALS do
      local tv = math.random(0, 0xFF)
      int_helper(tv, "", "u", "8")
      int_helper(tv - 0x80, "", "i", "8")
    end
  end)
end)

describe("test 16-bit integers", function()
  it("should return the original 16-bit test values", function()
    for _=1,TRIALS do
      local tv = math.random(0, 0xFFFF)
      int_helper(tv, "_le", "u", "16")
      int_helper(tv, "_be", "u", "16")
      int_helper(tv - 0x8000, "_le", "i", "16")
      int_helper(tv - 0x8000, "_be", "i", "16")
    end
  end)
end)

describe("test 24-bit integers", function()
  it("should return the original 24-bit test values", function()
    for _=1,TRIALS do
      local tv = math.random(0, 0xFFFFFF)
      int_helper(tv, "_le", "u", "24")
      int_helper(tv, "_be", "u", "24")
      int_helper(tv - 0x800000, "_le", "i", "24")
      int_helper(tv - 0x800000, "_be", "i", "24")
    end
  end)
end)

describe("test 32-bit integers", function()
  it("should return the original 32-bit test values", function()
    for _=1,TRIALS do
      local tv = math.random(0, 0xFFFFFFFF)
      int_helper(tv, "_le", "u", "32")
      int_helper(tv, "_be", "u", "32")
      int_helper(tv - 0x80000000, "_le", "i", "32")
      int_helper(tv - 0x80000000, "_be", "i", "32")
    end
  end)
end)

describe("test 40-bit integers", function()
  it("should return the original 40-bit test values", function()
    for _=1,TRIALS do
      local tv = math.random(0, 0xFFFFFFFFFF)
      int_helper(tv, "_le", "u", "40")
      int_helper(tv, "_be", "u", "40")
      int_helper(tv - 0x8000000000, "_le", "i", "40")
      int_helper(tv - 0x8000000000, "_be", "i", "40")
    end
  end)
end)

describe("test 48-bit integers", function()
  it("should return the original 48-bit test values", function()
    for _=1,TRIALS do
      local tv = math.random(0, 0xFFFFFFFFFFFF)
      int_helper(tv, "_le", "u", "48")
      int_helper(tv, "_be", "u", "48")
      int_helper(tv - 0x800000000000, "_le", "i", "48")
      int_helper(tv - 0x800000000000, "_be", "i", "48")
    end
  end)
end)

describe("test 56-bit integers", function()
  it("should return the original 56-bit test values", function()
    for _=1,TRIALS do
      local tv = math.random(0, 0xFFFFFFFFFFFFFF)
      int_helper(tv, "_le", "u", "56")
      int_helper(tv, "_be", "u", "56")
      int_helper(tv - 0x80000000000000, "_le", "i", "56")
      int_helper(tv - 0x80000000000000, "_be", "i", "56")
    end
  end)
end)

describe("test booleans", function()
  it("should show equal buffers in reader/writer", function()
    for _=1,TRIALS do
      local tv = math.random(math.maxinteger) - 1
      local reader = buf.Reader(utils.serialize_int(tv, 8, true, true))
      local writer = buf.Writer()
      for i=1,64 do
        writer:write_bool(reader:read_bool(tostring(i)))
      end
      assert.are.equal(reader.buf, writer.buf)
      for i=1,64 do
        local extracted = (tv >> (i - 1)) % 2 == 1 and true or false
        assert.are.equal(reader.parsed[tostring(i)], extracted)
      end
    end
  end)
end)

describe("test opaque buffers", function()
  it("should show equal buffers in reader/writer", function()
    for i=1,TRIALS do
      local tv1 = utils.serialize_int(math.random(0, 0x7FFFFFFF),
        math.random(4, 8))
      local tv2 = utils.serialize_int(math.random(0, 0x7FFFFFFF),
        math.random(4, 8))
      local tv3 = utils.serialize_int(math.random(0, 0x7FFFFFFF),
        math.random(4, 8))
      local seek1 = math.random(0, 63)
      local seek2 = math.random(0, 63)
      local seek3 = math.random(0, 63)
      local seek4 = 8 + math.random(0, 55)
      if i == 1 then
        -- In our first iteration, test a case with 0-length bit seeks.
        seek1,seek2,seek3,seek4 = 0,0,0,0
      end
      local writer = buf.Writer()
      -- Alternate bit writes and string writes.  Each string write
      -- must advance to a byte boundary.
      writer:write_bits(seek1, 0)
      writer:write_bytes(tv1)
      writer:write_bits(seek2, 0)
      writer:write_bytes(tv2)
      writer:write_bits(seek3, 0)
      writer:write_bytes(tv3)
      writer:write_bits(seek4, 0)
      local reader = buf.Reader(writer.buf)
      reader:bit_seek(seek1)
      assert.are.equal(tv1, reader:read_bytes(tv1:len(), "out1"))
      assert.are.equal(tv1, reader.parsed.out1)
      reader:bit_seek(seek2)
      assert.are.equal(tv2, reader:read_bytes(tv2:len(), "out2"))
      assert.are.equal(tv2, reader.parsed.out2)
      reader:bit_seek(seek3)
      assert.are.equal(tv3, reader:read_bytes(tv3:len(), "out3"))
      assert.are.equal(tv3, reader.parsed.out3)
      local success = pcall(function()
        -- Advance to byte boundary, and then read bytes beyond
        -- the end of the buffer.  This must fail.
        reader:bit_seek(seek4 % 8)
        reader:read_bytes((seek4 - seek4 % 8) / 8 + 1)
      end)
      assert.are.equal(success, false) -- should fail
    end
  end)
end)

describe("test bit serialization", function()
  it("should show equal buffers in reader/writer", function()
    for _=1,TRIALS do
      local width = math.random(1, 63)
      local tv = math.random(0, 1 << (width - 1) - 1)
      local writer = buf.Writer()
      writer:write_bits(width, tv)
      local reader = buf.Reader(writer.buf)
      assert.are.equal(tv, reader:read_bits(width, "out"))
      assert.are.equal(tv, reader.parsed.out)
    end
  end)
end)

describe("test bit seek", function()
  it("should show equal buffers in reader/writer", function()
    for _=1,TRIALS do
      local seek1 = math.random(1, 63)
      local seek2 = math.random(1, 63)
      local seek3 = math.random(1, 63)
      local tv1 = math.random(0, math.maxinteger)
      local tv2 = math.random(0, math.maxinteger)
      local writer = buf.Writer()
      writer:write_bits(seek1, 0)
      writer:write_bits(seek2, 0)
      writer:write_int(tv1, 8, true, true)
      writer:write_bits(seek3, 0)
      writer:write_int(tv2, 8, true, true)
      local reader = buf.Reader(writer.buf)
      reader:bit_seek(seek1)
      reader:bit_seek(seek2)
      assert.are.equal(tv1, reader:read_int(8, true, true, "out1"))
      reader:bit_seek(seek3)
      assert.are.equal(tv2, reader:read_int(8, true, true, "out2"))
      assert.are.equal(tv1, reader.parsed.out1)
      assert.are.equal(tv2, reader.parsed.out2)
    end
  end)
end)

describe("test seek, tell, remain", function()
  it("should show expected state in buffer after seek and read operations", function()
    local tv = math.random(0, math.maxinteger)
    tv = utils.serialize_int(tv, 8, true, true)
    local reader = buf.Reader(tv)
    local remain = tv:len()
    local tell = 0
    assert.are.equal(reader:remain(), remain)
    assert.are.equal(reader:tell(), tell)
    reader:seek(1)
    remain = remain - 1
    tell = tell + 1
    assert.are.equal(reader:remain(), remain)
    assert.are.equal(reader:tell(), tell)
    reader:read_le_u32()
    remain = remain - 4
    tell = tell + 4
    assert.are.equal(reader:remain(), remain)
    assert.are.equal(reader:tell(), tell)
    reader:seek(remain - 1)
    tell = tell + remain - 1
    remain = 1
    assert.are.equal(reader:remain(), remain)
    assert.are.equal(reader:tell(), tell)
    reader:read_u8()
    remain = remain - 1
    tell = tell + 1
    assert.are.equal(reader:remain(), remain)
    assert.are.equal(reader:tell(), tell)
    reader:seek(1)
    remain = -1
    tell = tell + 1
    assert.are.equal(reader:remain(), remain)
    assert.are.equal(reader:tell(), tell)
  end)
end)

