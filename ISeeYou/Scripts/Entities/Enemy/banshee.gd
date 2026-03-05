extends Node2D
class_name Banshee

@export var player: Player


@export var initialSpawnTimerTime : int
@export var completionCountToDecreaseSpawnTime : int
@onready var enemySpawnTimer : Timer = $EnemySpawnTimer
@onready var windUpTimer : Timer = $WindUpTimer
@onready var mover: MoverOnPath = $Path2D/PathFollow2D
@onready var group : EnemyGroupToEnable = $EnemyGroupsToEnable
var currentSpawnTime : int
var completionCount : int = 0
@onready var bansheeSm : BansheeSM = $Path2D/PathFollow2D/BansheeSM

var readyToSpawn : bool = false
var enemyToSend: EnemyMoveToPoint

func enable():
	self.mover._enable()
	self.windUpTimer.start()
	self.enemySpawnTimer.start()
	self.set_process(true)
	
func reduceCurrentSpawnTime():
	self.currentSpawnTime = max(self.currentSpawnTime - 1, 0.5)

func _ready():
	self.enemySpawnTimer.wait_time = self.initialSpawnTimerTime
	self.currentSpawnTime = self.initialSpawnTimerTime
	self.set_process(false)

func _process(_delta: float) -> void:
	if self.readyToSpawn and self.enemyToSend:
		self.bansheeSm.set_attack()

func _on_enemy_spawn_timer_timeout() -> void:
	self.readyToSpawn = true
	self.set_process(true)


func _on_enemy_spawn_area_area_entered(area: Area2D) -> void:
	var enemyToMove = (area as BansheeArea).parent
	if enemyToMove.pathEnemy.visible: # active enemy -> do not interfere
		return
	self.enemyToSend = enemyToMove
	

func send_enemy(): #called by anim player
	if self.enemyToSend:
		self.readyToSpawn = false
		self.enemySpawnTimer.start(self.currentSpawnTime)
		self.enemyToSend.activate()
		self.enemyToSend = null
		self.windUpTimer.wait_time = max(0.5, self.windUpTimer.wait_time - 0.5)
		self.windUpTimer.start()
		self.set_process(false)

func _on_path_follow_2d_ratio_finished() -> void:
	self.completionCount += 1
	if self.completionCount >= self.completionCountToDecreaseSpawnTime:
		self.reduceCurrentSpawnTime()
		self.completionCount = 0
	
func _on_wind_up_timer_timeout() -> void:
	self.bansheeSm.set_prepare()
