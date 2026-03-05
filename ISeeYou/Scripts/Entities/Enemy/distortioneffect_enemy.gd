extends MeshInstance2D
class_name DistortionEffectEnemy

@onready var flashlightArea : FlashlightCollision = $"../GhostSprite/FlashlightArea"



func _on_flashlight_area_entered_flashlight() -> void:
	self.set_visible(false)

func _on_timer_timeout() -> void:
	self.set_visible(true)
