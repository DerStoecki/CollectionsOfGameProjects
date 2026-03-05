extends Node2D
class_name CollectibleSpawner

@onready var score: ScoreLabel = $"../ScoreBoard/VBoxContainer/Score"

@export var collectibleScenes : Array[PackedScene] = [preload("res://Scenes/collectible.tscn")]
@export var negativeCollectibles : Array[PackedScene] = [preload("res://Scenes/collectible_tuna.tscn")]
@export var spawnTime : float = 5
@export var minSpawnTime : float = 1.5
@export var negativeColTime : float = 30
@export var minNegativeColTime : float = 3
@export var spawnPoints : Array[Node2D]
@onready var soundSpawn: AudioStreamPlayer2D = $SpawnSound

var spawnPosTimer : Timer
var spawnNegTimer: Timer
var score_multiplier : int = 1

signal poison_spawned(CollectibleParent)
signal tuna_spawned(CollectibleParent)
signal multiplierChange()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawnPosTimer = Timer.new()
	spawnPosTimer.wait_time = self.spawnTime
	spawnPosTimer.autostart = true
	spawnPosTimer.timeout.connect(Callable(self,"spawn_collectible"))
	self.add_child(spawnPosTimer)
	
	spawnNegTimer = Timer.new()
	spawnNegTimer.wait_time = self.negativeColTime
	spawnNegTimer.autostart = true
	spawnNegTimer.timeout.connect(Callable(self,"spawn_negative"))
	self.add_child(spawnNegTimer)
	self.spawn_collectible()


func update(scorePoints : int):
	if scorePoints > 0:
		scorePoints = scorePoints * score_multiplier
	else :
		scorePoints = scorePoints / score_multiplier
	self.score.update(scorePoints)
	
func spawn_collectible():
	if collectibleScenes.size() == 0 or self.spawnPoints.size() == 0:
		return
	var randCollectible = collectibleScenes[randi_range(0, collectibleScenes.size() - 1)]
	var spawnPoint : Node2D = self.spawnPoints[randi_range(0, spawnPoints.size() - 1)]
	addCollectible(randCollectible, spawnPoint.position)
	if self.spawnTime >= self.minSpawnTime:
		self.spawnTime -= 0.2
		self.spawnPosTimer.wait_time = max(self.spawnTime, self.minSpawnTime)
	
func spawn_negative():
	if negativeCollectibles.size() == 0 or self.spawnPoints.size() == 0:
		return
	var randCollectible = negativeCollectibles[randi_range(0, negativeCollectibles.size() - 1)]
	var spawnPoint : Node2D = self.spawnPoints[randi_range(0, spawnPoints.size() - 1)]
	addCollectible(randCollectible, spawnPoint.position)
	if self.negativeColTime >= self.minNegativeColTime:
		self.negativeColTime -= 0.5
		self.spawnNegTimer.wait_time = max(self.minNegativeColTime, self.negativeColTime)
	

func addCollectible(randCollectible: PackedScene, pos: Vector2) -> void:
	var collectibleInstance : CollectibleParent = randCollectible.instantiate()
	collectibleInstance.position = pos
	collectibleInstance.rotation = randi_range(0, 359) 
	collectibleInstance.selfReady.connect(Callable(self, "connectCollectible"))
	self.add_child(collectibleInstance)
	self.soundSpawn.pitch_scale = randf_range(0.5, 1.5)
	self.soundSpawn.play()
	
func connectCollectible(cp: CollectibleParent):
	cp.collectibleArea.add_points.connect(Callable(self, "update"))
	if cp is PoisonParent:
		(cp.collectibleArea as Poison).gameOver.connect(Callable(self, "gameOver"))
		poison_spawned.emit(cp)
	if cp is Tuna:
		tuna_spawned.emit(cp)
		
func update_multiplier(value: int):
	self.score_multiplier = value
	self.multiplierChange.emit()
		
func gameOver():
	(self.get_parent() as GameManager).gameOver()
