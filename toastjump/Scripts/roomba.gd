extends Area2D
class_name Roomba

@export var speed : float = 200
@export var startPointX : float = 0
@export var endPointX : float = 1000
var direction : Vector2i = Vector2i.RIGHT
var startedTimer : bool = false
var delayTime : int = 20
var timeIsUp : bool = false

var timer: Timer

@export var forceX : float = 10
@export var forceY : float = 1

signal roomba_hit()

func _ready():
	self.timer = Timer.new()
	self.timer.wait_time = delayTime
	self.timer.one_shot = true
	self.timer.timeout.connect(Callable(self, "timeUp"))
	self.add_child(self.timer)
	
func timeUp():
	self.timeIsUp = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !self.startedTimer :
		self.startedTimer = true
		self.timer.start()
		return
	if !self.timeIsUp :
		return
		
	self.position += delta * speed * direction
	if self.position.x >= endPointX and direction != Vector2i.LEFT:
		self.direction = Vector2i.LEFT
		self.invertAttributes()
	elif self.position.x <= startPointX and direction != Vector2i.RIGHT:
		self.direction = Vector2i.RIGHT
		self.invertAttributes()

func invertAttributes():
	self.scale.x *= -1
	self.forceX *= -1


func _on_body_entered(body: Node2D) -> void:
	print("entered roomba area")
	if body is Player:
		body.playerWasHitByRoomba = true
		body.roombaForceX = forceX
		body.roombaForceY = forceY
		roomba_hit.emit()
