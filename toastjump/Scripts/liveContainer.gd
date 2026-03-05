extends HBoxContainer

@onready var life : PackedScene = preload("res://Scenes/heart.tscn")

@onready var lh : LifeHandler = $"../../LifeHandler"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	createLifes()
	lh.lifesChanged.connect(Callable(self, "_on_lifes_changed"))

func _on_lifes_changed():
	for child in get_children():
		child.queue_free()
	createLifes()
	
func createLifes():
	for x in lh.curLifes:
		self.add_child(life.instantiate())
