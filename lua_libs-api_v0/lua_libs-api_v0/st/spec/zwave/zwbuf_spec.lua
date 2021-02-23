local buf = require "st.zwave.utils.buf"
local utils = require "st.utils"
local TRIALS = 1000 -- number of random values to validate for each test

describe("test booleans", function()
  it("should show equal buffers in reader/writer", function()
    for _=1,TRIALS do
      local tv = math.random(math.maxinteger) - 1
      local writer = buf.Writer()
      for i=1,64 do
        local extracted = (tv >> (i - 1)) % 2 == 1 and 1 or 0
        writer:write_bool(extracted)
      end
      local reader = buf.Reader(writer.buf)
      for i=1,64 do
        reader:read_bool(tostring(i))
      end
      for i=1,64 do
        local extracted = (tv >> (i - 1)) % 2 == 1 and true or false
        assert.are.equal(reader.parsed[tostring(i)], extracted)
      end
      assert.are.equal(reader.buf, writer.buf)
    end
  end)
end)

describe("test floats", function()
  it("should return the original float test values", function()
    for _=1,TRIALS do
      local rfloat = math.random()
      do
        -- Test numbers with a whole portion.
        local tv = rfloat * math.random(-0x80000000, 0x7FFFFFFF)
        local writer = buf.Writer()
        local precision = writer.precision(tv)
        writer:write_float(precision, tv)
        local truncated = buf.Reader(writer.buf):read_be_i32() * 10^(-precision)
        local reader = buf.Reader(writer.buf)
        assert.are.equal(truncated, reader:read_float(precision, "out"))
        assert.are.equal(truncated, reader.parsed.out)
        assert.are_equal(reader.buf, writer.buf)
        if truncated ~= tv and tv ~= 0 then
          -- Compute digits of precision for the truncanted value as compared
          -- to the original test value.  The writer.precision helper function
          -- should maximize precision available with our 32-bit significand.
          -- And we are only testing values with a whole-number portion here.
          -- Therefore, digits should be at least our maximum negated decimal
          -- exponent of 7 plus 1 for our whole-number digit.
          local digits = math.log(1.0 / math.abs(1 - truncated / tv)) / math.log(10)
          assert(digits >= 8, "should retain at least 8 digits of precision")
        end
      end
      for _,size in ipairs({1, 2, 4}) do
        -- Test variable-width floats
        local tv
        if size == 1 then
           tv = rfloat * math.random(-0x80, 0x7F)
        elseif size == 2 then
           tv = rfloat * math.random(-0x8000, 0x7FFF)
        elseif size == 4 then
           tv = rfloat * math.random(-0x80000000, 0x7FFFFFFF)
        end
        local writer = buf.Writer()
        local precision = writer.precision(tv, size)
        writer:write_vfloat(size, precision, tv)
        local truncated
        if size == 1 then
           truncated = buf.Reader(writer.buf):read_i8() * 10^(-precision)
        elseif size == 2 then
           truncated = buf.Reader(writer.buf):read_be_i16() * 10^(-precision)
        elseif size == 4 then
           truncated = buf.Reader(writer.buf):read_be_i32() * 10^(-precision)
        end
        local reader = buf.Reader(writer.buf)
        assert.are.equal(truncated, reader:read_vfloat(size, precision, "out"))
        assert.are.equal(truncated, reader.parsed.out)
        assert.are_equal(reader.buf, writer.buf)
        if truncated ~= tv and tv ~= 0 then
          -- Compute bits of precision from signed full-scale.  Available
          -- precision is bounded by the size of our significand.
          local bits = math.log(1.0 / math.abs(truncated - tv)) / math.log(2) + size * 8 - 1
          local bound = size * 8 - 1
          assert(bits >= bound, "should retain at least " .. bound .. " bits of precision")
        end
      end
      do
        -- Test small fractional numbers.
        local tv = rfloat
        local writer = buf.Writer()
        local precision = writer.precision(tv)
        -- Numbers with only a fractional component should always evaluate
        -- for use of our maximum negated decimal exponent, 7.
        assert.are_equal(precision, 7)
        writer:write_float(precision, tv)
        local truncated = buf.Reader(writer.buf):read_be_i32() * 10^(-precision)
        local reader = buf.Reader(writer.buf)
        assert.are.equal(truncated, reader:read_float(precision, "out"))
        assert.are.equal(truncated, reader.parsed.out)
        assert.are_equal(reader.buf, writer.buf)
        if truncated ~= tv and tv ~= 0 then
          -- Compute digits of precision below 0.  We should always retain at
          -- least a number of digits equal to our maximum negated decimal
          -- exponent, 7.
          local digits = math.log(1.0 / math.abs(truncated - tv)) / math.log(10)
          assert(digits >= 7, "should retain at least 7 digits of precision")
        end
      end
    end
  end)
end)

