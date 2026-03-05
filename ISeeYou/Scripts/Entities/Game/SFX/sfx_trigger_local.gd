extends Node2D
class_name SFXTrigger

@export var ID : int  = 0
@export var gm: GameManager
@export var isTest: bool = false
@export var audio: AudioStream
@onready var streamplayer: AudioTriggerAreaBased = $Area2D/AudioTrigger

func _ready():
	self.streamplayer.stream = self.audio


func has_been_played(triggerOnlyOnce: bool):
	if triggerOnlyOnce and gm:
		if not isTest:
			self.gm.localSFXplayed(ID)
		self.queue_free()
