extends AnimationPlayer
class_name PlayerWalk



func _on_credits_player_animation_finished(anim_name: StringName) -> void:
	if anim_name.contains("Credits"):
		self.play("Player_Walk_End_Credits")

func _to_main_menu():
	self.get_tree().call_deferred("change_scene_to_file","res://Scenes/StartScreen/title_screen_root.tscn")