describe("test signed integers", function()
  it("should return the original integer test values", function()
    for _=1,TRIALS do
      for _,size in ipairs({1, 2, 4}) do
        local tv
        if size == 1 then
           tv = math.random(-0x80, 0x7F)
        elseif size == 2 then
           tv = math.random(-0x8000, 0x7FFF)
        elseif size == 4 then
           tv = math.random(-0x80000000, 0x7FFFFFFF)
        end
        -- Test specified-width integers.
        do
          local writer = buf.Writer()
          writer:write_signed(size, tv)
          local reader = buf.Reader(writer.buf)
          assert.are.equal(tv, reader:read_signed(size, "out"))
          assert.are.equal(tv, reader.parsed.out)
          assert.are.equal(reader.buf, writer.buf)
        end
        -- Test auto-width integers.
        do
          local writer = buf.Writer()
          writer:write_signed(writer.size(tv), tv)
          local reader = buf.Reader(writer.buf)
          assert.are.equal(tv, reader:read_signed(writer.size(tv), "out"))
          assert.are.equal(tv, reader.parsed.out)
          assert.are.equal(reader.buf, writer.buf)
        end
      end
    end
  end)
end)

describe("test encoded Z-Wave command class", function()
  it("should return the original command class test values", function()
    for _=1,TRIALS do
      local tv = math.random(0, 0xFFFF)
      if tv <= 0xFF or tv & 0xFF >= 0xF1 then
        local writer = buf.Writer()
        writer:write_cmd_class(tv)
        local reader = buf.Reader(writer.buf)
        assert.are.equal(tv, reader:read_cmd_class("out"))
        assert.are.equal(tv, reader.parsed.out)
        assert.are.equal(reader.buf, writer.buf)
      end
    end
  end)
end)

describe("test encoded Z-Wave duration sets and reports", function()
  it("should return the original duration test values", function()
    local test_data = {
      {
        write_method = "write_actuator_duration_set",
        read_method = "read_actuator_duration_set",
	max = 127 * 60,
	magic_vals = { "default" }
      },
      {
        write_method = "write_actuator_duration_report",
        read_method = "read_actuator_duration_report",
	max = 126 * 60,
	magic_vals = { "unknown", "reserved" }
      }
    }
    local test_fn = function(tv, write_method, read_method)
      local writer = buf.Writer()
      writer[write_method](writer, tv)
      local truncated = type(tv) == "string" and tv or tv <= 127 and tv or utils.round(tv / 60.0) * 60.0
      local reader = buf.Reader(writer.buf)
      assert.are.equal(truncated, reader[read_method](reader, "out"))
      assert.are.equal(truncated, reader.parsed.out)
      assert.are.equal(reader.buf, writer.buf)
    end
    for _,t in ipairs(test_data) do
      for _=1,TRIALS do
        local tv = math.random(t.max)
	test_fn(tv, t.write_method, t.read_method)
      end
      for _,tv in ipairs(t.magic_vals) do
	test_fn(tv, t.write_method, t.read_method)
      end
    end
  end)
end)

