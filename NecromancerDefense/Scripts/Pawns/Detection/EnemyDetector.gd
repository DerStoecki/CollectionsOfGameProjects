extends Node2D
class_name EnemyDetector

## The EnemyDetector operates as a base class for AttackHandler.
## When you configure an enemy group and owngroup, it can differentiate between detections
## Always Override the detect_enemies method to ensure Controller Specific logic.
## But also call the parent method to signal the attackhandler, that enemy Pawns are detected.


@export var enemyGroup: PawnGroup.Group
@export var ownGroup: PawnGroup.Group
@export var detectionTime: int = 3 

var parentPawn: Pawn
var detected_enemies: Array[Pawn] = []
var timer: Timer = null

signal enemy_detected(target: Array[Pawn])
signal no_enemy_detected()

var initialized : bool = false

func _ready() -> void:
	_setup()

func _setup():
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = detectionTime
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	timer.start()
		
func my_initialize(parent : Pawn) :
	self.parentPawn = parent
	if self.parentPawn.get_gridManager() == null:
		return
	self.initialized = true
	
func _process(_delta): # TODO move to parent Pawn and check if everything is initialized otherwise call my_initialize
	if !initialized:
		self.my_initialize(self.parentPawn)
		return
	else:
		self.set_process(false)
		
func _on_timer_timeout() -> void:
	if self.parentPawn:
		self.parentPawn.set_state(Pawn.State.DETECTING_ENEMY)
	
func detect_enemies() :
	self.parentPawn.hasDetectedEnemies = detected_enemies.size() > 0
	if detected_enemies.size() > 0:
		print(str(self.parentPawn.name, " Enemy Detected!"))
		emit_signal("enemy_detected", detected_enemies)
	else:
		emit_signal("no_enemy_detected")

func is_enemy(pawn: Pawn) -> bool:
	return self.parentPawn.isPlayerPawn != pawn.isPlayerPawn

func is_enemy_or_remove(pawn: Pawn) -> bool:
	var isEnemy = is_enemy(pawn)
	if !isEnemy and detected_enemies.has(pawn):
		detected_enemies.erase(pawn)
	return isEnemy

func hasParentCollided():
	self.parentPawn.has_Collided()

		
