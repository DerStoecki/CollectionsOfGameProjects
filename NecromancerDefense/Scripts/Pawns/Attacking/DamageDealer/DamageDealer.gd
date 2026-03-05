extends Area2D
class_name DamageDealer

## The Damagedealer is the acutal type that damages things
## it is handled by the attackhandler.
## it should only work when the corresponding animation or whatever state is active
## therefore certain logic is required
## could be handled by the animation trees (e.g. hitbox handling)

@export var damage: int = 10
@export var damage_multiplier: float = 1.0
@export var status: String = "TODO"
var checkTime: float = 0.1
var currentTime:float = 1

var damagedPawnIds : Array[int] = []


func set_damage(amount: int):
	damage = amount

func _process(delta):
	currentTime += delta
	if currentTime < checkTime:
		return
	currentTime = 0
	if self.monitoring:
		detectOverlappingAreas()
	else:
		resetDamagedPawns()
				
func handle_pawn_detection(body: Pawn):
	var id = body.get_instance_id()
	if damagedPawnIds.has(id):
		return
	self.damagedPawnIds.append(id)
	body.receive_damage(self.get_damage())
	
func detectOverlappingAreas():
	var areas = get_overlapping_areas()
	for area in areas:
		if area.get_parent() is Pawn:
			handle_pawn_detection(area.get_parent() as Pawn)

func set_Layer_And_Mask(layer: int, mask: int):
	self.set_collision_layer(layer)
	self.set_collision_mask(mask)
	
func add_damage_multiplier(amount: float):
	self.damage_multiplier += amount
	
func add_base_damage(amount: int):
	self.damage += amount
	
func get_damage() -> int:
	return maxi(round(self.damage * self.damage_multiplier), 0) # If i make a healer -> layer masks change and negative damage
	
func resetDamagedPawns():
	self.damagedPawnIds.clear()
