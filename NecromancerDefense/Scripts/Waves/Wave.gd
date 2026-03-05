extends Node
class_name Wave

## A Wave has multiple WaveContents.
## A WaveContent usually has one enemy type and spawns them in a certain amount of time
## Each WaveContent starts simultaniously therefor we can have a simple wavecontent
## When the Wave is done, we can emit the signal to the wave manager

@export var contents: Array[PackedScene] = [preload("res://Scenes/Level/Waves/WaveContent/wave_content.tscn")]
var contentCount: int = 0
signal wave_done()

func start_wave_spawning(gridManager: GridManager):
	for content in contents:
		var c = content.instantiate() as WaveContent
		self.add_child(c)
		c.connect("waveContentDone", Callable(self, "onWaveContentDone"))
		c.start_wave_content(gridManager)
		contentCount += 1


func onWaveContentDone():
	contentCount -= 1
	if contentCount <= 0:
		wave_done.emit()
		self.queue_free()
