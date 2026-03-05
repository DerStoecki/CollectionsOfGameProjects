extends ProgressBar

@onready var player : Player = $"../../ToastPlayer"
@onready var gameManager: GameManager = $"../.."
# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	self.visible = true
	self.value = player.stamina
	pass
