extends BasicInteractUIButton
class_name ExitToMainMenu

@export var titleScreen : String = "res://Scenes/StartScreen/title_screen_root.tscn"



func _on_pressed() -> void:
	$"..".get_tree().paused = false
	get_tree().change_scene_to_file(titleScreen)
