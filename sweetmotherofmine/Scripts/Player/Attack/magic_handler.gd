extends AttackInputResolver
class_name MagicHandler

@export var magic1_upgradeLevel: int = 0 # range
@export var magic2_upgradeLevel: int = 0 # stomp
@export var magic3_upgradeLevel: int = 0 # aoe

@export var cur_mana: int
@export var max_mana: int
@onready var rangedSpell : PackedScene =  preload("res://Scripts/Player/Spells/DummyProjectileSpell.tscn") ## TODO ChangeLater

func add_mana(amount: int)-> void:
	self.cur_mana = min(self.cur_mana + amount, self.max_mana)
	
func subtract_mana(amount: int) -> void:
	self.cur_mana = max(self.cur_mana - amount, 0)
	
func resolveState(state: int) -> void:
	if !self.finishedCurrentStateHandling:
		pass
	else:
		if state == 4:
			handleState1(state)
		elif state == 5:
			handleState2(state)
		elif state == 6:
			handleState3(state)
	
func handleState1(state: int) -> void:
	pass
func handleState2(state: int) -> void:
	pass
func handleState3(state: int) -> void:
	pass
