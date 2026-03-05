extends PathFindingEnemy
class_name RitualPathFinding

@onready var sprite: Sprite2D = $BaseEnemy/GhostSprite
@onready var shadow : Sprite2D = $BaseEnemy/GhostShadow
@export var ritual: Ritual

func _ready():
	call_deferred("set_process", false)
	if ritual and not ritual.ritualStarted.is_connected(_on_ritual_started):
		ritual.ritualStarted.connect(_on_ritual_started)
		ritual.ritualEnded.connect(_on_ritual_ended)

func _on_player_detector_area_hit_player() -> void:
	self.call_deferred("queue_free")

func _on_ritual_started(_ritual):
	self.set_process(true)
	self.sprite.visible = true
	self.shadow.visible = true
	
func _on_ritual_ended():
	self.call_deferred("queue_free")
