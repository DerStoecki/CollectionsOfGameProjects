extends Node
class_name LifeHandler

@export var maxLifes : int = 5
@export var curLifes : int = 3

@onready var dmg : AudioStreamPlayer2D = $DamageSound
@onready var heal : AudioStreamPlayer2D = $HealSound
@export var spawnPoints : Array[Node2D] = []

var lifeScene : PackedScene = preload("res://Scenes/heart_game.tscn")

signal lifesChanged()

func addLive():
	if self.curLifes < maxLifes:
		curLifes += 1
		heal.play()
		lifesChanged.emit()
		
func removeLive():
	self.curLifes -= 1
	dmg.play()
	lifesChanged.emit()
	
func _ready():
	var timer = Timer.new()
	timer.wait_time = 20
	timer.autostart = true
	timer.timeout.connect(Callable(self, "_spawn_Heart"))
	self.add_child(timer)


func _spawn_Heart():
	var lifeInstance : HeartInGame = lifeScene.instantiate()
	lifeInstance.position = self.spawnPoints[randi_range(0, spawnPoints.size() - 1)].position
	lifeInstance.heartCollected.connect(Callable(self, "addLive"))
	add_child(lifeInstance)
