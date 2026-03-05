extends CharacterBody2D

class_name Player


@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0

@onready var spriteFrame: AnimatedSprite2D = $ToastSpriteFrames
@onready var animTree : AnimationTree = $AnimationTree
@onready var animPlayer : AnimationPlayer = $AnimationPlayer


var doubleJump : bool = true
var playerWasHitByRoomba: bool
var roombaForceX : float
var roombaForceY : float

var stamina : float = 100

var is_moving : bool = false

var is_jumping : bool = false

var ramp_up : Vector2 = Vector2(0, 1)

func _physics_process(delta: float) -> void:
	if playerWasHitByRoomba:
		playerWasHitByRoomba = false
		velocity.x = roombaForceX
		velocity.y = roombaForceY
		move_and_slide()
		return
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * ramp_up
		ramp_up.y += delta * 3
	var is_floored = is_on_floor()
	if is_floored:
		self.set_collision_mask_value(2, true)
		self.doubleJump = true
		self.is_jumping = false
		self.ramp_up.y = 1
	var is_sprinting = Input.is_action_pressed("Sprint")
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and (is_floored or doubleJump):
		if !is_floored:
			doubleJump = false
		if !Input.is_action_pressed("Down"):
			velocity.y = JUMP_VELOCITY
			is_jumping = true
			self.animTree.set("parameters/conditions/isJumping", true)
			self.animTree.set("parameters/conditions/isWalking", false)
		else: 
			self.set_collision_mask_value(2, false) #collision with platforms
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	var cur_speed = SPEED
	if stamina > 0:
		if is_sprinting:
			stamina -= 1
			cur_speed = SPEED * 2
	if stamina <= 100 and !is_sprinting:
		stamina += 0.5
	
	if direction:
		velocity.x = direction * cur_speed
		if !is_jumping:
			self.animTree.set("parameters/conditions/isJumping", false)
			self.animTree.set("parameters/conditions/isWalking", true)
	else:
		velocity.x = move_toward(velocity.x, 0, cur_speed)
		self.animTree.set("parameters/conditions/isWalking", false)
	if direction < 0:
		self.spriteFrame.scale.x = -1
	if direction > 0:
		self.spriteFrame.scale.x = 1

	move_and_slide()
	
