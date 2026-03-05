extends CharacterBody2D
class_name Player

@export var able_to_doubleJump : bool
@export var able_to_wall_hook: bool
@export var able_to_ceil_hook: bool
@export var allowed_to_jump: bool
@export var allowed_to_move: bool
@export var dragDownForce : float
@export var wallJumpDelayTime: float
@export var ceilJumpDelayTime: float
## Remember to Pause game when either in shop, dialogue or menu etc
@export var isInteracting: bool 

@export_range(0, 5000) var baseMovSpeed : int
@export_range(-4000, -1) var baseJumpVelocity: int
@export_range(-4000, 0) var minVelocityApplyDragForce

# hold references to important nodes, just in case, probably used later for saving
@onready var mover: Mover = $Mover
@onready var jumper: Jumper = $Jumper
@onready var camera: Camera2D = $Camera2D
@onready var hitbox: Area2D = $PlayerHealth
@onready var attackHandler: PlayerAttackHandler = $AttackHandler
@onready var walldetector: WallHook = $WallDetector
@onready var ceilHookDetector: CeilHookDetector = $CeilHookDetector

var jumpReleased : bool = false
var increasingGravityForce : float = 1.0
signal initialized(player : Player)

var coyoteTimeActive: bool
var coyoteTime : float = 0.1
var curCoyoteTime : float = 0
var isWallHooked: bool = false
var isCeilHooked: bool = false

signal enabled_ceil_hook()
signal enabled_wall_hook()

signal delayed_movement_after_seconds(delay: float)


func _ready():
	initialized.emit(self)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_released("Jump"):
		jumpReleased = true
	if self.is_in_air():
		if curCoyoteTime < coyoteTime:
			coyoteTimeActive = true
			curCoyoteTime += delta
		else :
			coyoteTimeActive = false
			self.velocity.y += get_gravity().y * delta * increasingGravityForce
			increasingGravityForce = increasingGravityForce + (delta * increasingGravityForce * dragDownForce)
			if (self.velocity.y > minVelocityApplyDragForce and self.velocity.y < 0) or ( jumpReleased and self.velocity.y < 0):
				self.velocity.y = get_gravity().y * dragDownForce
	else:
		curCoyoteTime = 0
		increasingGravityForce = 1.0
		jumpReleased = false
		if self.is_on_floor():
			self.set_wall_hook(false)
		elif self.is_wall_hooked():
			self.velocity.y = get_gravity().y * (dragDownForce / 2.0)
		elif self.is_ceil_hooked():
			self.velocity.y = 0
			pass
	move_and_slide()


func is_ceil_hooked() -> bool:
	return self.isCeilHooked
	
func is_wall_hooked() -> bool:
	return self.isWallHooked

func is_in_air() -> bool :
	return not (self.is_on_floor() or self.is_ceil_hooked() or self.is_wall_hooked())


func _on_jumper_double_jump() -> void:
	self.increasingGravityForce = min(1.2, increasingGravityForce)
	self.jumpReleased = false
	set_wall_hook(false)
	set_ceil_hook(false)

func _on_jumper_jump() -> void:
	self.increasingGravityForce = 1.0
	set_wall_hook(false)
	set_ceil_hook(false)
	

func _on_jumper_wall_jump() -> void:
	self.increasingGravityForce = min(1.1, increasingGravityForce)
	self.delayed_movement_after_seconds.emit(self.wallJumpDelayTime)
	set_wall_hook(false)
	
func _on_jumper_ceil_jump() -> void:
	self.increasingGravityForce = min(1.1, increasingGravityForce)
	self.delayed_movement_after_seconds.emit(self.ceilJumpDelayTime)
	set_ceil_hook(false)
	
func set_able_to_wall_hook() -> void:
	self.able_to_wall_hook = true
	self.enabled_wall_hook.emit()
	
	
func set_wall_hook(isHooked: bool) -> void:
	self.isWallHooked = isHooked
	self.allowed_to_move = not self.isWallHooked and not self.isCeilHooked
		
func set_ceil_hook(isHooked: bool) -> void:
	self.isCeilHooked = isHooked
	self.allowed_to_move =  not self.isWallHooked and not self.isCeilHooked
		
func set_able_to_ceil_hook() -> void:
	self.able_to_ceil_hook = true
	self.enabled_ceil_hook.emit()
