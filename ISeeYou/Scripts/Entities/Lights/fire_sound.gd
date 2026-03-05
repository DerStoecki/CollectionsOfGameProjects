extends AudioStreamPlayer2D
class_name FireAudio

@export var fire_loop: AudioStream
@export var fire_light_up: AudioStream

func _on_interact_area_interacted() -> void:
	self.stream = self.fire_light_up
	self.pitch_scale = 1 + randf_range(-0.1, 0.1)
	self.play()
	



func _on_finished() -> void:
	self.stream = self.fire_loop
	self.volume_db = 0
	self.pitch_scale = 1
	self.play()
