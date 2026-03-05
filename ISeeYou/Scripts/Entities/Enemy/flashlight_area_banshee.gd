extends Area2D
class_name flashlight_area_banshee

@onready var movHandler : MovementConditionHandler = $"../BaseEnemy/MovementCondition"

func _on_area_entered(_area: Area2D) -> void:
	movHandler.inFlashlight = true


func _on_area_exited(_area: Area2D) -> void:
	movHandler.inFlashlight = false
