extends AttackInputResolver
class_name MeleeHandler

@export var able_to_attack: bool



func resolveState(state: int) -> void:
	if self.finishedCurrentStateHandling:
		print(str("TODO: Handle State for : ", state))
		self.finishedCurrentStateHandling = false
	pass
