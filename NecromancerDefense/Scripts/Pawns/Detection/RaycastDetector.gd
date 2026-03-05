extends EnemyDetector

## TODO and unused -> potential Raycast -> with a radius -> like a "scanner"/circling tower

@export var ray_length: float = 200.0

var _raycast: RayCast2D = null

func _setup() -> void:
	_raycast = RayCast2D.new()
	add_child(_raycast)
	_raycast.enabled = true
	_raycast.cast_to = Vector2(ray_length, 0)

func _detect_enemies() -> void:
	if _raycast.is_colliding():
		var collider = _raycast.get_collider()
		if collider.is_in_group(enemyGroup):
			emit_signal("enemy_detected", collider)
