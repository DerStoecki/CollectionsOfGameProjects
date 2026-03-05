extends EnemyDetector

class_name EnemyDetectorLine

## Detects Enemies in your own row when in a certain range.
## TODO check if it is nec. to check all positions or cancel when one enemy is detected.


@export var detection_range: int = 5  # Number of cells to detect in the direction
@export var detection_direction: Vector2i = Vector2i(1, 0)  # Default to right

func _ready():
	super._ready()
	pass # Replace with function body.

func _setup():
	pass

func detect_enemies() -> void: # only call on init
	self.detected_enemies.clear()
	#print(str("Pawn: ", self.parentPawn.name , " Detecting ..."))
	if self.parentPawn.get_gridManager() == null: # should be redundant but just in case
		return
	var grid_manager : GridManager = self.parentPawn.get_gridManager()
	var current_position = grid_manager.local_to_map(self.parentPawn.position)
	for i in range(detection_range + 1):
		var check_position = current_position + detection_direction * i
		var pawns_in_cell = grid_manager.get_pawns_in_cell(check_position)
		for pawn in pawns_in_cell:
			if is_enemy_or_remove(pawn) and pawn not in detected_enemies:
				detected_enemies.append(pawn)
	super.detect_enemies() # emits signal of detected enemies
