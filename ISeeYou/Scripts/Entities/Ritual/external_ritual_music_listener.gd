extends AudioStreamPlayer
class_name RitualMusicListener


@export var preBoss : AudioStream
@export var boss: AudioStream
@export var postBoss: AudioStream

var bossFight = false


func _on_ritual_ritual_initiated() -> void:
	self.playing = false



func _on_ritual_ritual_started(_ritual: Ritual) -> void:
	self.stream = preBoss
	self.bossFight = true
	self.play()
	
	



func _on_ritual_ritual_ended() -> void:
	self.playing = false
	self.stream = postBoss
	self.play()


func _on_finished() -> void:
	if self.bossFight : 
		self.stream = boss
		self.play()
		self.bossFight = false
