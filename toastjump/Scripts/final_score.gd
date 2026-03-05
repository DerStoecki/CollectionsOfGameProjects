extends Label
class_name FinalScore

@onready var scoreLabel : ScoreLabel = $"../../VBoxContainer/Score"
@onready var gameOverScreen : TextureRect = $"../GameOverScreen"
@onready var player: Player = $"../../../ToastPlayer"
@onready var gameManager : GameManager = $"../../.."
@onready var stamina: ProgressBar = $"../../StaminaPlayer"
@onready var scoreHandler: ScoreHandler = $"../../../ScoreHandler"
@onready var scoreBoardUI : ScoreBoardUI = $"../ScoreBoardUI"
var setPlayer : bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if !gameManager.isGameOver:
		return
	if self.setPlayer:
		return
	stamina.visible = false
	self.visible = true
	gameOverScreen.visible = true
	player.position = Vector2(147,561)
	player.scale = Vector2(10, 10)
	scoreHandler.update()
	if self.scoreHandler.placement == -1:
		self.text = str("Final Score:\n", scoreLabel.text)
	else:
		self.text = ""
		self.scoreBoardUI.displayScoreBoard()
		self.scoreBoardUI.visible = true
	self.setPlayer = true
