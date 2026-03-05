extends Node2D
class_name BluePrint

## The Blueprint is a helper class
## It Contains the name, the pawn scene, the preview pawn, as well as a preview texture
## It also contains resource_costs, group and what resource Type it needs to be build
## After setting a blueprint -> a cooldown should start (like a bar that fills)
## if time is up -> only then you can build another of this
## When the Pawn gets instantiated start the timer
##

@export var id : int = 0
@export var bpName: String
@export var rechargeTime : float = 10
@export var pawn_scene: PackedScene # This should hold a DEFENDER pawn (maybe different mode where you can be attacker etc)
@export var preview_pawn_scene: PackedScene
@export var previewPawnTexture : Texture2D
@export var resource_cost: int = 50 # this will not be handled by loadout but somewhere else...
@export var group : Array[int]
@export var resourceType: int = PawnResource.Res.BONES


var gridManager : GridManager
var cooldown_timer: Timer

func _ready():
	pawn_scene.resource_local_to_scene = true
	if self.cooldown_timer == null:
		createTimer()

func instantiate_pawn(pos: Vector2) -> Pawn:
	var pawn = pawn_scene.instantiate() as Pawn
	pawn.position = pos
	cooldown_timer.start()
	return pawn

func is_available() -> bool:
	return cooldown_timer.is_stopped()

func set_gridManager(manager: GridManager) -> BluePrint :
	self.gridManager = manager
	return self
	
func _my_init(_id: int, _bpName: String, _rechargeTime: int, _resource_cost: int, _group: int, _pawn_scene: String, _preview_pawn_scene: String, _preview_texture: String) -> BluePrint:
	# TODO Make safe
	self.id = _id
	self.bpName = _bpName
	self.rechargeTime = _rechargeTime
	self.resource_cost = _resource_cost
	self.group.append(_group)
	self.pawn_scene = load(_pawn_scene) as PackedScene
	self.preview_pawn_scene = load(_preview_pawn_scene) as PackedScene
	self.previewPawnTexture = load(_preview_texture)
	if self.cooldown_timer == null:
		createTimer()
	return self
	
	
func createTimer():
	self.cooldown_timer = Timer.new()
	self.cooldown_timer.wait_time = rechargeTime
	self.cooldown_timer.one_shot = true
	add_child(cooldown_timer)

func _is_timer_up() -> bool:
	if self.cooldown_timer == null:
		self.createTimer()
		return true
	return self.cooldown_timer.is_stopped()
	
