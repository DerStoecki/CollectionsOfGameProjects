extends RichTextLabel
class_name HowToPlayRichLabel

@onready var parent: PanelContainer = $".."
@onready var animTreePlay: PlayerAnimationHandler = $"../../../../../AnimationTreePlayer"

var current_input_method : int = 1  # 0 == keyboard, 1 == gamepad
@export_range(100,2000) var scrollSpeed : int = 1000
var displayText : String = \
"They speak of a forgotten place – a Lost Place – hidden deep in the woods. Restless spirits linger, 
bound by an ancient ritual that was never completed. 
You've heard the story... and you've come to uncover the truth.

Your only aid: a flashlight, handed to you before you entered.  
It reveals what hides in the dark –  
and it guides you to the totems needed to complete the ritual.

[center]--Objective--[/center]
Find the scattered totems hidden throughout the mansion.  
The more you collect, the shorter the ritual becomes – but danger grows with each one.
Place them at the Ritualside.
Will you manage to perform the cleansing ritual...  
...and escape the mansion's grip?

[center]-- [b]Controls[/b] - -[/center]


[code]
Move:     {move}
Jump:     {jump} 
Interact: {interact}
Flashlight:  {flashlight}  
[/code]

[b]Tip:[/b] Avoid the lurking shadows.  
Use your flashlight wisely.


"

func ready():
	self._update_control_scheme(gamepad_prompts)
	self.get_v_scroll_bar().value = 0

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		if current_input_method != 1:
			current_input_method = 1
			_update_control_scheme(gamepad_prompts)
	elif event is InputEventMouse or event is InputEventKey:
		if current_input_method != 0:
			current_input_method = 0
			_update_control_scheme(keyboard_prompts)
	if parent.visible:
		if event.is_action_pressed("Cancel"):
			trigger_closing()


func _process(delta: float) -> void:
	var scrollupStrength = Input.get_action_strength("ScrollUp")
	var scrollDownStrength = Input.get_action_strength("ScrollDown")
	if scrollDownStrength > 0.1:
		self.get_v_scroll_bar().value += scrollSpeed * delta
	elif scrollupStrength > 0.1:
		self.get_v_scroll_bar().value -= scrollSpeed * delta

var keyboard_prompts = {
	"move": "WASD, Arrow Keys",
	"interact": "E",
	"jump": "Space",
	"flashlight": "F or RMB"
}

var gamepad_prompts = {
	"move": "Right Analogue Stick",
	"interact": "X",
	"jump": "A",
	"flashlight": "Y or RB"
}

func _update_control_scheme(map : Dictionary):
	self.text = displayText.format(map)
	self.get_v_scroll_bar().value = 0


func _on_focus_exited() -> void:
	trigger_closing()
	

	
func trigger_closing():
	self.parent.visible = false
	self.animTreePlay.close_How_To_Play()



func _on_animation_tree_player_animation_finished(anim_name: StringName) -> void:
	if anim_name.to_lower().contains("howtoplay_open"):
		self.parent.visible = true


func _on_mouse_exited() -> void:
	self.trigger_closing()
