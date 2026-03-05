extends Area2D
class_name Collectible

@export var scorepoints : int = -100
var is_spoiled = false
@onready var audioStreamPlayer : AudioStreamPlayer2D = $"../BounceSound"
@onready var collectPlayer : AudioStreamPlayer2D = $"../CollectSound"
var play_collect : bool = true

var active: bool = true
signal add_points(scorepoints: int)

func _on_body_entered(body: Node2D) -> void:
	if !active :
		return
	if body is Player:
		self.add_points.emit(scorepoints)
		if play_collect:
			self.collectPlayer.play()
		self.get_parent().visible = false
		var rb : CollectibleParent = self.get_parent()
		rb.set_physics_process(false)
		self.active = false
		rb.physXcollisionShape.set_deferred("disabled", true)
		await self.collectPlayer.finished
		self.get_parent().queue_free()
		return
	elif (body is Floor):
		if !is_spoiled:
			is_spoiled = true
			if self.scorepoints < 0:
				self.scorepoints *= 2 
			else: 
				self.scorepoints /= 2
	audioStreamPlayer.play()
