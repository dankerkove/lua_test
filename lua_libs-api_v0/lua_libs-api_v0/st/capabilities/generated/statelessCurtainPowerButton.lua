return [[{"name": "Stateless Curtain Power Button", "status": "proposed", "attributes": {"availableCurtainPowerButtons": {"schema": {"type": "object", "additionalProperties": false, "properties": {"value": {"type": "array", "items": {"type": "string", "enum": ["open", "close", "pause"]}}}}, "type": "JSON_OBJECT"}}, "commands": {"setButton": {"arguments": [{"name": "button", "required": true, "schema": {"type": "string", "enum": ["open", "close", "pause"]}, "type": "ENUM", "values": ["open", "close", "pause"]}]}}, "public": true, "id": "statelessCurtainPowerButton", "version": 1}]]
