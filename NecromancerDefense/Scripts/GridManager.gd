extends TileMapLayer
class_name  GridManager

## The GridManager is one of the more complex classes
## It handles where every pawn is in each grid
## It also has a reference to the Inventory and ResourceManager (Maybe Refactor?)
## Basically the GridManager handles, where each pawn is, so pawns can check if they can attack something
## Or stop moving because an enemy is in its path etc.

@export var grid_width: int = 20
@export var grid_height: int = 7
## Additional pawn width aka how many cells within a row are allowed to be set -> start Point depends on player_start_poin_x
@export var allowed_pawn_width : int = 14
## Additional pawn height aka how many rows are allowed to be set -> start point depends on the player_start_point_y
@export var allowed_pawn_height : int = 7
## Start Point -> where allow spawn of pawns within a row
@export var player_start_point_x : int = 1 # col aka within a row the width and start point
## Start Point -> where to allow row
@export var player_start_point_y : int = 0 # row 
@export var cell_size: Vector2 = Vector2(16, 16)
@export var camera: Camera2D 
@export var inventoryManager: InventoryManager
@export var resourceManager: ResourceManager
var pawn_scene: PackedScene
var check_for_pawns : bool = false # When wavespawning is done -> check for enemy pawns every second

signal pawn_entered(cell_position: Vector2, pawn: Pawn) # emits a signal where a pawn entered a grid cell -> return grid cell (map position) not local position!
signal pawn_exited(cell_position: Vector2, pawn: Pawn) # emits a signal where a pawn exited a grid cell -> return grid cell (map position) not local position!
signal all_enemies_defeated()

var grid = {}

## Instantiate Grid and also the Area where Pawns are allowed to be set -> e.g. moveable area by enemies and 
## Placeable positions
## Also create the "GridContainer" is the UI Element for each grid tile to check if the pawn is placeable
func _ready():
	for x in range(-1, grid_width + 1):
		for y in range(grid_height + 1):
			var pos = Vector2i(x,y)
			grid[str(pos)] = [];
			if x < self.allowed_pawn_width and y < self.allowed_pawn_height:
				var gridManagercontainer =  preload("res://Scenes/UI/Grid/grid_container.tscn") \
					.instantiate() as Grid_Container
				gridManagercontainer._my_init(self, pos, self.cell_size)
	print("Grid initialized")
	print(str(grid))
	
##
## check if the pawn is within bounds either for player pawn to spawn or in general 
func is_within_bounds(cell_position: Vector2i, isPlayerPawn: bool) -> bool:
	var compareX : int = self.grid_width
	var compareY: int = self.grid_height
	var startPointX : int = -1
	var startPointY: int = -1
	if isPlayerPawn:
		compareX = self.allowed_pawn_width + self.player_start_point_x
		compareY = self.allowed_pawn_height + self.player_start_point_y
		startPointX = self.player_start_point_x
		startPointY = self.player_start_point_y
	return cell_position.x >= startPointX \
	and cell_position.x <= compareX \
	and cell_position.y >= startPointY \
	and cell_position.y <= compareY
	
## Register Pawn -> is the pawn within bounds
## TODO free the pawn if out of bounds (?)
## Usually called when a pawn enters a new grid position
func register_pawn(pawn: Pawn, cell_position: Vector2): 
	if not is_within_bounds(cell_position, pawn.isPlayerPawn):
		return
	grid[str(cell_position)].append(pawn)
	emit_signal("pawn_entered", cell_position, pawn)

## If a Pawn exits a grid position -> this is usually called
func unregister_pawn(pawn: Pawn, cell_position: Vector2):
	if not grid.has(str(cell_position)):
		return
	if pawn in grid[str(cell_position)]:
		grid[str(cell_position)].erase(pawn)
		emit_signal("pawn_exited", cell_position, pawn)
		
