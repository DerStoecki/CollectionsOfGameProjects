extends BasicInteractUIButton
class_name TryAgainButton

@export var entryScreen : String
@onready var parent : GameOverParent = $"../../.."
@onready var gm: GameManager = $"../../../../GameManager"


func _on_pressed() -> void:
	gm.generate_seed()
	gm.create_new_game()
	$"..".get_tree().paused = false
	get_tree().change_scene_to_file(entryScreen)
	pass
