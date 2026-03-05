extends Resource
class_name AudioSettings

@export var masterVolume: float = 0.5
@export var musicVolume: float = 1.0
@export var sfxVolume: float = 1.0
@export var muted:bool = false


func create_save() -> String:
	var dic  = {}
	dic["master"] = self.masterVolume
	dic["music"] = self.musicVolume
	dic["sfx"] = self.sfxVolume
	dic["muted"] = self.muted
	return JSON.stringify(dic)
	
func from_save(file: FileAccess) -> AudioSettings:
	var json = JSON.parse_string(file.get_as_text())
	if json:
		json = json as Dictionary
		self.masterVolume = json["master"]
		self.musicVolume = json["music"]
		self.sfxVolume = json["sfx"]
		self.muted = json["muted"]
	return self
	
