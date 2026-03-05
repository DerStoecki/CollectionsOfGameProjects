extends Node2D
class_name CeilHookDetector

@onready var parent : Player  = $".."
@onready var rayCasts: Array[RayCast2D] = [$Up, $Left, $MiddleLeft, $Right, $MiddleRight, $Down, $Left2, $MiddleLeft2, $Right2, $MiddleRight2]

var ceilHookPoint: CeilHookPoint

signal ceilHookFound()

func _ready() -> void:
	self.set_physics_process(false)
	self.parent.initialized.connect(parentInitialized)
	self.parent.enabled_ceil_hook.connect(_on_player_enabled_ceil_hook)
	for raycast in rayCasts:
		raycast.enabled = false
	
func parentInitialized(_parent: Player) -> void:
	if self.parent.able_to_ceil_hook:
		self._on_player_enabled_ceil_hook()
		
func _on_player_enabled_ceil_hook() -> void:
	self.set_physics_process(true)
	for raycast in self.rayCasts:
		raycast.enabled = true
	
func _physics_process(_delta: float) -> void:
	if self.parent.isCeilHooked:
		return
	var collidingRayCasts : Array[RayCast2D]
	collidingRayCasts.assign(rayCasts.filter(func(raycast: RayCast2D): return raycast.is_colliding()))
	if collidingRayCasts.size() <= 0:
		self.ceilHookPoint = null
		return
	var collisionObj = collidingRayCasts[0].get_collider()
	if collisionObj is CeilHookPoint:
		if self.ceilHookPoint != collisionObj:
			self.ceilHookPoint = collisionObj
			ceilHookFound.emit()
			
func getHookPosition() -> Vector2:
	if self.ceilHookPoint == null:
		return Vector2(0,0)
	return self.ceilHookPoint.hookPosition.global_position

func next_hook() -> void:
	pass
