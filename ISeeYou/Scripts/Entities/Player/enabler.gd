extends Node2D
class_name Enabler

@export var base_cooldown : float = 1.5
@export var visibility_nodes: Array[Node2D]
@export var enabled_nodes: Array[EnabledDisabled]
@export var allow_handling: bool = true
var cur_cooldown_time: float = base_cooldown
var enabled : bool = false #OnOff

signal activated()
signal deactivated()
signal allow_handling_changed(allowed: bool)

func _ready() -> void:
	if enabled:
		self.enable_nodes()
		self.activated.emit()
	elif not enabled:
		self.disable_nodes()
		self.deactivated.emit()

func _process(delta: float) -> void:
	cur_cooldown_time = minf(base_cooldown, cur_cooldown_time + delta)
	if not self.enabled :
		self.disable_nodes()

func _input(event: InputEvent) -> void:
	if not allow_handling:
		return
	if event.is_action_pressed("Action"):
		if cur_cooldown_time < base_cooldown:
			print("cooldown is active")
		if not enabled and cur_cooldown_time >= base_cooldown:
			self.enable_nodes()
			self.enabled = true
			self.activated.emit()
			return
		elif enabled:
			self.disable_nodes()
			self.cur_cooldown_time = 0
			self.enabled = false
			self.deactivated.emit()
			return
				
func enable_nodes():
	if visibility_nodes:
		for node in visibility_nodes:
			node.visible = true
	#TODO maybe add enabler class and "enable" method
	if enabled_nodes:
		for node in enabled_nodes:
			node.enable()
	
func disable_nodes():
	if visibility_nodes:
		for node in visibility_nodes:
			node.visible = false
	if enabled_nodes:
		for node in enabled_nodes:
			node.disable()
#TODO maybe add enabler class and "disable" method

func set_allow_handling(handling: bool):
	self.allow_handling = handling
	self.allow_handling_changed.emit(handling)
	

func disable_externally():
	self.disable_nodes()
	self.enabled = false
	self.deactivated.emit()
