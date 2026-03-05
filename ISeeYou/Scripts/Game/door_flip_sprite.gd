extends Node2D
class_name DoorSpriteFlip


@onready var sprites : Node2D = $InteractArea/InteractIcon
@export var connectedRoomID: int
@onready var gm : GameManager = $"../../GameManager"
@onready var particles : CPUParticles2D = $RoomHint
@export var hasSecondRoomId: bool
@export var secondRoomId: int

func _ready():
	if self.scale.x < 0:
		self.sprites.scale.x *= -1
	if gm : 
		if self.gm.has_totem_in_room(self.connectedRoomID):
			self.particles.emitting = true
		elif self.hasSecondRoomId and self.gm.has_totem_in_room(self.secondRoomId):
			self.particles.emitting = true
			
	
