extends Label
class_name ScoreLabel

@export var score: int = 0


func update(added_points: int):
	self.score = added_points + self.score
	self.text = str(self.score)
	print(str("points added", added_points))
	print("updatedScore: ", self.score)
