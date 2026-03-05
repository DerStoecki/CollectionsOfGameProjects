extends AudioStreamPlayer2D
class_name GameStart

@onready var gm : GameManager = $".."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if !self.playing and !self.gm.gameOver():
		self.play()
