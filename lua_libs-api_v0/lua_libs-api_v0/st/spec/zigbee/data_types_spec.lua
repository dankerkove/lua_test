local data_types = require "st.zigbee.data_types"
local buf_lib = require "st.buf"

local buf_from_str = function(str)
    return buf_lib.Reader(str)
end

describe("test data types", function()
    for i = 0, 7 do
        local str_data = "\x01\x02\x03\x04\x05\x06\x07\x08"
        local cur_id = data_types.Data8.ID + i
        it("Data" .. ((i + 1) * 8) .. " can initialize from string data", function()
            local out_type = data_types.parse_data_type(cur_id, buf_from_str(str_data))
            assert.are.equal(out_type.ID, cur_id, "should parse correct id")
            assert.are.equal(out_type:get_length(), i + 1, "should have correct length")
            assert.are.equal(out_type.value, string.reverse(str_data:sub(1, i+1)), "should keep type as bytes")
            assert.are.equal(out_type:serialize(), str_data:sub(1,i+1), "should pack to the same bytes as the source")
        end)
        it("Data" .. ((i + 1) * 8) .. " should be buildable from string", function()
            local out_type = data_types.get_data_type_by_id(cur_id)(string.reverse(str_data:sub(1, i+1)))
            assert.are.equal(out_type.ID, cur_id, "should parse correct id")
            assert.are.equal(out_type:get_length(), i + 1, "should have correct length")
            assert.are.equal(out_type.value, string.reverse(str_data:sub(1, i+1)), "should keep type as bytes")
            assert.are.equal(out_type:serialize(), str_data:sub(1,i+1), "should pack to the same bytes as the source")
        end)

    end
end)

describe("test 64 bit data types", function()
    local str_data = "\x01\x02\x03\x04\x05\x06\x07\x08"
    local ids = {data_types.Uint64.ID, data_types.Int64.ID, data_types.Bitmap64.ID}
    for i, cur_id in ipairs(ids) do
        it("it can initialize from string data", function()
            local out_type = data_types.parse_data_type(cur_id, buf_from_str(str_data))
            assert.are.equal(out_type.ID, cur_id, "should parse correct id")
            assert.are.equal(out_type:get_length(), 8, "should have correct length")
            assert.are.equal(out_type.value, string.reverse(str_data), "should keep type as bytes")
            assert.are.equal(out_type:serialize(), str_data, "should pack to the same bytes as the source")
        end)
        it("it should be buildable from string", function()
            local out_type = data_types.get_data_type_by_id(cur_id)(string.reverse(str_data))
            assert.are.equal(out_type.ID, cur_id, "should parse correct id")
            assert.are.equal(out_type:get_length(), 8, "should have correct length")
            assert.are.equal(out_type.value, string.reverse(str_data), "should keep type as bytes")
            assert.are.equal(out_type:serialize(), str_data, "should pack to the same bytes as the source")
        end)
    end
end)

describe("test Boolean type", function()
    it("should be able to parse 0 as false", function()
        local out_type = data_types.parse_data_type(0x10, buf_from_str("\x00"))
        assert.is_false(out_type.value, "should be false")
        assert.are.equal(out_type.ID, data_types.Boolean.ID, "ids should match")
        assert.are.equal(out_type:get_length(), 1, "length should be 1")
        assert.are.equal(out_type:serialize(), "\x00", "pack should work")
    end)
    it("should be able to parse 1 as true", function()
        local out_type = data_types.parse_data_type(0x10, buf_from_str("\x01"))
        assert.is_true(out_type.value, "should be true")
        assert.are.equal(out_type.ID, data_types.Boolean.ID, "ids should match")
        assert.are.equal(out_type:get_length(), 1, "length should be 1")
        assert.are.equal(out_type:serialize(), "\x01", "pack should work")
    end)
    it("should be buildable from bool", function()
        local out_type = data_types.get_data_type_by_id(0x10)(true)
        assert.is_true(out_type.value, "should be true")
        assert.are.equal(out_type.ID, data_types.Boolean.ID, "ids should match")
        assert.are.equal(out_type:get_length(), 1, "length should be 1")
        assert.are.equal(out_type:serialize(), "\x01", "pack should work")
    end)
end)

