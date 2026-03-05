extends Label

@onready var gameManager: GameManager = $"../../.."
@onready var scoreHandler: ScoreHandler = $"../../../ScoreHandler"
@onready var scoreBoard : ScoreBoardUI = $"../ScoreBoardUI"

var timer: Timer 
var timeIsUp : bool = false
var notScored : bool = true
var inputDone : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.text = "Press Space to Start"
	self.timer = Timer.new()
	self.timer.wait_time = 2
	self.timer.autostart = false
	self.timer.timeout.connect(Callable(self, "timed"))
	self.add_child(self.timer)
	self.scoreBoard.input_done.connect(_onScoreBoardInputDone)
	
func _process(_delta: float) -> void:
	if self.gameManager.isGameOver:
		self.text = "Try again? Press Space"
		self.notScored = self.scoreHandler.placement < 0
		self.visible = timeIsUp and self.notScored or self.inputDone
	else :
		self.visible = true
	
	if !self.visible:
		if self.timer.is_stopped():
			self.timer.start()
		return
			
	if Input.is_action_just_pressed("ui_accept") and self.visible:
		if self.gameManager.isGameOver:
			self.gameManager.get_tree().reload_current_scene()
		else:
			self.gameManager.startGame()
		
func timed():
	self.timeIsUp = true
	
func _onScoreBoardInputDone():
	self.inputDone = true
	self.scoreBoard.visible = false
	
