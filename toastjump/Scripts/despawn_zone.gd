extends Area2D
class_name DespawnZone

func _on_area_entered(area: Area2D) -> void:
	if area is Clutter:
		area.queue_free()
