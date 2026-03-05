extends AudioStreamPlayer




func _on_timer_timeout() -> void:
	self.pitch_scale = 1 + randf_range(-0.05, 0.05)
	self.play()
