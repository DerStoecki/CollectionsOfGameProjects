extends Node2D
class_name RotatingPlattform

@export var radius : float = 120
@export var speed : float = 1.5
var cur_angle : float = 0

@onready var plattform : AnimatableBody2D = $RotatingPlatform
@onready var line : Line2D = $Line2D
func _ready() -> void:
	self.plattform.position.x = radius
	self.line.add_point(Vector2(0,0))
	self.line.add_point(self.plattform.position)
	pass
	
func _process(delta: float) -> void:
	cur_angle += speed * delta
	self.plattform.position = Vector2(cos(cur_angle) * radius, sin(cur_angle) * radius)
	self.line.points[1] = self.plattform.position
	
