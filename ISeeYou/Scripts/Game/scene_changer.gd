extends Node
class_name SceneChanger

@onready var sceneChangerAnimation = $"../AnimationTree/SceneChangerAnimation"
@onready var sm : AnimationTree = $"../AnimationTree"
var smFadeIn = "parameters/conditions/FadeIn"
var smFadeOut = "parameters/conditions/FadeOut"

var scenePath = "EMPTY"

func change_to_next_scene(sP: String):
	self.scenePath = sP
	sm.set(smFadeIn, true)
	sm.set(smFadeOut, false)
	get_tree().paused = true


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name.contains("Scene_Transition_FadeIn") and not scenePath.contains("EMPTY"):
		get_tree().call_deferred("change_scene_to_file", scenePath)
