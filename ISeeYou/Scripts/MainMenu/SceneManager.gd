extends Node
class_name MainMenuSceneManager

@export var firstLevel : String
@onready var cameraAnimSM: CameraAnimationHandler = $AnimationTreeCamera



func _on_animation_tree_camera_animation_finished(anim_name: StringName) -> void:
	if anim_name.to_lower().contains("camerapanning_up"):
		if cameraAnimSM.quitAfterPanUp:
			get_tree().quit(0)
			return
		get_tree().change_scene_to_file(firstLevel)
