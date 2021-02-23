return [[{"name": "Air Conditioner Mode", "status": "proposed", "attributes": {"airConditionerMode": {"schema": {"type": "object", "additionalProperties": false, "properties": {"value": {"$ref": "String"}}, "required": ["value"]}, "type": "STRING", "setter": "setAirConditionerMode"}, "supportedAcModes": {"schema": {"type": "object", "additionalProperties": false, "properties": {"value": {"type": "array", "items": {"type": "string"}}}}, "type": "JSON_OBJECT"}}, "commands": {"setAirConditionerMode": {"arguments": [{"name": "mode", "required": true, "schema": {"$ref": "String"}, "type": "STRING"}]}}, "public": true, "id": "airConditionerMode", "ocfResourceType": "x.com.st.mode.airconditioner", "version": 1}]]
