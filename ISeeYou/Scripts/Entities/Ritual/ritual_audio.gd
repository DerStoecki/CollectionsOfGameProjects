extends AudioStreamPlayer
class_name RitualAudioPlayer

@export var ritualSites: Array[RitualSiteInteract]
@export var ritualPrepareOST : Array[AudioStream]
@export var ritualStartedOST: AudioStream
var count : int = -1

func _ready():
	for rite in ritualSites:
		if not rite.interact.is_connected(_on_totem_interaction):
			rite.interact.connect(_on_totem_interaction)
		
		
func _on_totem_interaction(_id: int):
	if count == -1:
		self.call_deferred("play", true)
	self.count += 1
	self.count = min(self.count, ritualPrepareOST.size() - 1)
	var position = self.get_playback_position()
	self.stream = self.ritualPrepareOST[self.count]
	self.play(position)



func _on_ritual_ritual_started(_ritual: Ritual) -> void:
	self.playing = false


func _on_ritual_ritual_ended() -> void:
	self.autoplay = false
	self.call_deferred("stop")
