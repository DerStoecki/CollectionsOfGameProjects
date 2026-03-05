extends AudioStreamPlayer2D
class_name AudioTriggerAreaBased

@onready var sfxTriggerParent: SFXTrigger = $"../.."
@export var triggerOnlyOnce : bool = true
@export_range(0.0, 0.2) var randomPitchRange
@onready var basePitch = self.pitch_scale

func _on_area_2d_body_entered(body: Node2D) -> void:
	if self.playing :
		return
	if body is Player:
		if self.sfxTriggerParent.gm:
			if not self.triggerOnlyOnce or checkToTrigger():
				self.playIfPossible()
				return
			else:
				self._on_finished()

func _on_finished() -> void:
	self.sfxTriggerParent.has_been_played(self.triggerOnlyOnce)
	
func checkToTrigger() -> bool:
	return self.sfxTriggerParent.gm and not self.sfxTriggerParent.gm.hasLocalSFXplayed(self.sfxTriggerParent.ID)
	
func playIfPossible():
	if self.stream:
		self.pitch_scale = basePitch + randf_range(randomPitchRange * -1, randomPitchRange)
		self.play()
