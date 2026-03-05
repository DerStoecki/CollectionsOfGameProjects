class_name BaseBuilder extends GridMap

@export var worldGrid : NodePath

@export var builderPath : NodePath 

@onready var builder : BuilderDummy = get_node(builderPath) as BuilderDummy

@onready var worldBuilder: WorldBuilder = get_node(worldGrid) as WorldBuilder

var tile : Vector3i = Vector3i(0, 0, 0)

signal build(node: BaseBuilder)
signal destroy(node: BaseBuilder)

func _ready():
	self.visible = false

func _process(delta):
	if self.builder.isBuildMode:
		self.visible = true
		self._assign_tile()
		self._draw_tile()
	elif self.builder.isSelectMode:
		self.visible = true
		self.set_cell_item(self.tile, 9, 0)
	else:
		self.visible = false
	
func _draw_tile():
	var worldDic = self.worldBuilder.dic
	if worldDic.has(self.tile):
		_clear_remaining_tiles()
		var index = 7
		if worldDic[self.tile]["occupied"] == true:
			index = 8
		self.set_cell_item(self.tile, index, 0)
		
func _clear_remaining_tiles():
	var tiles = self.get_used_cells()
	for tile in tiles:
		if tile != self.tile:
			self.set_cell_item(tile, INVALID_CELL_ITEM, 0)
	
#TODO REFACTOR!
func _input(event):
	if self.builder.isBuildMode:
		if event is InputEvent:
			if event.is_action_pressed("Interact"):
				#self.builder.setSelectMode()
				emit_signal("build", self)
	
func _assign_tile():
	var mousePos = _screenPointToRay()
	if mousePos != null:
		var positionVec : Vector3i = Vector3i(mousePos)
		self.tile = map_to_local(positionVec)


func _screenPointToRay():
	var spaceState = get_world_3d().direct_space_state
	var mousePos = get_viewport().get_mouse_position()
	var camera = get_viewport().get_camera_3d()
	var rayOrigin = camera.project_ray_origin(mousePos)
	var rayEnd = rayOrigin + camera.project_ray_normal(mousePos) * 2000
	var rayArray = spaceState.intersect_ray(PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd))
	if rayArray.has("position"):
		return rayArray["position"]
	return null	
	
func get_tile_to_global_position():
	return self.to_global(map_to_local(self.tile))
	
func get_dic_of_world_on_current_grid() -> Dictionary:
	return self.worldBuilder.dic[self.tile];
	
func is_valid_tile() -> bool:
	return self.worldBuilder.dic.has(self.tile)
	
func set_occupied() :
	self.worldBuilder.dic[self.tile]["occupied"] = true
