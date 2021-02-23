return [[{"name": "Security System", "status": "live", "attributes": {"securitySystemStatus": {"schema": {"type": "object", "additionalProperties": false, "properties": {"value": {"type": "string", "enum": ["armedAway", "armedStay", "disarmed"]}}, "required": ["value"]}, "type": "ENUM", "values": ["armedAway", "armedStay", "disarmed"], "enumCommands": [{"command": "armStay", "value": "armedStay"}, {"command": "armAway", "value": "armedAway"}, {"command": "disarm", "value": "disarmed"}]}, "alarm": {"schema": {"type": "object", "additionalProperties": false, "properties": {"value": {"$ref": "String"}}, "required": ["value"]}, "type": "STRING"}}, "commands": {"armStay": {"arguments": [{"name": "bypassAll", "required": true, "schema": {"type": "boolean"}, "type": "BOOLEAN"}]}, "armAway": {"arguments": [{"name": "bypassAll", "required": true, "schema": {"type": "boolean"}, "type": "BOOLEAN"}]}, "disarm": {"arguments": []}}, "public": false, "id": "securitySystem", "version": 1}]]
