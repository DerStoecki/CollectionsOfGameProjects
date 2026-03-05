extends Node
class_name MovementHorizontal

## The Horizontal Movement moves a Pawn after a certain amount of time forward
## It could be refactored later when playing a certain animation -> to trigger the next position
## e.g. start of animation end of animation moves the pawn forward but actually updates the position
## at the end of the animation.
## This is usually used by the enemy pawns since they are moving towards the player.

@export var speed: float = 50.0
@export var direction: Vector2 = Vector2(-1, 0)  # Default to moving left
@export var cycle_time: float = 1  # Time interval for movement

@export var enabled : bool = true
@export var optionalEnemyDetector: EnemyDetector

var parentPawn: Pawn = null
var timer: Timer = null
var oldPosition: Vector2
@export var withinBounds : bool = true

func _ready() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = cycle_time
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	
func my_initialize(parent_pawn: Pawn) -> void:
	self.parentPawn = parent_pawn
	self.oldPosition = self.parentPawn.position
	self.timer.start()
	self._on_timer_timeout() # check if we can move initially

func _on_timer_timeout() -> void:
	if self.parentPawn:
		var collision : bool = self.parentPawn.has_Collided()
		var hasEnemies: bool = self.optionalEnemyDetector and self.optionalEnemyDetector.detected_enemies.size() > 0
		self.parentPawn.ableToMove = !collision and !hasEnemies and withinBounds

func move_pawn() -> void:
	if enabled == false:
		return
	var mgr = self.parentPawn.get_gridManager()
	self.oldPosition = self.parentPawn.position
	var futurPos = self.parentPawn.position + self.direction * self.speed
	if mgr.is_within_bounds(mgr.local_to_map(futurPos), self.parentPawn.isPlayerPawn):
		self.parentPawn.position = futurPos
		mgr.update_pawn_position_with_local_coordinates(self.parentPawn, self.oldPosition, self.parentPawn.position)
	else:
		withinBounds = false
		self.parentPawn.ableToMove = false
