extends Area2D
class_name TotemArea
@onready var totemTexture = $TotemTexture
@onready var timer: Timer = $ResetLightUp

signal is_lit_up()
signal is_hidden()

func _on_reset_light_up_timeout() -> void:
	self.totemTexture.visible = false
	self.is_hidden.emit()


func _on_area_entered(_area: Area2D) -> void:
	self.totemTexture.visible = true
	self.timer.stop()
	self.is_lit_up.emit()
	
func _on_area_exited(_area: Area2D) -> void:
	if self.timer: ## happens on pickup -> callback still enabled -> ignore then
		self.timer.start()
