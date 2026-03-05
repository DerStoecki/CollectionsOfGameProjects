extends Node2D
class_name WallHook

@onready var raycast: RayCast2D  = $"RayCast2D"
@onready var parent: Player = $".."
signal wall_hooked()


func _ready():
	self.set_physics_process(false)
	self.parent.initialized.connect(parentInitialized)
	self.parent.enabled_wall_hook.connect(_on_player_enabled_wall_hook)
	self.raycast.enabled = false

func parentInitialized(_player: Player):
	if self.parent.able_to_wall_hook:
		self._on_player_enabled_wall_hook()
		

func _on_player_enabled_wall_hook() -> void:
	self.set_physics_process(true)
	self.raycast.enabled = true


func _physics_process(_delta: float) -> void:
	if not self.raycast.is_colliding():
		self.parent.set_wall_hook(false)
		return
	if not self.parent.is_in_air():
		return
	if not self.parent.velocity.y >= self.parent.minVelocityApplyDragForce:
		return
	print("wall hook")
	var direction := Input.get_axis("Move_Left", "Move_Right")
	if (direction < 0 and self.raycast.scale.x < 0) or (direction > 0 and self.raycast.scale.x > 0) :
		self.wall_hooked.emit()
