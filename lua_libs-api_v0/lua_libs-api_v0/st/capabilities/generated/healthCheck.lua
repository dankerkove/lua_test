return [[{"name": "Health Check", "status": "live", "attributes": {"checkInterval": {"schema": {"type": "object", "additionalProperties": false, "properties": {"value": {"type": "integer", "minimum": 0, "maximum": 604800}, "data": {"type": "object", "additionalProperties": false, "properties": {"deviceScheme": {"type": "string", "enum": ["MIXED", "TRACKED", "UNTRACKED"]}, "hubHardwareId": {"type": "string", "pattern": "^[0-9a-fA-F]{4}$"}, "protocol": {"$ref": "DeviceHealthProtocol"}, "offlinePingable": {"type": "string", "enum": ["0", "1"]}, "badProperty": {"type": "string"}}}, "unit": {"type": "string", "enum": ["s"], "default": "s"}}, "required": ["value"]}, "type": "NUMBER"}, "DeviceWatch-DeviceStatus": {"schema": {"type": "object", "additionalProperties": false, "properties": {"value": {"type": "string", "enum": ["online", "offline"]}, "data": {"type": "object", "additionalProperties": false, "properties": {"deviceScheme": {"type": "string", "enum": ["MIXED", "TRACKED", "UNTRACKED"]}, "badProperty": {"type": "string"}}}}, "required": ["value"]}, "type": "ENUM", "values": ["online", "offline"], "actedOnBy": ["ping"]}, "healthStatus": {"schema": {"type": "object", "additionalProperties": false, "properties": {"value": {"type": "string", "enum": ["online", "offline"]}, "data": {"type": "object", "additionalProperties": false, "properties": {"deviceScheme": {"type": "string", "enum": ["MIXED", "TRACKED", "UNTRACKED"]}, "badProperty": {"type": "string"}}}}, "required": ["value"]}, "type": "ENUM", "values": ["online", "offline"], "actedOnBy": ["ping"]}, "DeviceWatch-Enroll": {"schema": {"type": "object", "additionalProperties": false, "properties": {"value": {"$ref": "DeviceHealthEnroll"}}, "required": ["value"]}, "type": "JSON_OBJECT"}}, "commands": {"ping": {"arguments": []}}, "public": false, "id": "healthCheck", "version": 1}]]
