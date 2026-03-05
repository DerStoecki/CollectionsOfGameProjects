extends DefaultMenuButton

class_name StageSelectButton

@export var stageMenu: String

func _on_button_pressed():
	super._on_button_pressed()
	get_tree().change_scene_to_file(stageMenu)
