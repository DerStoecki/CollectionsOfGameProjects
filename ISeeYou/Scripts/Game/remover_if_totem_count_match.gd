extends Node
class_name RemoverIfTotemsMatch

@onready var parentLabel : MinTotemLabel = $".."
@onready var door : Node2D = $"../.."
@onready var openDoor : SceneChangeAudio = $"../../../../OpenDoor"
@onready var closeDoor: SceneChangeAudio = $"../../../../CloseDoor"
@onready var doorBody : StaticBody2D = $"../../StaticBody2D"
@onready var doorSprite: Sprite2D = $"../../Sprite2D"
var ritualStarted : bool = false


func _on_interact_area_interacted() -> void:
	if ritualStarted:
		return
	if parentLabel.minTotemCount <= parentLabel.gm.game_state.collected_totems.size():
		self.openDoor.play_with_pitch_shift()
		self.doorSprite.visible = false
		_set_collision_of_door(false)

func _on_ritual_ritual_started(_ritual: Ritual) -> void:
	_set_collision_of_door(true)
	self.ritualStarted = true
	
func _on_ritual_ritual_initiated() -> void:
	_set_collision_of_door(true)
	self.doorSprite.visible = true
	self.closeDoor.play_with_pitch_shift()

func _set_collision_of_door(value: bool):
	self.doorBody.set_collision_mask_value(4, value)
	self.doorBody.set_collision_layer_value(1, value)
