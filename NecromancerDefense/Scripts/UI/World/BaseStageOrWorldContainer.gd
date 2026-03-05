extends PanelContainer

class_name BaseStageOrWorldContainer

@export var nextScene : String
@export var id : int
@export var callingName : String
@export var number: String
var selected: bool

func loadNextScene():
	get_tree().change_scene_to_file(nextScene)
		