describe("test encoded Z-Wave switchpoint structures", function()
  it("should return the original switchpoint test structures", function()
    for _=1,TRIALS do
      local tv_hour = math.random(0, (1 << 5) - 1)
      local tv_minute = math.random(0, (1 << 6) - 1)
      local tv_state = math.random(0, 0xFF)
      local writer = buf.Writer()
      writer:write_switchpoint({hour=tv_hour, minute=tv_minute, schedule_state=tv_state})
      local reader = buf.Reader(writer.buf)
      local sp = reader:read_switchpoint("out")
      assert.are.equal(tv_hour, sp.hour)
      assert.are.equal(tv_minute, sp.minute)
      assert.are.equal(tv_state, sp.schedule_state)
      assert.are.equal(sp, reader.parsed.out)
      assert.are.equal(reader.buf, writer.buf)
    end
  end)
end)

describe("test zwbuf.Writer.size helper function", function()
  it("should return the appropriate sizes for the given inputs", function()
    for _=1,TRIALS do
      do
      -- test floats
        local tv = math.random()
        local size = tv ~= 0 and buf.Writer.size(tv) or 4
        assert.are.equal(size, 4)
      end
      -- test 8-bit integers
      do
        local tv = math.random(-0x80, 0x7F)
        local size = buf.Writer.size(tv)
        assert.are.equal(size, 1)
      end
      local negative = math.random(0, 1) == 0 and true or 0
      do
      -- test 16-bit integers
        local tv
        if negative then
          tv = math.random(-0x8000, -0x81)
        else
          tv = math.random(0x80, 0x7FFF)
        end
        local size = buf.Writer.size(tv)
        assert.are.equal(size, 2)
      end
      do
      -- test 32-bit integers
        local tv
        if negative then
          tv = math.random(-0x80000000, -0x8001)
        else
          tv = math.random(0x8000, 0x7FFFFFFF)
        end
        local size = buf.Writer.size(tv)
        assert.are.equal(size, 4)
      end
    end
  end)
end)

describe("test zwbuf.Writer.precision helper function", function()
  it("should return the appropriate precisions for the given inputs", function()
    -- test floats
    for _=1,TRIALS do
      local tv = math.random() * math.random(-0x80000000, 0x7FFFFFFF)
      local precision = buf.Writer.precision(tv)
      local scaled = tv * 10^precision
      assert(scaled >= -0x80000000 and scaled <= 0x7FFFFFFF)
      local truncated = math.floor(scaled) * 10^(-precision)
      if tv ~= 0 then
        -- Compute digits of precision for the truncanted value as compared
        -- to the scaled test value.  The writer.precision helper function
        -- should maximize precision available with our 32-bit significand.
        -- And we are only testing values with a whole-number portion here.
        -- Therefore, digits should be at least our maximum negated decimal
        -- exponent of 7 plus 1 for our whole-number digit.
        local digits = math.log(1.0 / math.abs(1 - truncated / tv)) / math.log(10)
        assert(digits >= 8, "should retain at least 8 digits of precision")
      end
    end
    -- test integers
    do
      local tv = math.random(-0x80000000, 0x7FFFFFFF)
      local precision = buf.Writer.precision(tv)
      assert.are.equal(precision, 0)
    end
  end)
end)

