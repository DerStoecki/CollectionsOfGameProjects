extends Node
class_name EnemyEnabler

@export var EnemyID: int = 0
@export var activeAtTotemCount: int = 1
@export var moverOnPath : MoverOnPath
@export var pathFindingEnemy: PathFindingEnemy

@export var curState: EnemyState = EnemyState.IDLE
@export var gm: GameManager
@onready var mostUpperParent : Node2D = $".."
@export var enemyAudio: EnemyAudio

var baseEnemyPlayerHitArea: PlayerDetectorArea

enum EnemyState{IDLE, ACTIVE, POSESSING}


func _ready():
	setup()
		
func setup():
	if moverOnPath:
		self.baseEnemyPlayerHitArea = moverOnPath.playerDetectionArea
	elif pathFindingEnemy:
		self.baseEnemyPlayerHitArea = pathFindingEnemy.playerDetectionArea
	if self.baseEnemyPlayerHitArea and not self.baseEnemyPlayerHitArea.hit_player.is_connected(_on_player_hit):
		self.baseEnemyPlayerHitArea.hit_player.connect(_on_player_hit)
	if self.curState != EnemyState.ACTIVE:
		self._set_idle()
		
func _process(_delta: float) -> void:
	if not self.baseEnemyPlayerHitArea or not self.baseEnemyPlayerHitArea.hit_player.is_connected(_on_player_hit):
		self.setup()
		return
	self.set_process(false)
		
func _on_player_hit():
	self._set_posessing()
	

func _set_idle():
	self.curState = EnemyState.IDLE
	self._on_idle_or_posessed()

func _set_active():
	self.curState = EnemyState.ACTIVE
	self._set_enemy(true)
	if self.enemyAudio:
		self.enemyAudio.call_deferred("allow")

func _set_posessing():
	self._on_idle_or_posessed()
	self.curState = EnemyState.POSESSING
	if self.gm:
		self.gm.set_enemy_posessed(self.EnemyID)
	
func _on_idle_or_posessed():
	self._set_enemy(false)
	if self.enemyAudio:
		self.enemyAudio.call_deferred("forbid")
		
func _set_enemy(state: bool):
	self.mostUpperParent.set_visible(state)
	if self.moverOnPath:
		self.moverOnPath.set_process(state)
		if not state:
			self.moverOnPath.progress_ratio = 0
	elif pathFindingEnemy:
		self.pathFindingEnemy.set_process(state)
		if not state:
			self.pathFindingEnemy.global_position = self.pathFindingEnemy.resetPos
	if self.baseEnemyPlayerHitArea:
		self.baseEnemyPlayerHitArea.call_deferred("set_monitoring", state)
	
		
