extends Node
class_name Jumper

@export var JUMP_VELOCITY = -400.0
@onready var parent: CharacterBody2D = $".."
@export var increase_fall_speed_Vector : Vector2 = Vector2.DOWN
@export  var increase_fall_speed_Amount: int = 1
@export var max_jump_height: float = 40

var current_fall_speed_amount : int = 1
var initial_jump : bool = false
var jumping_pressed : bool = false
@onready var jump_at_position_y : float = parent.position.y

signal is_jumping()

func _physics_process(delta: float) -> void:
	var is_floored = parent.is_on_floor()
	#var jump_just_released = Input.is_action_just_released("Jump")
	if not is_floored: # and self.shouldFall():
		parent.velocity += parent.get_gravity() * delta * increase_fall_speed_Vector #calculateAppliedVelocity(delta, increase_fall_speed_Vector * current_fall_speed_amount)
		#if parent.velocity.y > 0:
			#print(parent.velocity)
			#current_fall_speed_amount += increase_fall_speed_Amount
		#current_fall_speed_amount += increase_fall_speed_Amount
	if is_floored :
		jumping_pressed = false
		current_fall_speed_amount = 1
		self.jump_at_position_y = parent.position.y
		if Input.is_action_just_pressed("Jump"):
			#TODO set collision mask value 3 false (plattforms with fallable surface) and down is also pressed
			parent.velocity.y = JUMP_VELOCITY
			initial_jump = true
			jumping_pressed = true
			is_jumping.emit()
	parent.move_and_slide()

func shouldFall () -> bool:
	return not initial_jump or self.parent.position.y < self.jump_at_position_y - self.max_jump_height or Input.is_action_just_released("Jump")
	
func calculateAppliedVelocity(delta, direction:Vector2) -> Vector2:
	return parent.get_gravity() * delta * direction
	
