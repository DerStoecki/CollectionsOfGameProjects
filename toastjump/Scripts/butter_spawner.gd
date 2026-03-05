extends Node2D


@export var spawnPoints : Array[Node2D] = []
@onready var collectibleSpawner : CollectibleSpawner = $"../CollectibleSpawner"
@export var butterScene : PackedScene = preload("res://Scenes/butter.tscn")
@export var spawnTime : int = 30
@export var multiplierTime : int = 45
var multiplierTimer : Timer

func _ready():
	var timer: Timer = Timer.new()
	timer.wait_time = spawnTime
	timer.autostart = true
	timer.timeout.connect(Callable(self, "spawn"))
	self.add_child(timer)
	self.multiplierTimer = Timer.new()
	self.multiplierTimer.wait_time = multiplierTime
	self.multiplierTimer.timeout.connect(Callable(self, "resetMulti"))
	self.add_child(self.multiplierTimer)
	
func spawn():
	var butter : Butter = butterScene.instantiate()
	butter.position = spawnPoints[randi_range(0, spawnPoints.size() - 1)].position
	butter.score_multiplier_active.connect(Callable(self, "collected"))
	self.add_child(butter)
	
func collected():
	if self.multiplierTimer.is_stopped():
		self.multiplierTimer.start()
		self.collectibleSpawner.update_multiplier(2)
		return
	var remainingTime = self.multiplierTimer.time_left
	self.multiplierTimer.start(remainingTime + self.multiplierTime)
	self.collectibleSpawner.update_multiplier(self.collectibleSpawner.score_multiplier + 1)
	
func resetMulti():
	self.collectibleSpawner.update_multiplier(1)
