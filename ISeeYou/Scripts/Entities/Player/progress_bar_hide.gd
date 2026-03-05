extends ProgressBar
class_name ProgressBarHide

@onready var progressBarTimer : Timer = $HideProgressBarTimer
@export var hideTime : float = 1.5

func _ready() -> void:
	self.visible = false
	progressBarTimer.timeout.connect(_on_timer_timeout)


func _on_value_changed(pBValue: float) -> void:
	if pBValue >= max_value:
		progressBarTimer.start(hideTime)
		return
	self.visible = true

func _on_timer_timeout():
	self.visible = false
