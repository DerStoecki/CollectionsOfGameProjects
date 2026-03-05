extends Control

class_name TEST_UNLOCK

@export var unlockBlueprintId: int

@export var inventoryManager: InventoryManager

@export var menuToShow: GameWonHandler

@export var clickable: bool
@export var spriteToDelete: Sprite2D
var selected: bool

func _on_mouse_entered():
	print("selected")
	selected = true
	
func _on_mouse_exited():
	selected = false

func _on_gui_input(event):
	if not selected or not clickable:
		return
	if event.is_action_pressed("action_left_click"):
		inventoryManager.unlock_Blueprint(unlockBlueprintId)
		menuToShow.visible = true
		spriteToDelete.queue_free()
	pass # Replace with function body.
