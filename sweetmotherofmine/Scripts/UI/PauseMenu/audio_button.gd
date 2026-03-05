extends BasicInteractUIButton
class_name AudioButton

@onready var audioSettings = $AudioSettings
@onready var masterAudioSlider : HSlider = $AudioSettings/Master/HSlider



func _on_close_audio_pressed() -> void:
	audioSettings.visible = false
	self.grab_focus()


func _on_pressed() -> void:
	self.audioSettings.visible = true
	masterAudioSlider.grab_focus()
