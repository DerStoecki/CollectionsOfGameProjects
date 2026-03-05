extends Node
class_name WaveContent

## A WaveContent is used by the Wave class to check
## if there are still enemies left within the wave itself
## every content has a spawntime and an array of cell positions (where to spawn enemies)
## after the wave signals to start this works on itself by creating new enemy instances each time
## until it is done.
## TODO a delay Timer / checker for Boss Scenes -> should be an extra class


@export var pawn_scene : PackedScene = preload("res://Scenes/Pawns/Attacker/Nystariel.tscn")
@export var cell_positions: Array[Vector2i]
@export var spawnTime: int
var gridManager: GridManager
var currentIndex: int = 0
var timer: Timer
signal waveContentDone()


func _ready():
	pawn_scene.resource_local_to_scene = true
	if self.timer == null:
		create_timer()

	
func next():
	if currentIndex > self.cell_positions.size(): # shouldn't happen
		return
	self.create_pawn()
	self.currentIndex += 1
	if self.timer == null:
		create_timer()
	self.timer.start(self.spawnTime)
	self.check_if_done()

func create_timer():
	self.timer = Timer.new()
	self.timer.autostart = false
	self.timer.one_shot = false
	self.timer.connect("timeout", Callable(self, "next"))
	add_child(self.timer)

func create_pawn():
	var pawn = self.pawn_scene.instantiate() as Pawn
	var cellPos = self.cell_positions[self.currentIndex]
	pawn.position = self.gridManager.map_to_local(cellPos)
	pawn._myInitialize(self.gridManager)
	self.gridManager.register_pawn(pawn, cellPos)
	self.gridManager.add_child(pawn)

func check_if_done():
	if self.currentIndex > cell_positions.size() - 1:
		self.waveContentDone.emit()
		self.queue_free()

func start_wave_content(manager: GridManager) :
	self.gridManager = manager
	self.next()
