extends Control

class_name StageDisplay

@export var selectedStage: StageContainer

func _ready():
	if selectedStage:
		selectedStage.grab_focus()
