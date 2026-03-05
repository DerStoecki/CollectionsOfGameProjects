extends Node2D
class_name PathFindingEnemy

@export var player: Player
@onready var movConditionHandler: MovementConditionHandler = $BaseEnemy/MovementCondition
@onready var navAgent: NavigationAgent2D = $NavigationAgent2D
@onready var playerDetectionArea : PlayerDetectorArea = $BaseEnemy/PlayerDetectorArea

@export var resetPos : Vector2 = self.position


func _process(delta: float) -> void:
	if navAgent.target_position and navAgent.is_target_reachable():
		var dir = global_position.direction_to(navAgent.get_next_path_position()).normalized()
		#print(str("dir: ", dir, " delta: ", delta, "moveSpeed: ", movConditionHandler.cur_speed))
		self.global_position =  self.global_position + dir * delta * movConditionHandler.cur_speed

func makepath():
	navAgent.target_position = player.global_position

func _on_timer_timeout() -> void:
	self.makepath()
