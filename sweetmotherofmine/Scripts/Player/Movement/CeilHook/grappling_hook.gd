extends Node2D
class_name GrapplingHook

@export var player: Player
@export var ceilHookDetector: CeilHookDetector
@export_range(1000, 4000) var swingSpeed: float
## allow the player to move within the rope length
@export var min_rope_length: float 
@export var max_rope_length: float 
@export var current_rope_length : float
## Moves the player along the rope
@export_range(10,1000) var climb_speed : int
@onready var rope: Line2D = $Line2D ## only visual
@onready var joint: Joint2D = $Joint
@onready var playerHook : StaticBody2D = $"PlayerHook" # used for rotation purposes
@onready var attachement: RigidBody2D = $Attachement
var detached: bool = true
var playerPositionReached : bool = false
var lastPlayerPosition: Vector2
var failCount : float = 0
var maxFailCount : int = 1
var lastInput : float
var ignoreCurrentInput: bool = false


func _ready():
	self.set_physics_process(false)
	if not self.player.is_node_ready():
		self.player.initialized.connect(parentInitialized)
	elif self.player.able_to_ceil_hook:
		self._on_player_enabled_ceil_hook()
	else: 
		self.player.enabled_ceil_hook.connect(_on_player_enabled_ceil_hook)
	self.rope.clear_points()
	self.visible = false
	self.attachement.sleeping = true
	
func _physics_process(delta: float) -> void:
	if self.ceilHookDetector.ceilHookPoint == null and not self.player.is_ceil_hooked():
		if not self.detached:
			self.detach_player()
		self.visible = false
		self.rope.clear_points()
		self.attachement.sleeping = true
		return
	if Input.is_action_just_pressed("Grapple"):
		self.playerPositionReached = false
		self.attachement.sleeping = false
		self.detached = false
		self.failCount = 0
		if self.player.is_ceil_hooked():
			self.ceilHookDetector.next_hook()
			if self.global_position != self.ceilHookDetector.getHookPosition():
				getAndSetHookPosition()
		self.visible = true
		self.rope.clear_points()
		self.rope.add_point(Vector2(0,0))
		self.rope.add_point(self.rope.to_local(self.player.global_position))
		self.player.set_ceil_hook(true)
		return
		# move towards point if current rope_length < min hook length
		# hook
	if self.player.is_ceil_hooked():
		# update line 2D with point 0 = self.global_position and point 1 is always self.ceilHookDetector.getHookPosition()
		if self.rope.points.size() != 2:
			self.rope.clear_points()
			self.rope.add_point(Vector2(0,0))
			self.rope.add_point(Vector2(0,0))
		self.rope.points[1] = self.rope.to_local(self.player.global_position)
		self.current_rope_length = self.attachement.global_position.distance_to(self.global_position)
		if self.playerPositionReached:
			self.player.velocity.x = 0
			self.player.global_position = self.attachement.global_position
			handle_movement(delta)
		else: 
			## Test
			self.attachement.global_position = self.player.global_position
			self.playerPositionReached = true
			## Test end
			#self.player.global_position = self.player.global_position.move_toward(self.attachement.global_position, delta * self.player.baseMovSpeed * 1.5)
			#if Vector2i(self.player.global_position) == Vector2i(self.lastPlayerPosition):
		#		if self.failCount >= self.maxFailCount:
		#			self.player.global_position = self.attachement.global_position
		#		self.failCount+= delta
		#	self.lastPlayerPosition = self.player.global_position
			if self.player.global_position == self.attachement.global_position:
				self.playerPositionReached = true
	else:
		if not self.detached:
			self.detach_player()
			self.visible = false
			self.rope.clear_points()
			self.attachement.sleeping = true
			

func _on_player_enabled_ceil_hook():
	self.set_physics_process(true)
	
func parentInitialized(_parent: Player) -> void:
	if self.parent.able_to_ceil_hook:
		self._on_player_enabled_ceil_hook()
		
func handle_movement(delta: float):
	handle_swing(delta)
	handle_rope_move(delta)

func handle_swing(_delta : float):
	var direction := Input.get_axis("Move_Right", "Move_Left")
	if direction and direction != 0.0 :
		var forceDir = (self.player.global_position - self.global_position).normalized().rotated(sign(direction) * PI / 2)
		self.attachement.apply_force(forceDir * swingSpeed)
		
	
func handle_rope_move(delta: float):
	var direction : Vector2 = self.global_position - self.player.global_position
	var target : Vector2 = self.player.global_position
	var movementSpeed: float = self.climb_speed * delta
	var hasMovement: bool = false
	if self.current_rope_length > self.max_rope_length or self.current_rope_length < self.min_rope_length:
		hasMovement = true
		if self.current_rope_length > self.max_rope_length:
			target = self.attachement.global_position + direction.normalized() * self.max_rope_length
		elif self.current_rope_length < self.min_rope_length:
			target = self.attachement.global_position + direction.normalized() * self.min_rope_length
		movementSpeed = self.player.baseMovSpeed * 3 * delta
		
	else:
		var input = Input.get_axis("Down", "Up")
		if input != null and input != 0.0:
			hasMovement = true
			if (input < 0 and self.current_rope_length + self.max_rope_length / 5 >= self.max_rope_length ) or (input > 0 and self.current_rope_length - self.min_rope_length * 3 <= self.min_rope_length):
				hasMovement = false
				lastInput = input
				ignoreCurrentInput = true
				return
			if ignoreCurrentInput and (input < 0 and lastInput < 0) or (input > 0 and lastInput > 0):
				hasMovement = false
			else:
				ignoreCurrentInput = false
					
			target = self.attachement.global_position + direction.normalized() * input * self.climb_speed
	if hasMovement:
		self.attachement.global_position = self.attachement.global_position.move_toward(target, movementSpeed)
		self.joint.node_b = ("")
		self.joint.node_b = self.attachement.get_path()
		
	
func getAndSetHookPosition() -> void:
	self.global_position = self.ceilHookDetector.getHookPosition()
	
func detach_player():
		var direction := Input.get_axis("Move_Left", "Move_Right")
		var linVelocity = self.attachement.linear_velocity
		self.player.velocity.x = min(abs(linVelocity.x) * 2.5 * direction, self.player.baseMovSpeed * direction)
		self.player.velocity.y = linVelocity.y * 2.5
		self.detached = true
	 
	
