return [[{"name": "Window Shade", "status": "live", "attributes": {"windowShade": {"schema": {"type": "object", "additionalProperties": false, "properties": {"value": {"$ref": "OpenableState"}, "constraints": {"type": "object", "additionalProperties": false, "properties": {"values": {"type": "array", "items": {"$ref": "OpenableState"}}}}}, "required": ["value"]}, "type": "ENUM", "values": ["closed", "closing", "open", "opening", "partially open", "unknown"], "enumCommands": [{"command": "close", "value": "closed"}, {"command": "open", "value": "open"}], "actedOnBy": ["open", "close", "pause"]}, "supportedWindowShadeCommands": {"schema": {"type": "object", "additionalProperties": false, "properties": {"value": {"type": "array", "items": {"type": "string", "enum": ["open", "close", "pause"]}}}}, "type": "JSON_OBJECT"}}, "commands": {"close": {"arguments": []}, "open": {"arguments": []}, "pause": {"arguments": []}}, "public": true, "id": "windowShade", "version": 1}]]
