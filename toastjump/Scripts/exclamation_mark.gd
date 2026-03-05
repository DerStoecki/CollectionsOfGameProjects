extends Node2D
class_name Exclamation

@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var animPlayer : AnimationPlayer = $AnimationPlayer

@export var maxAnimStartedCount = 2
var curAnimCount = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.audio.pitch_scale = randf_range(0.5, 1.5)
	self.animPlayer.play("Blink")
	
func increaseCount() -> void:
	curAnimCount += 1
	if curAnimCount >= maxAnimStartedCount:
		self.queue_free()
