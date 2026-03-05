extends Node
class_name GameManager

@export var waveManager: WaveManager
@export var gridManager: GridManager
@export var globalResourceSpawner : GlobalResourceSpawner
@export var root : NodePath

var win : bool = false

##
## The Game Manager handles levels and stages, loads the WaveManager etc etc
## TODO load "levels" which contain Scenes and GridManager...
## After Each level and loadout -> do you really want to delete all plants?
## Maybe in the future -> Load out phase -> allow to build / Swap units
##
##


func _on_game_started():
	self.waveManager.start_waves(gridManager)
	gridManager.connect("all_enemies_defeated", Callable(self, "_on_game_won"))


func _on_game_won():
	print("YAY game won")
	win = true
	get_node(root).get_tree().paused = true
