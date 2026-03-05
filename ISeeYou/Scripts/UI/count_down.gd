extends Label
class_name CountDown

@onready var gm:GameManager = $"../../GameManager"

var timer: Timer

func _ready():
	self.gm.rite_start_timer.connect(set_timer)
	self.set_process(false)
	self.visible = false

func set_timer(t : Timer):
	self.timer = t
	self.formatTime()
	self.visible = true
	self.set_process(true)
	self.timer.timeout.connect(_on_timeout)
	
func _process(_delta: float) -> void:
	if self.timer:
		formatTime()
	
func _on_timeout():
	self.text = ""
	self.set_process(false)
func formatTime():
	var timeInSeconds :int = int(self.timer.time_left)
	var minutes : int = floor(timeInSeconds / 60.0)
	timeInSeconds = timeInSeconds % 60
	self.text = str("%02d" % minutes,":", "%02d" % timeInSeconds)
