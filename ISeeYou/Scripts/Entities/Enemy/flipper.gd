extends Node2D
class_name Flipper

@export var baseScaleX : int = 1
@onready var parent : Banshee = $"../../.."
var passedTime = 1

func _process(_delta: float) -> void:
	passedTime += _delta
	if passedTime >= 1:
		var b = self.global_position.x
		var p = self.parent.player.global_position.x
		if  b > p : # right to player
			self.scale.x = self.baseScaleX * -1
		elif b < p :
			self.scale.x = self.baseScaleX
		passedTime = 0
		
