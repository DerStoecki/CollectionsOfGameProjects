extends Node2D
class_name ClutterSpawner

@onready var gm: GameManager = $".."

@export var leftSpawnPoints : Array[Node2D] = []
@export var rightSpawnPoints : Array[Node2D] = []
@export var upSpawnPoints : Array[Node2D] = []
@export var downSpawnPoints : Array[Node2D] = []

@export var clutterSpawnTime: int = 30
@export var minClutterSpawnTime : int = 15
@export var maxSpawnAmount : int = 5
@export var clutterScene : PackedScene = preload("res://Scenes/clutter_area.tscn")
@export var previewAlert : PackedScene = preload("res://Scenes/ClutterAreaPreview.tscn")

var curSpawnPoint : Vector2
var curDirection : Vector2i = Vector2i.RIGHT
var curAmountToSpawn: int = 0
var spawned : int = 0
var clutterSpawnDelay = 0.2


var spawnTimer : Timer

var clutterSpawnTimer : Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.spawnTimer = Timer.new()
	self.spawnTimer.wait_time = clutterSpawnTime
	self.spawnTimer.autostart = true
	self.spawnTimer.timeout.connect(Callable(self, "spawn_clutter_preview"))
	self.add_child(self.spawnTimer)
	self.clutterSpawnTimer = Timer.new()
	self.clutterSpawnTimer.wait_time = clutterSpawnDelay
	self.clutterSpawnTimer.timeout.connect(Callable(self, "spawnClutter"))
	self.add_child(clutterSpawnTimer)


func spawn_clutter_preview() -> void:
	var randDir : int = randi_range(1,4)
	var spawnPoints : Array[Node2D]
	self.curAmountToSpawn = randi_range(1, maxSpawnAmount)
	match randDir:
		2: 
			self.curDirection = Vector2i.DOWN
			spawnPoints = self.upSpawnPoints
		3: 
			self.curDirection = Vector2i.LEFT
			spawnPoints = self.rightSpawnPoints
		4:
			self.curDirection = Vector2i.UP
			spawnPoints = self.downSpawnPoints
		_: 
			self.curDirection = Vector2i.RIGHT
			spawnPoints = self.leftSpawnPoints
			
	self.curSpawnPoint = spawnPoints[randi_range(0, spawnPoints.size() - 1)].position
	print(str(self.curSpawnPoint))
	var previewAlertInstance : Exclamation = self.previewAlert.instantiate()
	previewAlertInstance.position = self.curSpawnPoint
	if randDir % 2 == 0 :
		previewAlertInstance.rotation_degrees = 90
	previewAlertInstance.maxAnimStartedCount = self.curAmountToSpawn
	previewAlertInstance.child_exiting_tree.connect(Callable(self, "spawnClutters"))
	self.add_child(previewAlertInstance)
	
func spawnClutters(_node : Node) -> void:
	if self.clutterSpawnTime >= self.minClutterSpawnTime:
		self.clutterSpawnTime -=2
		self.clutterSpawnTimer.wait_time = max(self.clutterSpawnTime, self.minClutterSpawnTime)
	self.clutterSpawnTimer.start(clutterSpawnDelay)

func spawnClutter():
	var clutterInstance : Clutter = self.clutterScene.instantiate()
	clutterInstance.direction = self.curDirection
	clutterInstance.position = self.curSpawnPoint
	if self.curDirection == Vector2i.UP or self.curDirection == Vector2i.DOWN:
		clutterInstance.rotation_degrees = 90
	clutterInstance.clutter_touched.connect(Callable(self, "player_touched_clutter"))
	self.add_child.call_deferred(clutterInstance)
	if self.curAmountToSpawn > self.spawned :
		self.spawned += 1
		self.clutterSpawnTimer.start(clutterSpawnDelay )
	else:
		self.spawned = 0
		self.clutterSpawnTimer.stop()
		
func player_touched_clutter():
	self.gm.gameOver()
	
