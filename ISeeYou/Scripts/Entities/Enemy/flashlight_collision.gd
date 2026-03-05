extends Area2D
class_name FlashlightCollision

@onready var parent: Sprite2D = $".."
@onready var timer: Timer = $Timer

signal entered_flashlight()

signal exited_flashlight()

func _on_area_entered(_area: Area2D) -> void:	
	entered_flashlight.emit()
	self.parent.set_visible(true)
	self.timer.stop()
	
	

func _on_area_exited(_area: Area2D) -> void:
	exited_flashlight.emit()
	self.timer.start(timer.wait_time)


func _on_timer_timeout() -> void:
	self.parent.set_visible(false)
