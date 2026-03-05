extends AnimationPlayer
class_name TestGameWonAnimation

@export var gm: GameManager

func _process(_delta):
	if gm.win:
		self.play("Spawn_Won_Pawn")
		self.set_process(false)
	
