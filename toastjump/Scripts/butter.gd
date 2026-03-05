extends Area2D
class_name Butter

@export var despawnTime = 5
signal score_multiplier_active()

func _ready() -> void:
	var timer : Timer = Timer.new()
	timer.wait_time = self.despawnTime
	timer.autostart = true
	timer.timeout.connect(Callable(self, "_on_timer_timeout"))
	self.add_child(timer)


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		score_multiplier_active.emit()
		self.queue_free()
		
func _on_timer_timeout() -> void:
	self.queue_free()
