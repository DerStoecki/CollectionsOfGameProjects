extends OptionButton
class_name ResolutionSettings

var popupFocus : bool = false

var resolutions = [
		Vector2i(3840, 2160),
		Vector2i(2560, 1440),
		Vector2i(1920, 1080),
		Vector2i(1600, 900),
		Vector2i(1280, 720)
	]
	
func _on_item_selected(index: int) -> void:
	DisplayServer.window_set_size(resolutions[index])
