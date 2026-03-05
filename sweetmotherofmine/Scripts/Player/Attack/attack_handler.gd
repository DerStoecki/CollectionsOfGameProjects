extends Node2D
class_name PlayerAttackHandler

@onready var parent: Player = $".."
@onready var melee: MeleeHandler = $Melee
@onready var magic: MagicHandler = $Magic

@export var nextInput: MotionInput = 0
@export var currentInput: MotionInput = 0
@export var queueTime: float
## For Up Down
@export var inputSensitivity: float

var currentTime : float = 0.0


enum MotionInput {NONE, MELEE_FRONT, MELEE_UP, MELEE_DOWN, MAGIC_ONE, MAGIC_TWO, MAGIC_THREE}

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Interact"):
		self.nextInput = 0
	elif Input.is_action_just_pressed("Attack"):
		var axisUpDown = Input.get_axis("Up", "Down")
		if axisUpDown and abs(axisUpDown > inputSensitivity):
			if axisUpDown < 0:
				self.nextInput = MotionInput.MELEE_UP
			else :
				self.nextInput = MotionInput.MELEE_DOWN
		else:
			self.nextInput = MotionInput.MELEE_FRONT
	elif Input.is_action_just_pressed("Magic1"):
		self.nextInput = MotionInput.MAGIC_ONE
	elif Input.is_action_just_pressed("Magic2"):
		self.nextInput = MotionInput.MAGIC_TWO
	elif Input.is_action_just_pressed("Magic3"):
		self.nextInput = MotionInput.MAGIC_THREE
	else :
		self.currentTime += delta
	if self.currentTime >= self.queueTime :
		self.nextInput = MotionInput.NONE
		self.currentTime = 0
	self.triggerNextState()

func interrupt() -> void:
	self.currentInput = 0
	self.nextInput = 0
	
func resolve() -> void:
	self.currentInput = self.nextInput
	self.nextInput = 0
	self.currentTime = 0

func forceSetState(stateAsInt: int) -> void:
	pass
	
func triggerNextState() -> void:
	if self.currentInput >= 1 and self.currentInput <= 3:
		self.melee.resolveState(self.currentInput)
	if self.currentInput >= 4 and self.currentInput <= 6:
		self.magic.resolveState(self.currentInput)
	
