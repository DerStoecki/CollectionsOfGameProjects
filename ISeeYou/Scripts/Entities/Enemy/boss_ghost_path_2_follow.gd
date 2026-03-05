extends Path2D
class_name BossGhost

@onready var follow: MoverOnPath = $PathFollow2D

@export var resetPos: Vector2 

func _on_path_follow_2d_ratio_finished() -> void:
	self.visible = false
	self.global_position = resetPos
	self.follow._disable()
	self.follow._reset()
