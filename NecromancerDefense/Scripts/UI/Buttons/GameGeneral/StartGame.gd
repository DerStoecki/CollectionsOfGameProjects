extends Button

### Basic Button functionality to start the game, not finely tuned right now

@export var gridManager : GridManager
@export var gameManager: GameManager
@export var globalResSpawner: GlobalResourceSpawner
@export var inventory: InventoryScroll

var manager: InventoryManager
var game_started: bool = false

func _ready():
	if self.gridManager != null:
		self.manager = self.gridManager.get_inventoryManager()

func _on_pressed():
	if manager:
		manager.start_game()
	if gameManager:
		gameManager._on_game_started()
		game_started = true
		self.disabled = true
	if globalResSpawner:
		globalResSpawner.start()
	if inventory:
		inventory.visible = false
	self.visible = false
	pass # Replace with function body.
