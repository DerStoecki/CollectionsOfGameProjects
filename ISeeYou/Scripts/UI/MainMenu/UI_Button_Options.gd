extends Button
class_name OptionsSelect

@export var highlighter: Sprite2D
@export var labelText: String
@export var type: ButtonType
@onready var animationStateMachine: PlayerAnimationHandler = $"../../../AnimationTreePlayer"
@onready var hintTextLabel: Label = $"../UI_Hint_Text"
@onready var cameraAnimSM: CameraAnimationHandler = $"../../../AnimationTreeCamera"
@onready var parent: UI_Parent = $".."
@onready var settings: CanvasLayer = $"../Settings/CanvasLayer"
@onready var audioSettings: AudioSettingsLoader = $"../Settings/CanvasLayer/MarginContainer/VBoxContainer/AudioMargin/AudioSettings"
@onready var gm: GameManager = $"../../../GameManager"
var previousVisibleState: bool = false
enum ButtonType {EXIT, SETTINGS, START, HOW_TO}

func _ready():
	self.animationStateMachine.animation_finished.connect(self._on_animation_tree_camera_animation_finished)
	self.mouse_entered.connect(_on_focus_entered)
	self.mouse_exited.connect(_on_focus_exited)
	self.focus_entered.connect(_on_focus_entered)
	self.focus_exited.connect(_on_focus_exited)
	self.pressed.connect(_on_button_pressed)
	

func _on_focus_entered():
	grab_focus()
	self.highlighter.set_visible(true)
	self.hintTextLabel.text = labelText
	self.hintTextLabel.set_visible(true)
	pass

func _on_focus_exited():
	self.highlighter.set_visible(false)
	self.hintTextLabel.set_visible(false)
	
func _on_button_pressed():
	if self.type == ButtonType.EXIT:
		self.animationStateMachine.endGame()
	elif self.type == ButtonType.SETTINGS:
		self.animationStateMachine.openSettings()
	elif self.type == ButtonType.START:
		self.parent.startNewGame()
		self.gm.generate_seed()
		self.gm.create_new_game()
		self.animationStateMachine.startGame()
	elif self.type == ButtonType.HOW_TO:
		self.animationStateMachine.open_How_To_Play()
	self.highlighter.set_visible(false)
	self.hintTextLabel.set_visible(false)
		
func _on_animation_tree_camera_animation_finished(anim_name: StringName) -> void:
	if anim_name.to_lower().contains("charakter_openmenu") or anim_name.to_lower().contains("openedmenu"):
		self.visible = true
		self.disabled = false
		
func triggerCameraPanningUp():
	self.cameraAnimSM.endGame()
	
func startButtonGrabFocus():
	if self.type == ButtonType.START:
		self.grab_focus()

func _input(event: InputEvent) -> void:
	if self.has_focus() and (event.is_action_released("Interact") or event.is_action_released("Jump")):
		self.pressed.emit()


func _on_close_settings_pressed() -> void:
	self.settings.hide()
	self.audioSettings.save()
