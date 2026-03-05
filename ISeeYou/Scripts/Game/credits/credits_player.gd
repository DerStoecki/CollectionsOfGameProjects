extends AnimationPlayer
class_name CreditsPlayer

func _ready():
	self.call_deferred("play", "Credits")
