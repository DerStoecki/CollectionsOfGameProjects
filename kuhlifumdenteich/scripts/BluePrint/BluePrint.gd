# Init == Done mesh but transparent and with new flat material
# Waiting == BaseMesh
# SET_FOR_PROGRESS == Add decoration -> build in progress
# IN_PROGRESS == Animation (?) where each tile/mesh is build to the 
# PRE_DONE Mainly for decorations / Events after build progress show DONE 
# DONE => remove decorator etc show only done
# SET_FOR_DESTRUCTION -> same decoration i guess as set for progress
# DESTRUCTION phase -> do something with the mesh / destroy physics?
# CLEANUP -> rubble to base only to removal
# after cleanup -> free node

# show Blueprint on init,
# show building mesh on build
# show resourceCreator and

class_name BluePrint extends ResourceCreator

@export var resCost : Resource = preload("res://prefabs/resource_cost_dummy.tscn")

@onready var cost : ResourceCost = resCost.instantiate() as ResourceCost

@export var qualityLevel : String = str(Quality.bpQuality.IMPOSSIBLE)

@export var creatorMeshRes : PackedScene = preload("res://prefabs/ResourceMeshes/parent_mesh.tscn")

var creatorMesh : MeshColorUtility

var state : BluePrintState.state = BluePrintState.state.INIT
var nextstate : String = "INIT"
var handler : StateHandler

var initialized : bool = false
var placed : bool = false
var placeable : bool = false
var test : bool = false

func _ready():
	self.creatorMesh = creatorMeshRes.instantiate()
	self.handler = InitHandlerBP.new(self)
	add_child(creatorMesh)
	self.creatorMesh.visible = false
	
	
func _process(delta):
	if initialized && !self.test:
		self.handler.run(delta)
		if !self.handler.is_correct_handler(self.nextstate):
			self.handler._onExit()
			self.handler = self.getNextHandler();
			# TODO Remove
			self.place()

func place_building() -> bool:
	if self.state == BluePrintState.state.INIT && self.qualityLevel != "IMPOSSIBLE":
		self.nextstate =  str(BluePrintState.state.WAITING)
		return true
	return false


func removeBuilding():
	## TODO Depending on State -> do things differently
	pass


func set_quality_level(dic : Dictionary) :
	
	if dic.has("occupied") and dic["occupied"] == true:
		self.qualityLevel = str(Quality.bpQuality.IMPOSSIBLE)
		return
	var resourceKey = GameResource.get_key_from_MyResource_value(self.RESOURCE_TYPE)
	if (dic.has(resourceKey)) :
		self.qualityLevel = str(dic[resourceKey])
		#print(str("setting quality Level to ", self.qualityLevel))
	pass
	
func get_creatorMesh() -> MeshColorUtility : 
	return self.creatorMesh
	
func initialize():
	self.initialized = true
	self.visible = true
	
func uninitialize():
	self.initialized = false
	self.visible = false
	
func getNextHandler():
	pass
	
func place():
	self.test = true
	print("placed")
	self.creatorMesh.visible = true
	super._ready()
	pass
