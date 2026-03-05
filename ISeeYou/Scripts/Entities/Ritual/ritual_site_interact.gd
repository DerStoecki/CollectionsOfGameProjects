extends Area2D
class_name RitualSiteInteract

@export var totemID : int = 1
@onready var interactIcon : Node2D = $InteractIcon
@onready var totemSprite : Sprite2D = $TotemTexture
@onready var ritual : Ritual = $".."
## player entered area, and listen to action input
@export var in_area : bool = false
@onready var particles : CPUParticles2D = $CPUParticles2D


var awaitTotem : bool = true

signal interact(totemID: int)

func _ready():
	self.totemSprite.texture = load("res://Assets/Images/Totems/Totem_%s.png" % self.totemID)
	self.ritual.ritualStarted.connect(_on_ritual_started)
	self.ritual.ritualEnded.connect(_on_ritual_ended)


func _input(event: InputEvent) -> void:
	if not self.in_area or not awaitTotem:
		return
	if event.is_action_pressed("Interact"):
		if self.ritual.gm.hasTotem(self.totemID):
			self.interactIcon.visible = false
			self.totemSprite.set_visible(true)
			self.interact.emit(self.totemID)
			self.ritual.totemPlaced(self.totemID)
			self.awaitTotem = false
			self.monitoring = false


func _on_body_entered(_body: Node2D) -> void: ## Player is body
	if  self.ritual.gm.hasTotem(self.totemID) and self.awaitTotem:
		self.in_area = true
		self.interactIcon.visible = true
	if not self.ritual.gm.hasTotem(self.totemID):
		self.totemSprite.visible = true
	
func _on_body_exited(_body: Node2D) -> void: ## Player is body
	self.in_area = false
	self.interactIcon.visible = false
	if self.awaitTotem:
		self.totemSprite.visible = false

func _on_ritual_started(_rite: Ritual):
	self.monitoring = false
	self.in_area = false
	self.particles.emitting = true
	pass

func _on_ritual_ended():
	self.particles.emitting = false
