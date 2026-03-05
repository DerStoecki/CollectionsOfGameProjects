extends DamageDealer

class_name Sword


func handle_pawn_detection(body: Pawn):
	var id = body.get_instance_id()
	if damagedPawnIds.has(id):
		return
	self.damagedPawnIds.append(id)
	body.receive_damage(self.get_damage())

func detectOverlappingAreas():
	var areas = get_overlapping_areas()
	for area in areas:
		if area.get_parent() is Pawn:
			handle_pawn_detection(area.get_parent() as Pawn)

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is Pawn:
		handle_pawn_detection(area.get_parent() as Pawn)
