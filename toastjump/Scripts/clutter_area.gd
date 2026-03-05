extends Area2D

class_name Clutter

@export var spawnPointStart : Node2D
@export var spawnPointEnd : Node2D

@export var direction : Vector2 = Vector2(1, 0)
@export var speed : int = 200

var wasTouched : bool = false

signal clutter_touched()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is Sprite2D:
			child.rotation = randi_range(0, 359)
			child.position.x = randf_range(spawnPointStart.position.x, spawnPointEnd.position.x)
			child.position.y = randf_range(spawnPointStart.position.y, spawnPointEnd.position.y)

func _process(delta: float) -> void:
	self.position += delta * speed * direction

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if !wasTouched:
			clutter_touched.emit()
			wasTouched = true
		self.set_deferred("Monitoring", false)
		self.set_deferred("Monitorable", false)
		
