extends VBoxContainer
class_name AudioSettingsLoader

@onready var master: HSlider = $Master/HSlider
@onready var music : HSlider = $Music/HSlider
@onready var sfx: HSlider = $SFX/HSlider
@onready var muted: CheckBox = $CheckBox

#var audio_path : String = "res://Resources/SoundSettings/SoundSettings.json"
var audio_path : String = "user://SoundSettings.json"
var audio_settings: AudioSettings

func _ready() -> void:
	if not FileAccess.file_exists(audio_path):
		audio_settings = AudioSettings.new()
		audio_settings.masterVolume = 0.5
		audio_settings.musicVolume = 1.0
		audio_settings.sfxVolume = 1.0
		audio_settings.muted = false
		save()
		return
	else:
		var file : FileAccess = FileAccess.open(audio_path, FileAccess.READ)
		self.audio_settings = AudioSettings.new().from_save(file)
		self.master.set_value(audio_settings.masterVolume)
		self.sfx.set_value(audio_settings.sfxVolume)
		self.music.set_value(audio_settings.musicVolume)
		self.muted._on_toggled(audio_settings.muted)
	
func save():
	var file : FileAccess = FileAccess.open(audio_path, FileAccess.WRITE_READ)
	file.store_string(self.audio_settings.create_save())

	
