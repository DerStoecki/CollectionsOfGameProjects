extends Node

class_name GlobalResourceSpawner

@export var spawnTime: float = 15
@export var resourceScene: PackedScene = preload("res://Scenes/MyResource/Bone_Resource.tscn")
@export var startRange : Vector2i =  Vector2i(0,0)
@export var endRange : Vector2i = Vector2i(120, 120) # TODO Get Grid from ResourceManager and set depending on grid of pawns
@export var resManager : ResourceManager
@export var overrideValue: int = 1
@export var gridManager : GridManager
@export var autostart: bool = true

var _timer : Timer

func _ready():
	var timer: Timer = Timer.new()
	timer.wait_time = spawnTime
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	self._timer = timer
	self.add_child(timer)
	if autostart:
		self.start()

func start():
	self._timer.start()

func _on_timer_timeout():
	if gridManager:
		gridManagerRoutine()
		return
	fallbackRoutine()

func gridManagerRoutine():
	var cellSize : Vector2i = gridManager.get_cell_size()
	var endX = gridManager.get_allowed_pawn_width() * cellSize.x
	var endY = gridManager.get_allowed_pawn_height() * cellSize.y
	var rawRandPos : Vector2i = randPos(0, 0, endX, endY)
	var cellPos = self.gridManager.local_to_map(rawRandPos)
	cellPos = self.gridManager.map_to_local(cellPos)
	self.instantiateResource(cellPos)
	pass
	
func randPos(startX, startY, endX, endY) -> Vector2i:
	return Vector2i(randi_range(startX, endX), randi_range(startY, endY))
	
func fallbackRoutine():
	self.instantiateResource(self.randPos(startRange.x, startRange.y, endRange.x, endRange.y))

func instantiateResource(pos: Vector2i ):
	var resource : PawnResourceInstance = resourceScene.instantiate()
	resource._my_init(self.resManager)
	resource.set_resource_value(self.overrideValue)
	resource.position = pos
	self.get_parent().add_child(resource)