describe("test zwbuf.Writer.length helper function", function()
  it("should return the appropriate lengths for the given inputs", function()
    local length = math.random(0, 100)
    -- test strings
    for _=1,TRIALS do
      local tv = ""
      for _=1,length do
        tv = tv .. string.char(math.random(0, 0xFF))
      end
      assert.are.equal(tv:len(), buf.Writer.length(tv))
    end
    -- test arrays
    for _=1,TRIALS do
      local tv = {}
      for _=1,length do
        table.insert(tv, nil)
      end
      assert.are.equal(#tv, buf.Writer.length(tv))
    end
  end)
end)

describe("test zwbuf.Writer.consensus_size and precision helper function", function()
  it("should return the appropriate sizes and precisions for the given inputs", function()
    -- Test a structure of form tv.outerN[i].inner1[j].param1 with integers.
    do
      local tv = {
        outer1 = {
          {
            inner1 = {
              { param1 = 1 }, { param1 = 1 }
            }
          },
          {
            inner1 = {
              { param1 = 1 }, { param1 = 1 }
            },
            inner2 = {
              { param1 = 1 }, { param1 = 0x8000 } -- requires i32, but not included
            }
          }
        },
        outer2 = {
          {
            inner1 = {
              { param1 = 1 }, { param1 = 1 }
            }
          },
          {
            inner1 = {
              { param1 = 1 }, { param1 = 0x7FFF } -- max is here; requires i16
            }
          }
        }
      }
      local size = buf.Writer.consensus_size(
        { tv, "outer1", "inner1", "param1" },
        { tv, "outer2", "inner1", "param1" })
      assert.are.equal(size, 2)
      local precision = buf.Writer.consensus_precision(
      { tv, "outer1", "inner1", "param1" },
        { tv, "outer2", "inner1", "param1" })
      assert.are.equal(precision, 0) -- no floats
    end
    -- Test a structure of form tv.outerN.inner1[i].param1 with floats.
    do
      local test_int = 0x7FFFFF
      local test_float = 1.1
      local tv = {
        outer1 = {
          inner1 = {
            { param1 = test_int }, { param1 = 1 } -- constrains precision
          },
          inner2 = {
            { param1 = 1 }, { param1 = 0x8000 } -- requires i32, but not included
          }
        },
        outer2 = {
          inner1 = {
            { param1 = test_float }, { param1 = 1 } -- requires float
          }
        }
      }
      local size = buf.Writer.consensus_size(
        { tv, "outer1", "inner1", "param1" },
        { tv, "outer2", "inner1", "param1" })
      local test_int_size = buf.Writer.size(test_int)
      local test_float_size = buf.Writer.size(test_float)
      assert.are.equal(size, math.max(test_int_size, test_float_size))
      local precision = buf.Writer.consensus_precision(
        { tv, "outer1", "inner1", "param1" },
        { tv, "outer2", "inner1", "param1" })
      local test_int_precision = buf.Writer.precision(test_int + 0.1)
      local test_float_precision = buf.Writer.precision(test_float)
      assert.are.equal(precision, math.min(test_int_precision, test_float_precision))
    end
    -- Test a structure of form tv.outerN[i].inner1.param1 with bitmasks.
    do
      local test_bitmask = "1234"
      local tv = {
        outer1 = {
          {
            inner1 = {
              { param1 = test_bitmask }, { param1 = test_bitmask }
            },
            inner2 = {
              { param1 = 1.1 }, { param1 = "12345678" } -- not included
            }
          },
          {
            inner1 = {
              { param1 = test_bitmask }, { param1 = test_bitmask }
            }
          }
        },
        outer2 = {
          {
            inner1 = {
              { param1 = test_bitmask }, { param1 = test_bitmask }
            }
          }
        }
      }
      local size = buf.Writer.consensus_size(
        { tv, "outer1", "inner1", "param1" },
        { tv, "outer2", "inner1", "param1" })
      assert.are.equal(size, buf.Writer.size(test_bitmask))
    end
  end)
end)

describe("test zwbuf.Writer.consensus_length helper function", function()
  it("should return the appropriate lengths for the given inputs", function()
    -- Test a structure of form tv.outerN[i].inner1[j].param1 with strings
    local test_string = "abc"
    local tv = {
      outer1 = {
        {
          inner1 = {
            { param1 = test_string }, { param1 = test_string }
          }
        },
        {
          inner1 = {
            { param1 = test_string }, { param1 = test_string }
          },
          inner2 = {
            { param1 = 1 }, { param1 = "abcdef" } -- not included
          }
        }
      },
      outer2 = {
        {
          inner1 = {
            { param1 = test_string }, { param1 = test_string }
          }
        },
        {
          inner1 = {
            { param1 = test_string }, { param1 = test_string }
          }
        }
      }
    }
    -- Evaluate consensus length of included param1 strings.
    do
      local length = buf.Writer.consensus_length(
        { tv, "outer1", "inner1", "param1" },
        { tv, "outer2", "inner1", "param1" })
      assert.are.equal(length, test_string:len())
    end
    -- Evaluate consensus length of outer1, outer2 arrays.
    do
      local length = buf.Writer.consensus_length(
        { tv, "outer1" },
        { tv, "outer2" })
      assert.are.equal(length, 2)
    end
  end)
end)

