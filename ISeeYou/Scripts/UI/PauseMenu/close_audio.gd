extends BasicInteractUIButton
class_name CloseAudio

@onready var parentAudio: Button = $"../.."

@onready var settings: AudioSettingsLoader = $".."


func _on_pressed() -> void:
	settings.visible = false
	settings.save()
	parentAudio.grab_focus()
