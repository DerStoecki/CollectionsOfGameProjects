extends Node
class_name MovementConditionHandler

## Normal Move Speed
@export var base_speed : float = 0.1
## Speed when in Flashlight for a short amount of time
@export var slowed_speed : float = 0.02
## Speed when in Flashlight for a long time
@export  var freeze_speed: float = 0

## Time until Slowed Speed is applied
@export var time_to_apply_slow : float = 1
## When not in Flashlight And was slowed -> recovery time
@export var slow_recovery: float = 0.5
## when not in flashlight and was not slowed -> reset time to apply slow
@export var time_to_reset_slow_time = 2
var curTimeToSlow: float = 0 # important if in flashlight
var curRecoveryTimeSlow: float = 0  # important if state slowed and now not in flashlight
var curResetSlowTime: float = 0 # important if state is normal and not in flashlight
## Time until Froze Speed is applied
@export var time_to_apply_freeze: float = 5
## When not in Flashlight And was frozen -> recovery time
@export var time_to_reset_freeze_time: float = 2
## when not in flashlight and was not frozen -> reset time to apply slow
@export var freeze_recovery: float = 3
var curTimeToFreeze: float = 0 # important if in flashlight
var curRecoveryTimeFreeze: float = 0 # important if state frozen and now not in flashlight
var curResetFreezeTime: float = 0 # important if state is normal and not in flashlight

@export var movementState: MovementState = MovementState.NORMAL

@onready var cur_speed : float = base_speed

var inFlashlight: bool = false

enum MovementState {NORMAL, SLOWED, FREEZE}

signal slowDown()
signal freeze()
signal normalMoveSpeed()

func _ready():
	self.normalMoveSpeed.emit()

func _set_base_speed():
	self.cur_speed = base_speed
	
func _set_slowed_speed(): 
	self.cur_speed = slowed_speed
	
func _process(delta: float) -> void:
	if inFlashlight:
		handleInFlashlight(delta)
	else: 
		handleNotInFlashlight(delta)

func _on_flashlight_area_entered_flashlight() -> void:
	self.inFlashlight = true
	
func _on_flashlight_area_exited_flashlight() -> void:
	self.inFlashlight = false
	
func handleInFlashlight(delta: float):
	self.curTimeToFreeze = minf(time_to_apply_freeze, curTimeToFreeze + delta)
	self.curTimeToSlow = minf(time_to_apply_slow, curTimeToSlow + delta)
	self.curRecoveryTimeSlow = 0
	self.curResetSlowTime = 0
	self.curRecoveryTimeFreeze = 0
	self.curResetFreezeTime = 0
	
	if self.movementState == MovementState.NORMAL:
		if curTimeToSlow >= time_to_apply_slow:
			self.movementState = MovementState.SLOWED
			self.cur_speed = slowed_speed
			slowDown.emit()
	elif self.movementState == MovementState.SLOWED:
		if curTimeToFreeze >= time_to_apply_freeze:
			self.movementState = MovementState.FREEZE
			self.cur_speed = 0
			self.freeze.emit()
	elif self.movementState == MovementState.FREEZE:
		#Nothing to do
		pass
	
func handleNotInFlashlight(delta: float):
	if self.movementState == MovementState.FREEZE:
		self.curRecoveryTimeFreeze += delta
		if curRecoveryTimeFreeze > freeze_recovery:
			self.movementState = MovementState.NORMAL
			self.normalMoveSpeed.emit()
			self.cur_speed = base_speed
	elif self.movementState == MovementState.SLOWED:
		self.curRecoveryTimeSlow += delta
		if curRecoveryTimeSlow > slow_recovery:
			self.movementState = MovementState.SLOWED
			self.normalMoveSpeed.emit()
			self.cur_speed = base_speed
	else: # NORMAL
		self.curResetFreezeTime = minf(time_to_reset_freeze_time, curResetFreezeTime + delta)
		self.curResetSlowTime = minf(time_to_reset_slow_time, curResetFreezeTime + delta)
		if curResetFreezeTime >= time_to_reset_freeze_time:
			self.curTimeToFreeze = 0
		if curResetSlowTime >= time_to_reset_slow_time:
			self.curTimeToSlow = 0