describe("test bitmap types", function()
    local str_data = "\x01\x02\x03\x04\x05\x06\x07\x08"
    for i = 0, 6 do
        local cur_id = data_types.Bitmap8.ID + i
        local cur_val = 0
        for j = 0, i, 1 do
            cur_val = cur_val + ((j+ 1) << (j * 8))
        end
        it("Bitmap" .. ((i + 1) * 8) .. " can initialize from string data", function()
            local out_type = data_types.parse_data_type(cur_id, buf_from_str(str_data))
            assert.are.equal(out_type.ID, cur_id, "should parse correct id")
            assert.are.equal(out_type:get_length(), i + 1, "should have correct length")
            assert.are.equal(out_type.value, cur_val, "should convert bytes to unsigned int")
            assert.are.equal(out_type:serialize(), str_data:sub(1,i+1), "should pack to the same bytes as the source")
        end)
        it("Bitmap" .. ((i + 1) * 8) .. " should be buildable from int", function()
            local out_type = data_types.get_data_type_by_id(cur_id)(cur_val)
            assert.are.equal(out_type.ID, cur_id, "should parse correct id")
            assert.are.equal(out_type:get_length(), i + 1, "should have correct length")
            assert.are.equal(out_type.value, cur_val, "should convert bytes to unsigned int")
            assert.are.equal(out_type:serialize(), str_data:sub(1,i+1), "should pack to the same bytes as the source")
        end)
    end
end)

describe("test uint types", function()
    local str_data = "\x01\x02\x03\x04\x05\x06\x07\x08"
    for i = 0, 6 do
        local cur_id = data_types.Uint8.ID + i
        local cur_val = 0
        for j = 0, i, 1 do
            cur_val = cur_val + ((j+ 1) << (j * 8))
        end
        it("Uint" .. ((i + 1) * 8) .. " can initialize from string data", function()
            local out_type = data_types.parse_data_type(cur_id, buf_from_str(str_data))
            assert.are.equal(out_type.ID, cur_id, "should parse correct id")
            assert.are.equal(out_type:get_length(), i + 1, "should have correct length")
            assert.are.equal(out_type.value, cur_val, "should convert bytes to unsigned int")
            assert.are.equal(out_type:serialize(), str_data:sub(1,i+1), "should pack to the same bytes as the source")
        end)
        it("Uint" .. ((i + 1) * 8) .. " should be buildable from int", function()
            local out_type = data_types.get_data_type_by_id(cur_id)(cur_val)
            assert.are.equal(out_type.ID, cur_id, "should parse correct id")
            assert.are.equal(out_type:get_length(), i + 1, "should have correct length")
            assert.are.equal(out_type.value, cur_val, "should convert bytes to unsigned int")
            assert.are.equal(out_type:serialize(), str_data:sub(1,i+1), "should pack to the same bytes as the source")
        end)
    end
end)

describe("test int types", function()
    local str_data = "\xFE\xFF\xFF\xFF\xFF\xFF\xFF\xFF"
    for i = 0, 6 do
        it("Int" .. ((i + 1) * 8) .. " can initialize from string data", function()
            local cur_id = data_types.Int8.ID + i
            local out_type = data_types.parse_data_type(cur_id, buf_from_str(str_data))
            assert.are.equal(out_type.ID, cur_id, "should parse correct id")
            assert.are.equal(out_type:get_length(), i + 1, "should have correct length")
            assert.are.equal(out_type.value, -2, "should convert bytes to int")
            assert.are.equal(out_type:serialize(), str_data:sub(1,i+1), "should pack to the same bytes as the source")
        end)
    end
end)

describe("test enum types", function()
    local str_data = "\x01\x02"
    for i = 0, 1, 1 do
        local cur_id = data_types.Enum8.ID + i
        local cur_val = 0
        for j = 0, i, 1 do
            cur_val = cur_val + ((j+ 1) << (j * 8))
        end
        it("Enum" .. ((i + 1) * 8) .. " can initialize from string data", function()
            local out_type = data_types.parse_data_type(cur_id, buf_from_str(str_data))
            assert.are.equal(out_type.ID, cur_id, "should parse correct id")
            assert.are.equal(out_type:get_length(), i + 1, "should have correct length")
            assert.are.equal(out_type.value, cur_val, "should convert bytes to unsigned int")
            assert.are.equal(out_type:serialize(), str_data:sub(1,i+1), "should pack to the same bytes as the source")
        end)
        it("Enum" .. ((i + 1) * 8) .. " should be buildable from int", function()
            local out_type = data_types.get_data_type_by_id(cur_id)(cur_val)
            assert.are.equal(out_type.ID, cur_id, "should parse correct id")
            assert.are.equal(out_type:get_length(), i + 1, "should have correct length")
            assert.are.equal(out_type.value, cur_val, "should convert bytes to unsigned int")
            assert.are.equal(out_type:serialize(), str_data:sub(1,i+1), "should pack to the same bytes as the source")
        end)
    end
end)

