return [[{"name": "Stateless Audio Volume Button", "status": "live", "attributes": {"availableAudioVolumeButtons": {"schema": {"type": "object", "additionalProperties": false, "properties": {"value": {"type": "array", "items": {"type": "string", "enum": ["volumeUp", "volumeDown"]}}}}, "type": "JSON_OBJECT"}}, "commands": {"setButton": {"arguments": [{"name": "button", "required": true, "schema": {"type": "string", "enum": ["volumeUp", "volumeDown"]}, "type": "ENUM", "values": ["volumeUp", "volumeDown"]}]}}, "public": true, "id": "statelessAudioVolumeButton", "version": 1}]]
