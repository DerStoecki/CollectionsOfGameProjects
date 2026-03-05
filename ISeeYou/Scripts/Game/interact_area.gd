extends Area2D
class_name InteractArea

@export var interactionType: InteractType = InteractType.ON_ENTER
@export var player_in_area : bool = false
@export var interactable: bool = true
@onready var interactTexture: Node2D = $InteractIcon

enum InteractType {ON_ENTER, ONCE, ALWAYS}

signal interacted()

func _on_body_entered(_body: Node2D) -> void: ## Player is body
	#print("player entered")
	self.player_in_area = true
	self.interactTexture.visible = interactable
	
func _on_body_exited(_body: Node2D) -> void: ## Player is body
	self.player_in_area = false
	self.interactTexture.visible = false
	if self.interactionType == 0:
		self.interactable = true
	
func _input(event: InputEvent) -> void:
	if not self.player_in_area or not interactable:
		return
	if event.is_action_pressed("Interact"):
		match self.interactionType:
			0, 1: 
				self.interactable = false
				self.interactTexture.visible = false
		self.interacted.emit()
