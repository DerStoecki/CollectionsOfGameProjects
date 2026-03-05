extends Node2D
class_name Ritual

@export var gm : GameManager
@export var minTotemCount : int = 3
@export var initialTimeSeconds : int = 600
@export var reductionTimePerTotem: int = 30
@onready var ritualTime : int = initialTimeSeconds
@onready var ritualArea : Area2D = $RitualArea
@onready var interactIcon: Node2D = $RitualArea/InteractIcon
@onready var timer: Timer = $RiteTimer

@export var curTotemCount: int = 0

var initiatedRitual : bool = false

var listenToInput = false

signal ritualStarted(ritual: Ritual)
signal ritualEnded()
signal ritualInitiated()

func _ready():
	for ritualSite in get_children():
		if ritualSite is RitualSiteInteract:
			if not ritualSite.interact.is_connected(_on_ritualPillar_interaction):
				ritualSite.interact.connect(_on_ritualPillar_interaction)
	if self.gm:
		if not self.ritualStarted.is_connected(gm._on_ritual_started):
			self.ritualStarted.connect(gm._on_ritual_started)
			self.ritualEnded.connect(gm._on_ritual_ended)

func totemPlaced(id: int):
	self.gm.totemPlaced(id)
	self.curTotemCount += 1
	self.ritualTime -= reductionTimePerTotem
	if self.curTotemCount >= minTotemCount:
		self.ritualArea.monitoring = true

func _input(event: InputEvent) -> void:
	if not self.listenToInput or self.curTotemCount < minTotemCount:
		return
	if event.is_action_pressed("Interact"):
		self.interactIcon.visible = false
		self.ritualArea.monitoring = false
		self.ritualArea.body_entered.disconnect(_on_ritual_area_body_entered)
		self.ritualArea.body_exited.disconnect(_on_ritual_area_body_exited)
		self.timer.start(self.ritualTime)
		self.ritualStarted.emit(self)

func _on_ritual_area_body_entered(_body: Node2D) -> void:
	if self.curTotemCount >= minTotemCount:
		self.listenToInput = true
		self.interactIcon.visible = true
	

func _on_ritual_area_body_exited(_body: Node2D) -> void:
	self.listenToInput = false
	self.interactIcon.visible = false
	
func _on_rite_timer_timeout() -> void:
	ritualEnded.emit()

func _on_ritualPillar_interaction(_totem) -> void:
	if not self.initiatedRitual:
		self.ritualInitiated.emit()
		self.initiatedRitual = true
