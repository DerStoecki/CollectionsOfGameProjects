extends EnemyDetector

class_name EnemyDetectorSameGrid

## This detects Enemys that are on the same Grid as the Pawn. 
## Get your own position by asking the GridManager
## Get all Pawns at your own position
## Update detected_enemies and call parent method.
## either same grid or overlapping areas! (when in same y pos)
# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	pass # Replace with function body.

func _setup():
	pass

## Child Implementation of Detect enemies, call this by animationplayer
func detect_enemies() -> void: # only call 
	if self.parentPawn.get_gridManager() == null: # should be redundant but just in case
		return
	var manager : GridManager = self.parentPawn.get_gridManager()
	var current_cell_position : Vector2i = manager.local_to_map(self.parentPawn.position)
	appendPawns(current_cell_position, manager)
	if detected_enemies.size() == 0 and self.parentPawn.has_Collided():
		current_cell_position-= Vector2i(-1, 0)
		appendPawns(current_cell_position, manager)
	super.detect_enemies()


func appendPawns(current_cell_position: Vector2i, manager: GridManager):
	var pawns_in_cell : Array[Pawn] = manager.get_pawns_in_cell(current_cell_position)
	for pawn in pawns_in_cell:
		if is_enemy_or_remove(pawn) and pawn not in detected_enemies:
			detected_enemies.append(pawn)
