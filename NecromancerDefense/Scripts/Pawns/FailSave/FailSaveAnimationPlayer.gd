extends AnimationPlayer

@export var parent: PanCake

# Called when the node enters the scene tree for the first time.
func _ready():
	parent.startPancaking.connect(Callable(self, "_on_start"))

func _on_start():
	self.play("Pancake")
