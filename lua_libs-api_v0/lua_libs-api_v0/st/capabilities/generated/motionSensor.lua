return [[{"name": "Motion Sensor", "status": "live", "attributes": {"motion": {"schema": {"type": "object", "additionalProperties": false, "properties": {"value": {"$ref": "ActivityState"}}, "required": ["value"]}, "type": "ENUM", "values": ["active", "inactive"]}}, "commands": {}, "public": true, "id": "motionSensor", "ocfResourceType": "oic.r.sensor.motion", "version": 1}]]
