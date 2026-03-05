extends Node
class_name GameManager

var isGameOver : bool = false

@onready var player : Player = $ToastPlayer
@onready var lh : LifeHandler = $LifeHandler
@onready var roomba: Roomba = $Roomba

func gameOver():
	self.removeLive()
	if self.lh.curLifes > 0:
		return
	print("Game Over")
	self.player.animTree.set("parameters/conditions/gameOver", true)
	get_tree().paused = true
	self.isGameOver = true
	
func startGame():
	get_tree().paused = false
	roomba.roomba_hit.connect(Callable(self, "gameOver"))
	
func _ready():  
	self.get_tree().paused = true
	
func addLive():
	self.lh.addLive()
	
func removeLive():
	self.lh.removeLive()
 
