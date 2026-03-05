extends Area2D

class_name HeartInGame

@onready var animPlayer : AnimationPlayer = $AnimationPlayer

@export var despawnTime : int = 5

signal heartCollected()

func _ready() -> void:
	animPlayer.play("HeartBeat")
	var timer : Timer = Timer.new()
	timer.wait_time = self.despawnTime
	timer.autostart = true
	timer.timeout.connect(Callable(self, "_on_timer_timeout"))
	self.add_child(timer)


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		heartCollected.emit()
		self.queue_free()
		
func _on_timer_timeout() -> void:
	self.queue_free()
