extends Node
class_name TotemSpawner

## To be able to use "seeds" effectively, each TotemSpawner should have a RngState to set before determening the random position of the Totem Spawn

@export var totemScene: PackedScene = preload("res://Scenes/Entities/Totem.tscn")

#@export var rngState: int = 200
## Allocate a room ID from 0-20
@export_range(0, 30) var allocatedRoomId: int

@onready var gm: GameManager = $"../GameManager"

@onready var spawnPath: PathFollow2D = $SpawnPath/SpawnPathFollow
@export var generated_done: bool = false

var rng : RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	if self.gm and self.gm.game_state.totem_placement_dictionary.size() > 0:
		call_deferred("checkForTotemSpawn")
	
func checkForTotemSpawn():
	if self.generated_done:
		return
	if self.gm and self.gm.game_state.totem_placement_dictionary.has(self.allocatedRoomId):
		if self.gm.game_state.collected_totems.has(self.gm.game_state.totem_placement_dictionary[self.allocatedRoomId]):
			self.generated_done = true
			return
		self.createaAndSetTotem()
		
func createaAndSetTotem():
	## get roomGenerator and set rng state
	## get randf as progress ratio
	## set spawnPath progressRatio and get position
	## initialize totemScene, and set Id as well as Position
	## attach to get_root() and append child
	var randPos : float = self.gm.rng.randf()
	self.spawnPath.progress_ratio = randPos
	var pos : Vector2 = self.spawnPath.global_position
	var totem: Totem = self.totemScene.instantiate()
	totem.ID = self.gm.game_state.totem_placement_dictionary[self.allocatedRoomId]
	totem.global_position = pos
	self.get_parent().add_child.call_deferred(totem)
	self.generated_done = true
