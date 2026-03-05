extends AnimationPlayer
class_name PlayerAnimation

@onready var mover : Mover = $"../Mover"
@onready var player : Player = $".."
var hasDied: bool = false

func _ready() -> void:
	self.call_deferred("_setup")

func _process(_delta: float) -> void:
	if self.current_animation.to_lower().contains("death"):
		self.hasDied = true
	if hasDied:
		return
	if player.is_on_floor() and mover.is_moving:
		if not self.is_playing():
			self.play("Walk")
		return
	self.stop()
	

func _on_player_death():
	$"../Mover".set_script(null)
	$"../Jumper".set_script(null)
	self.play("Death")
	
func _setup():
	self.player.getHealth().dead.connect(_on_player_death)
