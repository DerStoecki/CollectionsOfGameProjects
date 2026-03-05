extends Node2D
class_name AttackInputResolver

@onready var attackHandler: PlayerAttackHandler = $".."
@export var finishedCurrentStateHandling : bool = true

## TODO Emergency Interrupt

func resolveState1(state: int) -> void:
	pass

func finished():
	self.finishedCurrentStateHandling = true
	self.attackHandler.resolve()

func intterupt():
	self.finishedCurrentStateHandling = true
	## TODO Interrupt Animation / interrupt Signal to Animation
	pass

func startHandling():
	self.finishedCurrentStateHandling = false
