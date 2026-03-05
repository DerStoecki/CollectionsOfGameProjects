extends Node
class_name Jumper


@onready var parent: Player = $".."
@export var reducedWallJumpSpeed : float
@export var reducedDoubleJumpSpeed: float
@export var jumpBufferTime : float = 0.25

var doubleJump: bool = true

var jumpBufferActive: bool = false
var curjumpBuffer : float = 0

signal jump()
signal wall_jump()
signal double_jump()
signal ceil_jump()

func _physics_process(delta: float) -> void:
	if not self.parent.allowed_to_jump:
		return
	if Input.is_action_just_pressed("Jump") or jumpBufferActive:
		if not self.parent.is_in_air() or self.parent.coyoteTimeActive: #hooked, wall slide or on floor with coyoteTime
			self.doubleJump = true
			self.curjumpBuffer = 0
			self.jumpBufferActive = false
		if self.parent.is_on_floor() or self.parent.coyoteTimeActive: # normal jump
			self.parent.velocity.y = self.parent.baseJumpVelocity
			jump.emit()
		elif self.parent.is_wall_hooked(): #  normal jump but with slightly less 
			self.parent.velocity.y = self.parent.baseJumpVelocity / self.reducedWallJumpSpeed
			self.parent.velocity.x = self.parent.baseMovSpeed
			wall_jump.emit()
		elif self.parent.is_ceil_hooked():
			ceil_jump.emit() # use movement + velocity used in grappling hook
			self.parent.velocity.y = self.parent.baseJumpVelocity
		elif self.parent.able_to_doubleJump and doubleJump:
			self.doubleJump = false
			self.parent.velocity.y = self.parent.baseJumpVelocity / self.reducedDoubleJumpSpeed
			self.double_jump.emit()
		else : # we are in air, have no double jump so we buffer the jump
			curjumpBuffer = min(curjumpBuffer + delta, jumpBufferTime + 1)
			jumpBufferActive = curjumpBuffer <= jumpBufferTime
	
