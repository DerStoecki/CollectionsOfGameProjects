extends AudioStreamPlayer2D
class_name GameStop

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if !self.playing:
		self.play()
