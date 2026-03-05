extends DamageDealer

class_name Projectile

## Projectile is an extension of damagedealer
## maybe an animation tree is not required but would be amazing later
## a projectile usually travels in a certain direction (animation could be looking differently)
## this is just a base class and a WIP

@export var speed: float = 10.0
## unused atm
@export var rangeProjectile: int = 10
@export var tree: AnimationTree
@export var spawnDone: bool = false
@export var travelDistanceTime: float = 10
@export var direction: Vector2 = Vector2(1, 0)
var start : bool = false
var detectedEnemies : Array[Pawn] = []
var yGridPosition : int = 0
var collided : bool = false
var collidedBody : Pawn
var timer: Timer 

# Called when the node enters the scene tree for the first time.
func _ready():
	self.timer = Timer.new()
	self.timer.autostart = false
	self.timer.one_shot = true
	add_child(self.timer)
	self.timer.wait_time = self.travelDistanceTime
	self.timer.connect("timeout", Callable(self, "_on_timer_timeout"))

func startTimer():
	if self.timer.is_stopped():
		self.timer.start()
		
func _on_timer_timeout():
	if self.collided == false: # DO NOT Call mid attack
		self.tree.set("parameters/conditions/attack", true)

func _process(delta):
	super._process(delta)
	if spawnDone and not collided:
		self.position += direction * speed * delta

func set_direction(dir: Vector2):
	self.direction = dir

func set_detected_enemies(enemies: Array[Pawn]):
	self.detectedEnemies = enemies

func _on_body_entered(body: Pawn):
	handle_pawn_detection(body)
	
func setYGridPosition(pos: int):
	self.yGridPosition = pos
	
func handle_pawn_detection(body: Pawn):
	if not spawnDone:
		return
	if collided:
		return
	if body.getCurrentGridPosition().y != self.yGridPosition:
		return
	self.collided = true
	self.collidedBody = body
	if tree:
		self.tree.set("parameters/conditions/attack", true)
	
	
func applyDamage():
	if self.collidedBody == null:
		return
	self.collidedBody.receive_damage(self.get_damage())

func fadeOut(): # called by animation
	self.queue_free()
	


func _on_area_entered(area):
	if area.get_parent() is Pawn:
				handle_pawn_detection(area.get_parent() as Pawn)
