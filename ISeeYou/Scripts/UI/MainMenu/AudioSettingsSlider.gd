extends HSlider
class_name AudioSettingsSlider


@onready var parent: AudioSettingsLoader = $"../.."
@export var bus_name : String 
var bus_index: int
@export var audioType : AudioType = AudioType.MASTER

enum AudioType {MASTER, MUSIC, SFX}


func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)
	value_changed.connect(_on_value_changed)
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))

func _on_value_changed(val: float) -> void:
	AudioServer.set_bus_volume_db(bus_index,
	linear_to_db(val)
	)
	if not self.parent.audio_settings:
		return
	match(audioType):
		AudioType.MASTER: self.parent.audio_settings.masterVolume = val
		AudioType.MUSIC:  self.parent.audio_settings.musicVolume = val
		AudioType.SFX : self.parent.audio_settings.sfxVolume = val
