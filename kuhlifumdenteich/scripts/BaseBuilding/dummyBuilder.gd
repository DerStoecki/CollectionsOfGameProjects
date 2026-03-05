class_name BuilderDummy extends Node3D

@export var spawn_point : Vector3 = Vector3.ZERO
@export var type: GameResource.MyResource = GameResource.MyResource.WOOD
@export var parentPath : NodePath = NodePath("../../ResourceManager")
@export var isEnhancer : bool = false
@export var isResource : bool = true

# TODO REFACTOR TO STATE MACHINE!

var isBuildMode : bool = false

var isSelectMode : bool = false

var isBuildingPossible : bool = false


@export var creator : Resource = preload("res://prefabs/resource_cost_dummy.tscn")

var next_width = true

func _input(event):
	if event is InputEvent:
		var inputEvent = event as InputEvent
		if inputEvent.is_action_pressed("Interact") and self.isBuildMode:
			#self._on_pressed()
			pass
		if inputEvent.is_action_pressed("Escape"):
			self.back()
				
		if inputEvent.is_action_pressed("EnterBuildMode"):
			self.isBuildMode = !self.isBuildMode
			

func setSelectMode():
	self.isBuildMode = false
	self.isSelectMode = true
		
func _on_pressed():
	# only prototype to create ResourcePlatform for now
	var instance_creator : ResourceCreator = creator.instantiate() as ResourceCreator
	instance_creator.RESOURCE_TYPE = self.type
	instance_creator.farm_flat_value = 100
	instance_creator.farm_time_seconds = 2
	var resourceManager : ResourceManager = get_node(parentPath)
	instance_creator.position = Vector3(self.spawn_point.x, self.spawn_point.y, self.spawn_point.z)
	resourceManager.add_child(instance_creator)
	resourceManager.only_connect(instance_creator)
	_next()

func set_spawnPos(vector: Vector3):
	self.spawn_point = vector
	
func set_type(t: GameResource.MyResource):
	self.type = t

func _calculate_next_spawn_point():
	print("next spawn point calculation:")
	var cur_spawn : Vector3 = self.spawn_point
	print(str("old spawn point: ", cur_spawn))
	if next_width :
		cur_spawn.x -= 1
		next_width = false
	else:
		cur_spawn.x += 1
		cur_spawn.z -= 1
		next_width = true
	self.spawn_point = cur_spawn
	print("new spawn point: ", self.spawn_point)

func _next_resource_type():
	var resourceAmount : int = GameResource.MyResource.keys().size() -1
	if self.type == resourceAmount:
		self.type = 0
	else : 
		self.type += 1

func _next():
	print("calling next")
	_calculate_next_spawn_point()
	_next_resource_type()
	
func back():
	if self.isSelectMode:
		self.isSelectMode = false
		self.isBuildMode = true
	elif self.isBuildMode:
		self.isBuildMode = false
		self.isSelectMode = false
	
