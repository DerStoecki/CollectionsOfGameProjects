extends Node
class_name Mover

@onready var parent: Player = $".."

@export var flippableXNodes : Array[Node2D]

var prev_direction = 1
var is_moving : bool = false
var curWaitTime : float = 10_000
var awaitDelayTime: float = 0


func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("Move_Left", "Move_Right")
	if not self.parent.allowed_to_move:
		self.move_x(direction)
		return
	if self.curWaitTime < awaitDelayTime:
		self.curWaitTime += delta
		return
	if direction:
		self.is_moving = true
		var mov = direction * self.parent.baseMovSpeed
		self.parent.velocity.x = mov
		self.move_x(direction)
	else:
		self.is_moving = false
		self.parent.velocity.x = 0
	

func move_x(pos: float):
	if flippableXNodes.size() > 0:
		if (pos < 0  && prev_direction > 0) or (pos > 0 && prev_direction < 0):
			for node in flippableXNodes:
				self.flip_x(node)
			prev_direction = pos

func flip_x(node: Node2D):
		node.scale.x *= -1
		

func _on_player_delayed_movement_after_seconds(delay: float) -> void:
	self.curWaitTime = 0
	self.awaitDelayTime = delay
