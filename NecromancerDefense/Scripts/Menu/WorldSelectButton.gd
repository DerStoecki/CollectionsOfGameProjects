extends DefaultMenuButton

class_name WorldSelectButton

@export var world_select: String

func _ready():
	super._ready()
	grab_focus()

func _on_button_pressed():
	get_tree().change_scene_to_file(world_select)
	pass
