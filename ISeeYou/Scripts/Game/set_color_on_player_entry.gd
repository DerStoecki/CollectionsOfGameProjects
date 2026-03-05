extends Area2D
class_name ColorSetterOnPlayerEntry

@export var colorToSet : Color
@export var colorRects : Array[ColorRect]


func _on_body_entered(_body: Node2D) -> void:
	#always player
	for rect in colorRects:
		rect.color = self.colorToSet
