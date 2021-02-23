return [[{"name": "Audio Capture", "status": "proposed", "attributes": {"clip": {"schema": {"type": "object", "additionalProperties": false, "properties": {"value": {"$ref": "JsonObject"}}, "required": ["value"]}, "type": "JSON_OBJECT", "actedOnBy": ["capture"]}, "stream": {"schema": {"type": "object", "additionalProperties": false, "properties": {"value": {"$ref": "JsonObject"}}, "required": ["value"]}, "type": "JSON_OBJECT"}}, "commands": {"capture": {"arguments": [{"name": "startTime", "type": "DATE", "required": true, "schema": {"$ref": "Iso8601Date"}}, {"name": "captureTime", "type": "DATE", "required": true, "schema": {"$ref": "Iso8601Date"}}, {"name": "endTime", "type": "DATE", "required": true, "schema": {"$ref": "Iso8601Date"}}, {"name": "correlationId", "type": "STRING", "required": false, "schema": {"$ref": "String"}}, {"name": "reason", "type": "STRING", "required": false, "schema": {"$ref": "String"}}]}}, "public": false, "id": "audioCapture", "version": 1}]]
