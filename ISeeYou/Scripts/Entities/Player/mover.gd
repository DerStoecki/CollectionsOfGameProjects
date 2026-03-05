extends Node
class_name Mover

@export var SPEED = 300.0
@onready var parent: CharacterBody2D = $".."
@export var flippableNodes : Array[Node2D]

var prev_direction = 1
var is_moving : bool = false

func _process(delta: float) -> void:
	var direction := Input.get_axis("Move_Left", "Move_Right")
	if direction:
		self.is_moving = true
		self.move_x(direction * SPEED * delta)
	else:
		self.is_moving = false

func _physics_process(_delta: float) -> void:
	var direction := Input.get_axis("Move_Left", "Move_Right")
	if abs(direction) <= 0.01 and abs(self.parent.velocity.x) > 0:
		print("reset x speed")
		self.parent.velocity.x = 0
		self.parent.move_and_slide()

func move_x(pos: float):
	parent.position.x += pos
	
	if flippableNodes.size() > 0:
		if pos < 0  && prev_direction > 0 || pos > 0 && prev_direction < 0:
			for node in flippableNodes:
				self.flip_node(node)
			prev_direction *= -1

func flip_node(node: Node2D):
		node.scale.x *= -1
		
