extends Area2D
class_name LooseArea

var lost: bool = false
@export var root: NodePath

func _on_area_entered(_area):
	print("Game Lost")
	lost = true
	get_node(root).get_tree().paused = true
