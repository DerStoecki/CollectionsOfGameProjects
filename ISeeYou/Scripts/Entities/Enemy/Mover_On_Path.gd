extends PathFollow2D
class_name MoverOnPath

@onready var movConditionHandler: MovementConditionHandler = $BaseEnemy/MovementCondition
@onready var playerDetectionArea : PlayerDetectorArea = $BaseEnemy/PlayerDetectorArea

signal ratioFinished

func _ready():
	self.set_process(false)

func _reset():
	self.progress_ratio = 0
	
func _disable():
	self.set_process(false)
	
func _enable():
	self.set_process(true)
	
func _process(delta: float) -> void:
	self.progress_ratio += delta * self.movConditionHandler.cur_speed
	if self.progress_ratio >= 1 :
		self.ratioFinished.emit()
