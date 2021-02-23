local base64 = require "st.base64"

describe("test base64 encode", function()
  it("should encode to proper base 64", function()
    assert.are.equal(base64.encode("this is a string!!"), "dGhpcyBpcyBhIHN0cmluZyEh")
  end)
  it("should pad to be multiple fo 4 bytes long", function()
    local hubID = "\xD0\x52\xA8\x00\x00\xEF\x00\x0B"
    assert.are.equal(base64.encode(hubID), "0FKoAADvAAs=")
  end)
end)

describe("test base64 decode", function()
  it("should decode from base 64 to string", function()
    assert.are.equal(base64.decode("dGhpcyBpcyBhIHN0cmluZyEh"), "this is a string!!")
  end)
  it("should handle a padded base64 string", function()
    local hubID = "\xD0\x52\xA8\x00\x00\xEF\x00\x0B"
    assert.are.equal(base64.decode("0FKoAADvAAs="), hubID)
  end)
end)

describe("test base64 round trip", function()
  it("should be able to encode and decode to end up with the same result", function()
    local u = require "st.utils"
    math.randomseed(os.time())
    for i = 1,100 do
      local test_str = ""
      for j = 1, 10 do
        test_str = test_str .. string.char(math.random(0, 255))
      end
      assert.are.equal(test_str, base64.decode(base64.encode(test_str)))
    end
  end)
end)
