extends Node

class_name WaveManager

## The Wavemanager functions like the Wive, but instead of having wavecontents it has waves
## When all Waves are done signal our gridManager that there are no enemies coming
## This is important later to signal if our game is done or stage is done.


@export var waves: Array[PackedScene] = [preload("res://Scenes/Level/Waves/Wave/wave.tscn")]
@export var gridManager: GridManager
@export var waitTime: int
var waveCount: int = 0
signal spawn_done()


func start_waves(manager: GridManager):
	self.connect("spawn_done", Callable(manager, "on_spawn_done"))
	for wave in waves:
		var w = wave.instantiate() as Wave
		self.add_child(w)
		w.connect("wave_done", Callable(self, "_on_Wave_Done"))
		w.start_wave_spawning(manager)
		waveCount += 1
	
func _on_Wave_Done():
	waveCount -= 1
	if waveCount <= 0:
		spawn_done.emit()
