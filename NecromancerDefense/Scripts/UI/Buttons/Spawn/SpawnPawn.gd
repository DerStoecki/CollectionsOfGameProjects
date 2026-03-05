extends Button

## Not needed anymore
@export var grid_manager_path: NodePath
@export var pawn_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", Callable(self, "_on_button_pressed"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_button_pressed():
	var grid_manager  = get_node(grid_manager_path) as GridManager
	if grid_manager and self.pawn_scene:
		grid_manager.set_pawn_scene(self.pawn_scene)
		grid_manager.place_pawn(2,2)
		
