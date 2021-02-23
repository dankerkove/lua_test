local capabilities = require "st.capabilities"

describe("test capability utils number attr", function()
  local attr_schema = {
    type = "object",
    additionalProperties = false,
    properties = {
      value = {
        type = "number",
        minimum = 0,
        maximum = 150
      }
    },
    required = {
      "value",
    },
  }
  local cap = {NAME="my_cap"}
  it("should accept a schema for the attribute", function()
    capabilities.add_attribute(cap, "my_attr", attr_schema)
  end)
  it("should allow event creation by attr name", function()
    local event = cap.my_attr(123)
    assert.are.equal(event.value.value, 123)
    event = cap.my_attr({value = 123})
    assert.are.equal(event.value.value, 123)
    event = cap.my_attr(123.2)
    assert.are.equal(event.value.value, 123.2)
  end)
  it("should allow event creation by attr equal to bounds", function()
    local event = cap.my_attr(0)
    assert.are.equal(event.value.value, 0)
    event = cap.my_attr({value = 150})
    assert.are.equal(event.value.value, 150)
  end)
  it("should reject a non-number value", function()
    local errfn = function()
      return cap.my_attr("asdf")
    end
    assert.has_error(errfn, "Value asdf is invalid for my_cap.my_attr", "should reject invalid types")
  end)
  it("should reject a value outside the range", function()
    local errfn = function()
      return cap.my_attr(-1)
    end
    assert.has_error(errfn, "Value -1 is invalid for my_cap.my_attr", "should reject value below minimum")
    errfn = function()
      return cap.my_attr(200)
    end
    assert.has_error(errfn, "Value 200 is invalid for my_cap.my_attr", "should reject value above maximum")
  end)
end)

describe("test capability utils integer attr", function()
  local attr_schema = {
    type = "object",
    additionalProperties = false,
    properties = {
      value = {
        type = "integer",
      }
    },
    required = {
      "value",
    },
  }
  local cap = {NAME="my_cap"}
  it("should accept a schema for the attribute", function()
    capabilities.add_attribute(cap, "my_attr", attr_schema)
  end)
  it("should allow event creation by attr name", function()
    local event = cap.my_attr(123)
    assert.are.equal(event.value.value, 123)
    event = cap.my_attr({value = 123})
    assert.are.equal(event.value.value, 123)
  end)
  it("should reject a non-number value", function()
    local errfn = function()
      return cap.my_attr("asdf")
    end
    assert.has_error(errfn, "Value asdf is invalid for my_cap.my_attr", "should reject invalid types")
  end)
  it("should reject a non-integer value", function()
    local errfn = function()
      return cap.my_attr(123.3)
    end
    assert.has_error(errfn, "Value 123.3 is invalid for my_cap.my_attr", "should reject non-integers")
  end)
end)

describe("test capability utils enum attr", function()
  local attr_schema = {
    type = "object",
    additionalProperties = false,
    properties = {
      value = {
        type = "string",
        enum = {
          "on",
          "off"
        }
      }
    },
    required = {
      "value",
    },
  }
  local cap = {NAME="my_cap"}
  it("should accept a schema for the attribute", function()
    capabilities.add_attribute(cap, "my_attr", attr_schema)
  end)
  it("should allow event creation by attr name", function()
    local event = cap.my_attr("on")
    assert.are.equal(event.value.value, "on")
    event = cap.my_attr({value = "on"})
    assert.are.equal(event.value.value, "on")
    event = cap.my_attr.on()
    assert.are.equal(event.value.value, "on")
  end)
  it("should reject a non-enum value", function()
    local errfn = function()
      return cap.my_attr("asdf")
    end
    assert.has_error(errfn, "Value asdf is invalid for my_cap.my_attr", "should reject invalid values")
  end)
end)

describe("test capability defintion loading from JSON", function()
  -- Can't test type inlining as it requires the generated code
  local cap_json = [[{"name": "Switch Level", "status": "live", "attributes": {"level": {"schema": {"title": "IntegerPercent", "type": "object", "additionalProperties": false, "properties": {"value": {"type": "integer", "minimum": 0, "maximum": 100}, "unit": {"type": "string", "enum": ["%"], "default": "%"}}, "required": ["value"]}, "type": "NUMBER", "setter": "setLevel"}}, "commands": {"setLevel": {"arguments": [{"name": "level", "schema": {"type": "integer", "minimum": 0, "maximum": 100}, "type": "NUMBER", "required": true}, {"name": "rate", "schema": {"title": "PositiveInteger", "type": "integer", "minimum": 0}, "type": "NUMBER", "required": false}]}}, "public": true, "id": "switchLevel", "ocfResourceType": "oic.r.light.dimming", "version": 1}]]
  it("should build the cap from json", function()
    local cap = capabilities.build_cap_from_json_string(cap_json)
    assert.are.equal(cap.NAME, "SwitchLevel", "name should be correct")
    assert.are.equal(cap.level(55).value.value, 55, "should be able to generate attribute event")
    -- TODO: change if we use error calls

    local errfn = function()
      return cap.level(150)
    end
    assert.has_error(errfn, "Value 150 is invalid for SwitchLevel.level", "should reject invalid values")
    assert.is_true(cap.commands["setLevel"]:validate_and_normalize_command({capability = "switchLevel", command = "setLevel", component = "main", args = {27}}), "commands should validate when correct")

    local errfn = function()
      return cap.commands["setLevel"]:validate_and_normalize_command({capability = "switchLevel", command = "setLevel", component = "main", args = {5000}})
    end
    assert.has_error(errfn, "Invalid value for SwitchLevel.setLevel arg: level value: 5000")
  end)
end)

describe("test capability type validation", function()
  local attr_schema = {
    type = "object",
    additionalProperties = false,
    properties = {
      num_value = {
        type = "number",
        minimum = 0,
        maximum = 150
      },
      string_value = {
        type = "string"
      },
      bool_value = {
        type = "boolean"
      },
    },
    required = {
      "num_value",
      "string_value",
      "bool_value",
    }
  }
  local cap = {NAME="my_cap"}
  it("should accept a schema for the attribute", function()
    capabilities.add_attribute(cap, "my_attr", attr_schema)
  end)
  it("should validate simple values", function()
    local event  = cap.my_attr({num_value = 1, string_value = "asdf", bool_value = true})
    assert.are.equal(event.value.num_value, 1)
    assert.are.equal(event.value.string_value, "asdf")
    assert.are.equal(event.value.bool_value, true)
  end)
end)
