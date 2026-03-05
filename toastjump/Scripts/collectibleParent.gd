extends RigidBody2D
class_name CollectibleParent

@onready var collectibleArea: Collectible = $Area2D
@export var despawnTime : int = 10
@onready var physXcollisionShape = $CollisionShape2D

signal selfReady(CoilectibleParent)

func _on_ready() -> void:
	selfReady.emit(self)
	var timer: Timer = Timer.new()
	timer.wait_time = self.despawnTime
	timer.timeout.connect(Callable(self, "despawn"))
	timer.autostart = true
	self.add_child(timer)
	
	
func despawn():
	self.queue_free()
	
