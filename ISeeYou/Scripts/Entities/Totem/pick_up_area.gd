extends Area2D
class_name PickUpArea

@onready var interactIcon : Node2D = $InteractIcon

## player entered area, and listen to action input
@export var in_area : bool = false

var has_been_picked_up : bool  = false

signal interact(totem: Totem)

func _on_totem_area_is_lit_up() -> void:
	self.monitoring = true


func _on_totem_area_is_hidden() -> void:
	self.monitoring = false
	
func _input(event: InputEvent) -> void:
	if not self.in_area or self.has_been_picked_up:
		return
	if event.is_action_pressed("Interact"):
		var bodies : Array[Node2D] = self.get_overlapping_bodies()
		if bodies.any(func(node): return node is Player):
			for body in bodies:
				if body is Player:
					body.getHealth().heal()
			
		interact.emit(self.get_parent())


func _on_body_entered(_body: Node2D) -> void: ## Player is body
	print("player entered totem range")
	if has_been_picked_up:
		print("but has already been picked up")
		return
	self.in_area = true
	self.interactIcon.visible = true
	
func _on_body_exited(_body: Node2D) -> void: ## Player is body
	self.in_area = false
	self.interactIcon.visible = false
