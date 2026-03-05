extends AnimationPlayer
class_name Boss_ZoomPlayerCamOut

signal zoom_finished

func _on_ritual_ritual_started(_ritual: Ritual) -> void:
	self.play("Zoom_Out")
	
func emitZoomFinished():
	zoom_finished.emit()
