extends CanvasLayer
class_name GameOverParent

@onready var player : Player = $"../Player"

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
		if anim_name.to_lower().contains("death"):
			self.set_visible(true)
			$"..".get_tree().paused = true