describe("test zigbee string types", function()
    it("should parse one byte length strings", function()
        local str = "\x05\x41\x42\x43\x44\x45"
        local out_type = data_types.parse_data_type(0x41, buf_from_str(str))
        assert.are.equal(out_type.ID, data_types.OctetString.ID, "ids should match")
        assert.are.equal(out_type:get_length(), #str, "should have correct length")
        assert.are.equal(out_type.value, str:sub(2, -1), "should have value of string without length")
        assert.are.equal(out_type:pretty_print(), "OctetString: \"ABCDE\"", "should be pretty printable")
        assert.are.equal(out_type:serialize(), str, "should pack to the same as the input")
        out_type = data_types.parse_data_type(0x42, buf_from_str(str))
        assert.are.equal(out_type.ID, data_types.CharString.ID, "ids should match")
        assert.are.equal(out_type:get_length(), #str, "should have correct length")
        assert.are.equal(out_type.value, str:sub(2, -1), "should have value of string without length")
        assert.are.equal(out_type:serialize(), str, "should pack to the same as the input")
        assert.are.equal(out_type:pretty_print(), "CharString: \"ABCDE\"", "should be pretty printable")
    end)
    it("should parse two byte length strings", function()
        local str = "\x05\x00\x41\x42\x43\x44\x45"
        local out_type = data_types.parse_data_type(0x43, buf_from_str(str))
        assert.are.equal(out_type.ID, data_types.LongOctetString.ID, "ids should match")
        assert.are.equal(out_type:get_length(), #str, "should have correct length")
        assert.are.equal(out_type.value, str:sub(3, -1), "should have value of string without length")
        assert.are.equal(out_type:serialize(), str, "should pack to the same as the input")
        assert.are.equal(out_type:pretty_print(), "LongOctetString: \"ABCDE\"", "should be pretty printable")
        out_type = data_types.parse_data_type(0x44, buf_from_str(str))
        assert.are.equal(out_type.ID, data_types.LongCharString.ID, "ids should match")
        assert.are.equal(out_type:get_length(), #str, "should have correct length")
        assert.are.equal(out_type.value, str:sub(3, -1), "should have value of string without length")
        assert.are.equal(out_type:serialize(), str, "should pack to the same as the input")
        assert.are.equal(out_type:pretty_print(), "LongCharString: \"ABCDE\"", "should be pretty printable")
    end)
    it("shouldn't consume extra bytes", function()
        local str = "\x02\x41\x42EXTRABYTES"
        local out_type = data_types.parse_data_type(0x42, buf_from_str(str))
        assert.are.equal(out_type:get_length(), 3)
        assert.are.equal(out_type:serialize(), str:sub(1,3))
    end)
    it("should be buildable from string data", function()
        local one_byte_len = "\x05"
        local two_byte_len = "\x05\x00"
        local str = "\x41\x42\x43\x44\x45"
        local out_type = data_types.get_data_type_by_id(0x41)(str)
        assert.are.equal(out_type.ID, data_types.OctetString.ID, "ids should match")
        assert.are.equal(out_type:get_length(), #str + 1, "should have correct length")
        assert.are.equal(out_type.value, str, "should have value of string without length")
        assert.are.equal(out_type:serialize(), one_byte_len .. str, "should pack to the same as the input")
        out_type = data_types.get_data_type_by_id(0x42)(str)
        assert.are.equal(out_type.ID, data_types.CharString.ID, "ids should match")
        assert.are.equal(out_type:get_length(), #str + 1, "should have correct length")
        assert.are.equal(out_type.value, str, "should have value of string without length")
        assert.are.equal(out_type:serialize(), one_byte_len .. str, "should pack to the same as the input")
        out_type = data_types.get_data_type_by_id(0x43)(str)
        assert.are.equal(out_type.ID, data_types.LongOctetString.ID, "ids should match")
        assert.are.equal(out_type:get_length(), #str + 2, "should have correct length")
        assert.are.equal(out_type.value, str, "should have value of string without length")
        assert.are.equal(out_type:serialize(), two_byte_len .. str, "should pack to the same as the input")
        out_type = data_types.get_data_type_by_id(0x44)(str)
        assert.are.equal(out_type.ID, data_types.LongCharString.ID, "ids should match")
        assert.are.equal(out_type:get_length(), #str + 2, "should have correct length")
        assert.are.equal(out_type.value, str, "should have value of string without length")
        assert.are.equal(out_type:serialize(), two_byte_len .. str, "should pack to the same as the input")
    end)
    it("should handle non-printable bytes", function()
        local str = "\x05\x00\x01\x02\x03\x04\x05"
        local out_type = data_types.parse_data_type(0x43, buf_from_str(str))
        assert.are.equal(out_type.ID, data_types.LongOctetString.ID, "ids should match")
        assert.are.equal(out_type:get_length(), #str, "should have correct length")
        assert.are.equal(out_type.value, str:sub(3, -1), "should have value of string without length")
        assert.are.equal(out_type:serialize(), str, "should pack to the same as the input")
        assert.are.equal(out_type:pretty_print(), "LongOctetString: \"\\x01\\x02\\x03\\x04\\x05\"", "should be pretty printable")
    end)
end)

describe("test array type", function()
    local len = "\x02\x00"
    local entry_one = "\x21\x01\x00"
    local entry_two = "\x21\x02\x00"
    it("should parse from a string", function()
        local out_type = data_types.parse_data_type(0x48, buf_from_str(len .. entry_one .. entry_two))
        assert.are.equal(out_type.ID, data_types.Array.ID, "ids should match")
        assert.are.equal(out_type.num_elements.value, 2, "should parse number of elements")
        assert.are.equal(out_type.elements[1].value, 1, "should parse first element correctly")
        assert.are.equal(out_type.elements[2].value, 2, "should parse second element correctly")
        assert.are.equal(out_type:get_length(), #len + #entry_one + #entry_two, "length should be correct")
        assert.are.equal(out_type:serialize(), len .. entry_one .. entry_two, "pack should match input")
    end)
    it("should be buildable from other types", function ()
        local arr_vals = {
            data_types.Uint16(1),
            data_types.Uint16(2),
        }
        local out_type = data_types.Array(arr_vals)
        assert.are.equal(out_type.ID, data_types.Array.ID, "ids should match")
        assert.are.equal(out_type.num_elements.value, 2, "should parse number of elements")
        assert.are.equal(out_type.elements[1].value, 1, "should parse first element correctly")
        assert.are.equal(out_type.elements[2].value, 2, "should parse second element correctly")
        assert.are.equal(out_type:get_length(), #len + #entry_one + #entry_two, "length should be correct")
        assert.are.equal(out_type:serialize(), len .. entry_one .. entry_two, "pack should match input")
    end)
end)

describe("test structure type", function()
    local len = "\x02\x00"
    local entry_one = "\x20\x01"
    local entry_two = "\x21\x02\x00"
    it("should parse from a string", function()
        local out_type = data_types.parse_data_type(0x4C, buf_from_str(len .. entry_one .. entry_two))
        assert.are.equal(out_type.ID, data_types.Structure.ID, "ids should match")
        assert.are.equal(out_type.num_elements.value, 2, "should parse number of elements")
        assert.are.equal(out_type.elements[1].data.value, 1, "should parse first element correctly")
        assert.are.equal(out_type.elements[1].data.ID, data_types.Uint8.ID, "should parse first element type correctly")
        assert.are.equal(out_type.elements[2].data.value, 2, "should parse second element correctly")
        assert.are.equal(out_type.elements[2].data.ID, data_types.Uint16.ID, "should parse second element type correctly")
        assert.are.equal(out_type:get_length(), #len + #entry_one + #entry_two, "length should be correct")
        assert.are.equal(out_type:serialize(), len .. entry_one .. entry_two, "pack should match input")
    end)
    it("should be buildable from other types", function ()
        local arr_vals = {
            data_types.Uint8(1),
            data_types.Uint16(2),
        }
        local out_type = data_types.Structure(arr_vals)
        assert.are.equal(out_type.ID, data_types.Structure.ID, "ids should match")
        assert.are.equal(out_type.num_elements.value, 2, "should parse number of elements")
        assert.are.equal(out_type.elements[1].data.value, 1, "should parse first element correctly")
        assert.are.equal(out_type.elements[2].data.value, 2, "should parse second element correctly")
        assert.are.equal(out_type:get_length(), #len + #entry_one + #entry_two, "length should be correct")
        assert.are.equal(out_type:serialize(), len .. entry_one .. entry_two, "pack should match input")
    end)
end)


describe("test time of day type", function()
    local hours = "\x0B"
    local minutes = "\x20"
    local seconds = "\x01"
    local hundredths = "\x63"
    it("should parse from a string", function()
        local out_type = data_types.parse_data_type(0xE0, buf_from_str(hours .. minutes .. seconds .. hundredths))
        assert.are.equal(out_type.ID, data_types.TimeOfDay.ID, "ids should match")
        assert.are.equal(out_type.hours.value, 11, "hour should be parsed correctly")
        assert.are.equal(out_type.minutes.value, 32, "minute should parse correctly")
        assert.are.equal(out_type.seconds.value, 1, "second should parse correctly")
        assert.are.equal(out_type.hundredths.value, 99, "hundredths should parse correctly")
        assert.are.equal(out_type:pretty_print(), "TimeOfDay: 11:32:01.99")
        assert.are.equal(out_type:get_length(), 4, "length should be correct")
        assert.are.equal(out_type:serialize(), hours .. minutes .. seconds .. hundredths)
    end)
    it("should be buildable from values", function()
        local out_type = data_types.TimeOfDay(11, 32, 1, 99)
        assert.are.equal(out_type.ID, data_types.TimeOfDay.ID, "ids should match")
        assert.are.equal(out_type.hours.value, 11, "hour should be parsed correctly")
        assert.are.equal(out_type.minutes.value, 32, "minute should parse correctly")
        assert.are.equal(out_type.seconds.value, 1, "second should parse correctly")
        assert.are.equal(out_type.hundredths.value, 99, "hundredths should parse correctly")
        assert.are.equal(out_type:pretty_print(), "TimeOfDay: 11:32:01.99")
        assert.are.equal(out_type:get_length(), 4, "length should be correct")
        assert.are.equal(out_type:serialize(), hours .. minutes .. seconds .. hundredths)
    end)
end)

describe("test Date type", function()
    local year = "\x77"
    local month = "\x02"
    local day_of_month = "\x1A"
    local day_of_week = "\x02"
    it("should parse from a string", function()
        local out_type = data_types.parse_data_type(0xE1, buf_from_str(year .. month .. day_of_month .. day_of_week))
        assert.are.equal(out_type.ID, data_types.Date.ID, "ids should match")
        assert.are.equal(out_type.year.value, 119, "year should be parsed correctly")
        assert.are.equal(out_type.month.value, 2, "month should parse correctly")
        assert.are.equal(out_type.day_of_month.value, 26, "day of month should parse correctly")
        assert.are.equal(out_type.day_of_week.value, 2, "day of week should parse correctly")
        assert.are.equal(out_type:pretty_print(), "<Date: Tuesday February 26 2019>")
        assert.are.equal(out_type:get_length(), 4, "length should be correct")
        assert.are.equal(out_type:serialize(), year .. month .. day_of_month .. day_of_week)
    end)
    it("Should be buildable from values", function()
        local out_type = data_types.Date(2019, 2, 26, 2)
        assert.are.equal(out_type.ID, data_types.Date.ID, "ids should match")
        assert.are.equal(out_type.year.value, 119, "year should be parsed correctly")
        assert.are.equal(out_type.month.value, 2, "month should parse correctly")
        assert.are.equal(out_type.day_of_month.value, 26, "day of month should parse correctly")
        assert.are.equal(out_type.day_of_week.value, 2, "day of week should parse correctly")
        assert.are.equal(out_type:pretty_print(), "<Date: Tuesday February 26 2019>")
        assert.are.equal(out_type:get_length(), 4, "length should be correct")
        assert.are.equal(out_type:serialize(), year .. month .. day_of_month .. day_of_week)
    end)
end)

describe("test NoData type", function()
    it("Should be parsable from a string", function()
        local out_type = data_types.NoData.deserialize(buf_from_str(""))
        assert.are.equal(out_type.ID, data_types.NoData.ID, "ids should match")
        assert.are.equal(out_type:pretty_print(), "<NoData>")
        assert.are.equal(out_type:get_length(), 0, "length should be correct")
        assert.are.equal(out_type:serialize(), "")
    end)
end)
