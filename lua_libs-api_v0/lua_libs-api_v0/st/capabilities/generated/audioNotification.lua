return [[{"name": "Audio Notification", "status": "live", "attributes": {}, "commands": {"playTrack": {"arguments": [{"name": "uri", "required": true, "schema": {"$ref": "URI"}, "type": "STRING"}, {"name": "level", "schema": {"type": "integer", "minimum": 0, "maximum": 100}, "type": "NUMBER", "required": false}]}, "playTrackAndResume": {"arguments": [{"name": "uri", "required": true, "schema": {"$ref": "URI"}, "type": "STRING"}, {"name": "level", "schema": {"type": "integer", "minimum": 0, "maximum": 100}, "type": "NUMBER", "required": false}]}, "playTrackAndRestore": {"arguments": [{"name": "uri", "required": true, "schema": {"$ref": "URI"}, "type": "STRING"}, {"name": "level", "schema": {"type": "integer", "minimum": 0, "maximum": 100}, "type": "NUMBER", "required": false}]}}, "public": true, "id": "audioNotification", "ocfResourceType": "x.com.st.audionotification", "version": 1}]]
