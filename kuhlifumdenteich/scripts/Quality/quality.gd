class_name Quality extends Resource


enum bpQuality {	
	IMPOSSIBLE,
	BAD,
	OK,
	GOOD,
	VERY_GOOD,
	PERFECT	
	}
	
static func get_key_from_bpQuality_value(value: int) -> String:
	for key in bpQuality.keys():
		if bpQuality[key] == value:
			return key
	return ""  # Value not found