func unregister_pawn_with_local_coordinates(pawn: Pawn, pos: Vector2):
	self.unregister_pawn(pawn, self.local_to_map(pos))
		
## This is called by Movement classes of Pawns to check for new and old positions
## You should use the other method -> its easier
func update_pawn_position(pawn: Pawn, old_cell_position: Vector2, new_cell_position: Vector2):
	print(str("updating pawn position of: ", pawn.name))
	if old_cell_position != new_cell_position:
		unregister_pawn(pawn, old_cell_position)
		register_pawn(pawn, new_cell_position)

## This is called by Movement classes to indicate the position change of the pawn, if it so happened
func update_pawn_position_with_local_coordinates(pawn: Pawn, old_position: Vector2, new_position: Vector2):
	self.update_pawn_position(pawn, self.local_to_map(old_position), self.local_to_map(new_position))

## Returns all Pawns that are within the requested cell position.
## this is usually used by DetectionHandler of Pawns
func get_pawns_in_cell(cell_position: Vector2) -> Array[Pawn] :
	if grid.has(str(cell_position)):
		var entry = grid[str(cell_position)] as Array
		if entry.size() > 0:
			var pawns : Array[Pawn] = []
			pawns.assign(entry)
			return pawns
	return []
	
func get_pawns_at(local_pos: Vector2) -> Array[Pawn]:
	var cell_pos = self.local_to_map(local_pos)
	return self.get_pawns_in_cell(cell_pos)

## Afaik is this called by the UI handler to set the current pawn that should be spawned depending on seleciton and loadout
## Could also be called by preview pawn...
func set_pawn_scene(scene: PackedScene) -> void:
	pawn_scene = scene
	print_debug(str("Setting pawn scene: ", scene))

## This should be called by preview Pawn to check if the space they are building upon is really occupied
func is_player_pawn(pawn: Pawn):
	return pawn.is_in_group("player")

## Is this still in use? i think so because of preview pawn and raycast but i am not sure...
func get_camera() -> Camera2D:
	return self.camera

func get_inventoryManager() -> InventoryManager:
	return self.inventoryManager
	
## Called by Preview Pawn, has the pawn that should be created, enough resources.
func has_resources(cost: int, type: PawnResource.Res) -> bool:
	return self.resourceManager.has_enough_resource_of_type(type, cost)
	
	## Called by Preview Pawn, has the pawn that should be created, enough resources.
func subtract_resources(cost: int, type: PawnResource.Res) :
	self.resourceManager.subtract_resource(type, cost)

## Create a Pawn at the given GridPosition IF enough Resources are provided
func _create_new_pawn_at_grid_pos(bp: BluePrint, pos: Vector2i) :
	if not self.has_resources(bp.resource_cost, bp.resourceType):
		return
	self.resourceManager.subtract_resource(bp.resourceType, bp.resource_cost)
	var pawn = bp.pawn_scene.instantiate() as Pawn
	pawn.position = map_to_local(pos) + cell_size / 2
	self.grid[str(pos)].append(pawn)
	emit_signal("pawn_entered", pos, pawn)

## This is called by the WaveManager -> if the current Wave is done -> check if all enemies are defeated
func on_spawn_done():
	var timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", Callable(self, "check_for_game_won"))
	timer.autostart = true
	timer.start(5)

## THIS could be the culprit for wrong game is won... since maybe the gridmanager does not have all enemy pawns?
func check_for_game_won():
	var has_enemies = false
	for child in get_children():
		if not child is Pawn : 
			continue
		var pawn = child as Pawn
		if not pawn.groups.has(0):
			has_enemies = true
			break
	if not has_enemies:
		all_enemies_defeated.emit()
		
func get_grid_height() -> int:
	return self.grid_height
	
func get_allowed_pawn_width() -> int :
	return self.allowed_pawn_width
	
func get_allowed_pawn_height() -> int : 
	return self.allowed_pawn_height
	
func get_cell_size() -> Vector2i:
	return self.cell_size
