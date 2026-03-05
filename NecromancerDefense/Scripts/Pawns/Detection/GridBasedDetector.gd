extends EnemyDetector


### TODO and Unused at the moment -> is an AoE Detector
@export var detect_radius_x: int = 3  # Number of grid cells to check around
@export var detect_radius_y: int = 3 

func _ready():
	super._ready()


func _detect_enemies() -> void:
	if self.grid_manager == null:
		return
	var cell_pos = self.grid_manager.local_to_map(global_position)
	for x in range(-detect_radius_x, detect_radius_x + 1):
		for y in range(-detect_radius_y, detect_radius_y + 1):
			var check_pos = cell_pos + Vector2(x, y)
			var pawn = self.grid_manager.get_pawn_at(check_pos)
			if pawn and pawn.is_in_group(enemyGroup):
				emit_signal("enemy_detected", pawn)
				return
