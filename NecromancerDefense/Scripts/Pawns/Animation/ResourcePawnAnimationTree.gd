extends AnimationTree
class_name ResourcePawnAnimationTree


var spawn : String = "parameters/conditions/Spawn"
var dead : String = "parameters/conditions/dead"

var idle1: String = "parameters/StateMachine/conditions/Idle1"
var idle2: String = "parameters/StateMachine/conditions/Idle2"
var idle3: String = "parameters/StateMachine/conditions/Idle3"
var stateSpawn: String = "parameters/StateMachine/conditions/spawn"
var idleArray: Array[String]
# Called when the node enters the scene tree for the first time.
func _ready():
	self.active = true
	self.idleArray.append(idle1)
	self.idleArray.append(idle2)
	self.idleArray.append(idle3)
	self.set(idle1, true)

func setIdle():
	self.set(spawn, false)
	self.set(stateSpawn, false)
	self.setRandomIdleState()

func setSpawn():
	self.set(spawn, true)
	self.set(stateSpawn, true)
	self.next()
	
func setDead():
	self.set(dead, true)
	self.next()
	
func next():
	self.get("parameters/playback").next()
	
func setRandomIdleState():
	idleArray.shuffle()
	var isActive : bool = self.get(idleArray[0])
	self.setIdleOneThree(idleArray[0], idleArray[1], idleArray[2])
	if isActive:
		self.get("parameters/StateMachine/playback").start("Idle_1")
	else: 
		self.next()
	
func setIdleOneThree(setI, unsetI1, unsetI2):
	self.set(setI, true)
	self.set(unsetI1, false)
	self.set(unsetI2, false)
