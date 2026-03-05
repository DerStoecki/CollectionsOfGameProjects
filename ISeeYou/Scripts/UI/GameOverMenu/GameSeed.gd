extends Label
class_name GameSeedDisplay

@onready var gm: GameManager = $"../../../../GameManager"


func _on_game_over_parent_visibility_changed() -> void:
	self.text = str("\n GameSeed \n", self.gm.game_state.random_seed)
