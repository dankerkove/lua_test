return [[{"name": "Switch", "status": "live", "attributes": {"switch": {"schema": {"type": "object", "additionalProperties": false, "properties": {"value": {"$ref": "SwitchState"}}, "required": ["value"]}, "type": "ENUM", "values": ["off", "on"], "enumCommands": [{"command": "on", "value": "on"}, {"command": "off", "value": "off"}]}}, "commands": {"off": {"arguments": []}, "on": {"arguments": []}}, "public": true, "id": "switch", "ocfResourceType": "x.com.st.powerswitch", "version": 1}]]
