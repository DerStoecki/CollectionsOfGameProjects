extends AudioStreamPlayer2D
class_name FootSteps

var sounds : Dictionary[int, AudioStreamRandomizer] = {
	0: preload("res://Resources/SFX/FootSteps/Wood_FootSteps_Randomizer.tres"),
	1: preload("res://Resources/SFX/FootSteps/Stone_FootSteps_Randomizer.tres"),
	2: preload("res://Resources/SFX/FootSteps/Wood_Alt_FootSteps_Randomizer.tres"),
	3: preload("res://Resources/SFX/FootSteps/Stone_Alt_FootSteps_Randomizer.tres"),
	4: preload("res://Resources/SFX/FootSteps/Wet_FootSteps_Randomizer.tres")
}

func set_sound(index: int):
	if self.sounds.has(index):
		self.stream = self.sounds[index]
		

func play_footStep():
	self.play()
