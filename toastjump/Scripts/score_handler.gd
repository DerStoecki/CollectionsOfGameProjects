extends Node
class_name ScoreHandler

@onready var gm : GameManager = $".."
@onready var curScore : ScoreLabel = $"../ScoreBoard/VBoxContainer/Score"
var scoreSavePath : String = "res://Meta/Score.json"
var scores : Dictionary
var playerScore: int = 0
const nameKey : String = "name"
const scoreKey : String = "score"
var scoreProcessed : bool = false
var playerName : String = ""
var placement : int = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.scores = parse_scores()

func parse_scores() -> Dictionary:
	var fileExists = FileAccess.file_exists(scoreSavePath)
	if fileExists:
		var dataFile : FileAccess = FileAccess.open(scoreSavePath, FileAccess.READ)
		var scoreSave = JSON.parse_string(dataFile.get_as_text())
		print(str(scoreSave))
		return scoreSave as Dictionary
	return {}

func update() -> void:
	if gm.isGameOver and !scoreProcessed:
		scoreProcessed = true
		var curBestScoreKey : int = 100
		playerScore = self.curScore.score
		for key in scores.keys():
			var scoreEntry : Dictionary = scores[key]
			var savedScore : float = scoreEntry[scoreKey]
			if playerScore > savedScore and curBestScoreKey > int(key):
				curBestScoreKey = int(key)
				print("Better Score Found")
		if curBestScoreKey < 100:
			self.placement = curBestScoreKey
			handleImprovedScore()
	
func handleImprovedScore():
	# At point of best KEY get entry -> push to next -> if key is 10 -> throw away
	# Await Player input TODO
	var scoreForNext : float = 0
	var nameForNext : String = ""
	for key in scores.keys():
		if int(key) < self.placement:
			continue
		var scoreEntry: Dictionary = scores[key]
		if int(key) == self.placement:
			scoreForNext = scoreEntry[scoreKey]
			nameForNext = scoreEntry[nameKey]
			scores[key][scoreKey] = playerScore
			scores[key][nameKey] = playerName
			continue
		var tmpScoreForNext : float = scoreEntry[scoreKey]
		var tmpNameForNext : String = scoreEntry[nameKey]
		scores[key][scoreKey] = scoreForNext
		scores[key][nameKey] = nameForNext
		scoreForNext = tmpScoreForNext
		nameForNext = tmpNameForNext

func updatePlayerName(plName: String) -> void:
	self.playerName = plName
	scores[str(self.placement)][nameKey] = plName

func writeNewScore():
	var fileExists = FileAccess.file_exists(scoreSavePath)
	if fileExists:
		var dataFile : FileAccess = FileAccess.open(scoreSavePath, FileAccess.WRITE_READ)
		var json_string = JSON.stringify(scores)
		dataFile.store_string(json_string)
