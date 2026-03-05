extends Control


@onready var whenPaused : Control = $WhenPaused

func _process(_delta: float) -> void:
	whenPaused.visible = self.get_tree().paused
