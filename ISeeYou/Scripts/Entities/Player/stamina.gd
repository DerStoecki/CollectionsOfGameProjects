extends Node2D
class_name Stamina

@export var referenced_enabler : Enabler 
@export var max_stamina: int = 100
@export var reduction_per_second : int = 5
@export var recovery_per_second : int = 10
@export var current_stamina : float = max_stamina
@export var min_stamina : int = -10
## When stamina is depleted completely (0 or less) wait until stamina is full to be able to use stamina again
@export var exhaustion_enabled : bool = true 

@export var exhausted : bool = false
@export var is_active : bool = false
@export var progressBar : ProgressBar

signal staminaChange(staminaValue: float)

func _ready() -> void:
	if referenced_enabler:
		self.referenced_enabler.activated.connect(_on_set_activated)
		self.referenced_enabler.deactivated.connect(_on_set_deactivated)
		
func _process(delta: float) -> void:
	if self.is_active:
		reduce_stamina(self.reduction_per_second * delta)
	elif not self.is_active:
		increase_stamina(self.recovery_per_second * delta)
	self.referenced_enabler.set_allow_handling(not exhausted)

func _on_set_activated():
	self.is_active = true
	
func _on_set_deactivated():
	self.is_active = false

func reduce_stamina(amount: float):
	if current_stamina > min_stamina:
		self.current_stamina = maxf(min_stamina, current_stamina - amount)
		self.update_progressbar()
		if self.current_stamina <= 0:
			self.referenced_enabler.disable_externally()
			if self.exhaustion_enabled:
				self.exhausted = true
				self.is_active = false
		
func increase_stamina(amount: float):
	if current_stamina < max_stamina:
		self.current_stamina = minf(max_stamina, current_stamina + amount)
		self.update_progressbar()
		if self.current_stamina == max_stamina:
			exhausted = false
			
func update_progressbar():
	if self.progressBar:
		progressBar.set_value(self.current_stamina)
	self.staminaChange.emit(self.current_stamina)	
