class_name BuildHelper extends Node3D

@onready var builder : BaseBuilder = self.get_parent() as BaseBuilder
@export var bluePrint : PackedScene = preload("res://prefabs/resource_platform.tscn")

var bp : BluePrint

@export var managerPath : NodePath

var type: GameResource.MyResource = GameResource.MyResource.WOOD

# Called when the node enters the scene tree for the first time.
func _ready():
	self._createNewBP()
	
	pass
	#var callable = Callable(self, "_create_build_menu")
	#builder.connect("build", callable)
	#pass # Replace with function body.

func _process(delta):
	if self.bp != null:
		if self.builder.builder.isBuildMode:
			if bp.initialized == false:
				bp.initialize()
			if self.builder.is_valid_tile():
				bp.set_quality_level(self.builder.get_dic_of_world_on_current_grid())
				var global_pos = builder.get_tile_to_global_position()
				global_pos.y += 0.2
				bp.position = global_pos
		elif self.bp.initialized :
			self.bp.uninitialize()
	

func _input(event):
	if event is InputEvent:
		var inputEvent = event as InputEvent
		if self.bp != null && inputEvent.is_action_pressed("Interact") and self.builder.builder.isBuildMode:
			if self.bp.qualityLevel != str(Quality.bpQuality.IMPOSSIBLE):
				self.builder.set_occupied()
				self.bp.place_building()
				var resourceManager : ResourceManager = get_node(managerPath)
				remove_child(self.bp)
				resourceManager.add_child(self.bp)
				resourceManager.only_connect(self.bp)
				self.bp = null
				self._createNewBP()
				

#func _create_build_menu(builder: BaseBuilder):
#	print("build menu opened")
#	var blue_print : ResourceCreator = bluePrint.instantiate() as BluePrint
#	instance_creator.RESOURCE_TYPE = self.type
#	instance_creator.farm_flat_value = 100
#	instance_creator.farm_time_seconds = 2
#	var resourceManager : ResourceManager = get_node(managerPath)
#	var global_pos = builder.get_tile_to_global_position()
#	global_pos.y += 0.2
#	print(str("global pos: ", global_pos))
#	resourceManager.add_child(instance_creator)
#	instance_creator.position = global_pos
#	resourceManager.only_connect(instance_creator)
#	_next_resource_type()
#	builder.builder.back()


func _next_resource_type():
	var resourceAmount : int = GameResource.MyResource.keys().size() -1
	if self.type == resourceAmount:
		self.type = 0
	else : 
		self.type += 1
		
func _createNewBP():
	self.bp = bluePrint.instantiate()
	add_child(bp)
	self.bp.visible = false
