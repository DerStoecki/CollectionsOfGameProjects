extends TextureRect

class_name BlueprintSlot

## The Blueprint slot is like the inner container/placeholder used by the blueprint container
## The blueprint container is the "logic" part where the blueprintslot is just a dum dum holding all information


var containingBlueprint: BluePrint
var is_selected: bool = false
@export var is_game_started: bool = false
@export_enum("INVENTORY:0", "LOADOUT:1") var slot_type: int = 0
@export var is_locked = true
var previewPawn : TextureRect
var lockBp: TextureRect
var isHidden: bool = false

func _my_init():
	previewPawn = $PreviewPawn
	lockBp =  $LockBp

func set_blueprint(bp: BluePrint) -> BlueprintSlot:
	self.containingBlueprint = bp
	self.previewPawn.texture = bp.previewPawnTexture
	self.visible = true
	return self # ToDo
	
func _unlock() -> BlueprintSlot:
	if self.is_locked:
		self.is_locked = false
		lockBp.queue_free()# TODO Trigger Unlock animation
	return self
	
func _set_game_started(): 
	self.is_game_started = true

func _hide(vis: bool):
	self.isHidden = vis
	self.previewPawn.visible = not vis
	
func _is_hidden() -> bool:
	return self.isHidden
	
func _empty_the_slot():
	print(str("empty the slot for type: ", self.slot_type))
	self.containingBlueprint = null
	self.previewPawn.texture = null
	self._hide(true)
	pass
	
func _getId() -> int:
	return self.containingBlueprint.id
