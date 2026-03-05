extends CheckBox
class_name MuteButton

@export var bus_name : String = "Master"
@onready var parent: AudioSettingsLoader = $".."
var bus_index : int = 0

func _ready():
	self.bus_index = AudioServer.get_bus_index(bus_name)


func _on_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(bus_index, toggled_on)
	if toggled_on:
		self.text = "MUTED"
	else:
		self.text = "UNMUTED"
	if not self.parent.audio_settings:
		return
	self.parent.audio_settings.muted = toggled_on

func _gui_input(event: InputEvent) -> void:
	if self.has_focus() and event is InputEventJoypadButton and (event.is_action_released("Interact") or event.is_action_released("Jump")):
		self.button_pressed = !self.button_pressed
		self.pressed.emit()


func _on_focus_entered() -> void:
	print("focues entered")
	print(get_stack())



func _on_focus_exited() -> void:
	print("focues exited")
	print(get_stack())
	pass # Replace with function body.
