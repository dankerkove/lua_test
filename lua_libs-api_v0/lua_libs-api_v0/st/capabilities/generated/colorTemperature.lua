return [[{"name": "Color Temperature", "status": "live", "attributes": {"colorTemperature": {"schema": {"type": "object", "additionalProperties": false, "properties": {"value": {"type": "integer", "minimum": 1, "maximum": 30000}, "unit": {"type": "string", "enum": ["K"], "default": "K"}}, "required": ["value"]}, "type": "NUMBER", "setter": "setColorTemperature"}}, "commands": {"setColorTemperature": {"arguments": [{"name": "temperature", "required": true, "schema": {"type": "integer", "minimum": 1, "maximum": 30000}, "type": "NUMBER"}]}}, "public": true, "id": "colorTemperature", "ocfResourceType": "x.com.st.color.temperature", "version": 1}]]
