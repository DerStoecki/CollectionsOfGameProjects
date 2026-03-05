extends AudioStreamPlayer2D
class_name EnemyAudio


func _ready():
	self.stream_paused = true
	
func forbid():
	self.stream_paused = true
	
func allow():
	self.stream_paused = false
	self.play()
	
func _on_finished() -> void:
	if self.stream_paused:
		return
	self.play()
