extends HBoxContainer
class_name ScoreBoardUI

@onready var sb : ScoreHandler = $"../../../ScoreHandler"
@onready var placeContainer : VBoxContainer = $Place
@onready var scoreContainer : VBoxContainer = $Score
@onready var namesContainer : VBoxContainer = $Names
@onready var labelScene: PackedScene = preload("res://Scenes/final_score_label.tscn")

signal input_done()

func displayScoreBoard():
	for key in sb.scores.keys():
		var place : int = int(key)
		var score : float = float(sb.scores[key][sb.scoreKey])
		var scoreName : String = str(sb.scores[key][sb.nameKey])
		var placeLabel : FinalScoreLabel = labelScene.instantiate()
		placeLabel.text = str(place)
		var scoreLabel : FinalScoreLabel = labelScene.instantiate()
		scoreLabel.text = str(score)
		var isPlayer : bool = false
		if sb.placement > 0 and int(key) == sb.placement :
			isPlayer = true
		var nameLabel : FinalScoreLabel = labelScene.instantiate()
		nameLabel.isPlayerScoreName = isPlayer
		nameLabel.active = isPlayer
		if isPlayer:
			nameLabel.userInputReady.connect(_inputReady)
		else:
			nameLabel.text = scoreName
		self.placeContainer.add_child(placeLabel)
		self.scoreContainer.add_child(scoreLabel)
		self.namesContainer.add_child(nameLabel)
	
func _inputReady(plName: String):
	self.sb.updatePlayerName(plName)
	self.sb.writeNewScore()
	self.input_done.emit()
	
