extends AnimationTree
class_name PlayerAnimationHandler

var closeHtp = "parameters/conditions/isCloseHowToPlay"
var openHtp = "parameters/conditions/isHowToPlay"
var closeSett = "parameters/conditions/isClosingSettings"
var openSett = "parameters/conditions/isOpenSettings"
var endGamePar = "parameters/conditions/isEndGame"
var startGamePar = "parameters/conditions/isStartGame"
@onready var sm: AnimationNodeStateMachinePlayback = get("parameters/playback")


func _on_animation_tree_camera_animation_finished(anim_name: StringName) -> void:
	if anim_name.to_lower().contains("camerapanning_down") or anim_name.to_lower().contains("camera_focus_player"):
		set("parameters/conditions/isOpeningMenu", true)

func _input(event: InputEvent) -> void:
	if (
		event.is_action_pressed("Action")
		or event.is_action_pressed("Interact")
		or event.is_action_pressed("Jump")
		or event.is_action_pressed("Start")
		):
		if (
			get("parameters/conditions/isOpeningMenu") and sm.get_current_node().to_lower().contains("charakteridle")
			or sm.get_current_node().to_lower().contains("charakter_openmenu")
			):
			sm.next()

func close_How_To_Play():
	set(openHtp, false)
	set(closeHtp, true)
	
func open_How_To_Play():
	set(closeHtp, false)
	set(openHtp, true)

func openSettings():
	set(closeSett, false)
	set(openSett, true)
	
func closeSettings():
	set(openSett, false)
	set(closeSett, true)

func startGame():
	set(startGamePar, true)
	
func endGame():
	set(endGamePar, true)
	
func is_opened_menu():
	return sm.get_current_node().to_lower().contains("openedmenu")
	



func _on_close_settings_pressed() -> void:
	self.closeSettings()
