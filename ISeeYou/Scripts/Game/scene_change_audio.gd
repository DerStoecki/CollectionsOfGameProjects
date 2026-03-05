extends AudioStreamPlayer
class_name SceneChangeAudio

@export_range(0, 0.3) var pitchRange : float

@onready var gm: GameManager = $"../GameManager"

func play_with_pitch_shift():
	var pitch = self.gm.rng.randf_range(pitchRange * -1, pitchRange)
	self.pitch_scale = 1.0 + pitch
	self.play()
	
