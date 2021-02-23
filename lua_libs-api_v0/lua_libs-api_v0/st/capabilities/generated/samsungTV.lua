return [[{"name": "Samsung TV", "status": "live", "attributes": {"messageButton": {"schema": {"type": "object", "additionalProperties": false, "properties": {"value": {"$ref": "JsonObject"}}}, "type": "JSON_OBJECT"}, "mute": {"schema": {"type": "object", "additionalProperties": false, "properties": {"value": {"type": "string", "enum": ["muted", "unknown", "unmuted"]}}}, "type": "ENUM", "values": ["muted", "unknown", "unmuted"], "enumCommands": [{"command": "mute", "value": "muted"}, {"command": "unmute", "value": "unmuted"}]}, "pictureMode": {"schema": {"type": "object", "additionalProperties": false, "properties": {"value": {"type": "string", "enum": ["dynamic", "movie", "standard", "unknown"]}}}, "type": "ENUM", "values": ["dynamic", "movie", "standard", "unknown"], "setter": "setPictureMode"}, "soundMode": {"schema": {"type": "object", "additionalProperties": false, "properties": {"value": {"type": "string", "enum": ["clear voice", "movie", "music", "standard", "unknown"]}}}, "type": "ENUM", "values": ["clear voice", "movie", "music", "standard", "unknown"], "setter": "setSoundMode"}, "switch": {"schema": {"type": "object", "additionalProperties": false, "properties": {"value": {"$ref": "SwitchState"}}}, "type": "ENUM", "values": ["off", "on"], "enumCommands": [{"command": "on", "value": "on"}, {"command": "off", "value": "off"}]}, "volume": {"schema": {"type": "object", "additionalProperties": false, "properties": {"value": {"$ref": "PositiveInteger"}}}, "type": "NUMBER", "setter": "setVolume", "actedOnBy": ["volumeUp", "volumeDown"]}}, "commands": {"mute": {"arguments": []}, "off": {"arguments": []}, "on": {"arguments": []}, "setPictureMode": {"arguments": [{"type": "ENUM", "required": true, "name": "pictureMode", "schema": {"type": "string", "enum": ["dynamic", "movie", "standard"]}, "values": ["dynamic", "movie", "standard"]}]}, "setSoundMode": {"arguments": [{"type": "ENUM", "required": true, "name": "soundMode", "schema": {"type": "string", "enum": ["clear voice", "movie", "music", "standard"]}, "values": ["clear voice", "movie", "music", "standard"]}]}, "setVolume": {"arguments": [{"type": "NUMBER", "required": true, "name": "volume", "schema": {"$ref": "PositiveInteger"}}]}, "showMessage": {"arguments": [{"type": "STRING", "required": true, "name": "1", "schema": {"$ref": "String"}}, {"type": "STRING", "required": true, "name": "2", "schema": {"$ref": "String"}}, {"type": "STRING", "required": true, "name": "3", "schema": {"$ref": "String"}}, {"type": "STRING", "required": true, "name": "4", "schema": {"$ref": "String"}}]}, "unmute": {"arguments": []}, "volumeDown": {"arguments": []}, "volumeUp": {"arguments": []}}, "public": false, "id": "samsungTV", "version": 1}]]
