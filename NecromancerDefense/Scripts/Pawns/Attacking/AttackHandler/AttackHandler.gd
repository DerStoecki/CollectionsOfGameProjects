extends Node2D
class_name Attack_Handler

## The Base AttackHandler class
## Either have an instant attacker or an attack rate, when to execute an attack.
## Always Connect your AttackHandler with the Detector!
## When no Detector is given, the AttackHandler won't work.
## Please consider, to use a different initialize method, when you want to use different detectors on the same pawn
## The EnemyDetector updates the detected_enemies
## The Attackhandler will always attack, when the timer is up and enemeies are available
## attack_signal is emitted when you should attack override and connect the signals when implementing an attack handler


@export var attack_rate: float = 5.0  # Time between attacks
@export var instant_attacker : bool = false

signal attack_signal(enemies: Array[Pawn])

var parentPawn: Pawn
var timer: Timer
var detected_enemies : Array[Pawn] = []
# Called when the node enters the scene tree for the first time.
func _ready():
	self.timer = Timer.new()
	self.timer.wait_time = attack_rate
	self.timer.one_shot = false
	self.timer.autostart = false
	self.timer.connect("timeout", Callable(self, "_on_attack_timer_timeout"))
	add_child(timer)
	connect("attack_signal", Callable(self, "_on_attack_signal"))

func _on_attack_signal(enemies: Array[Pawn]):
	self.detected_enemies = enemies

func my_initialize(parent : Pawn) :
	self.parentPawn = parent
	for child in parent.get_children():
		if child is EnemyDetector:
			child.connect("enemy_detected", Callable(self, "_on_enemy_detected"))
			child.connect("no_enemy_detected", Callable(self, "_on_no_enemy_detected"))

func _on_enemy_detected(enemies: Array[Pawn]):
	print("_on_enemy_detected called")
	self.detected_enemies = enemies
	if self.timer.is_stopped():
		self.timer.start(self.attack_rate)
		self.parentPawn.canAttack = false

func _on_no_enemy_detected():
	self.detected_enemies.clear()
	if not self.timer.is_stopped():
		timer.stop()
		self.parentPawn.canAttack = false

func _on_attack_timer_timeout():
	print("Attacking Timer timeout")
	if detected_enemies.size() > 0:
		self.parentPawn.canAttack = true
		emit_signal("attack_signal", self.detected_enemies)
