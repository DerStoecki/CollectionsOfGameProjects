extends TextureRect
class_name PlayerStateReactorUI

@export var visibleState: Health.HealthState
@onready var playerStateUI: PlayerStateUI = $".."

func _ready():
	if playerStateUI:
		playerStateUI.healthStateChanged.connect(_on_state_changed)

func _on_state_changed(state: Health.HealthState):
	self.visible = state == visibleState
