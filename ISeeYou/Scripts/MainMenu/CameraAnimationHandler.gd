extends AnimationTree
class_name CameraAnimationHandler

@onready var label: Label = $PressStart
@onready var statemachine : AnimationNodeStateMachinePlayback = get("parameters/playback")
var isStartPressedPath: String = "parameters/conditions/isStartPressed"
var isNewGamePath: String = "parameters/conditions/isNewGame"
var quitAfterPanUp: bool = false

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		self.label.text = "PRESS A or START"
	elif event is InputEventKey or event is InputEventMouseButton or event is InputEventMouseMotion:
		self.label.text = "Press Space or Enter"
	if (
		event.is_action_pressed("Action")
		or event.is_action_pressed("Interact")
		or event.is_action_pressed("Jump")
		or event.is_action_pressed("Start")
		):
		if get(isStartPressedPath) and not get(isNewGamePath):
			self.skip_start_anim()
		else: 
			set(isStartPressedPath, true)
			self.label.visible = false
	if event.is_action_pressed("Cancel") and statemachine.get_current_node() == "RESET":
		get_tree().quit()
		
func skip_start_anim():
	var curAnim : String = statemachine.get_current_node()
	if curAnim.to_lower().contains("camerapanning_down"):
		statemachine.next()
	
func startNewGame():
	set(isNewGamePath, true)

func endGame():
	set(isNewGamePath, true)
	quitAfterPanUp = true
