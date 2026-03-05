extends Control
class_name PlayerStateUI

@onready var player: Player = $"../../Player"
@onready var healthy: TextureRect = $Healthy
@onready var posessed: TextureRect = $Posessed
@onready var dead: TextureRect = $Dead

signal healthStateChanged(health: Health.HealthState)

func _ready() -> void:
	if player:
		player.getHealth().damaged.connect(_healthChanged)
		player.getHealth().healed.connect(_healthChanged)
		player.getHealth().dead.connect(_healthChanged)
		call_deferred("_healthChanged")
		
func _healthChanged():
	print(player.getHealth().state)
	self.healthStateChanged.emit(player.getHealth().state)
