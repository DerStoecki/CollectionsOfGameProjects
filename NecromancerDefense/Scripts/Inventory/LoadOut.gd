extends Node

class_name LoadOut

## Loadout is the gamesided loadout that contains all currently available blueprint
## while the game is runnig
## it is possible to add and remove blueprints, additionally the blueprints Dcitionary contains the 
## slotNubmer and the bpId. 


@export var current_blueprint_slots = 3
@export var blueprints: Dictionary  = {} # slotNo, bpId
@export var lockedLoadout = false
			
func add_blueprint(slotNo: int, bpId: int) -> LoadOut:
	var heldBpId : int = self.blueprints[slotNo] # for swapping
	var heldIndex : int = -1
	if slotNo < current_blueprint_slots:
		for curIndex in self.blueprints:
			var bpIndex : int = self.blueprints[curIndex]
			if bpIndex != null and heldBpId == bpIndex:
				self.blueprints[curIndex] = null #delete existing blueprint of same type
				heldIndex = curIndex
				break
		self.blueprints[slotNo] = bpId
		if heldBpId != null and heldBpId != bpId and heldIndex > -1:
			self.blueprints[heldIndex] = heldBpId # should swap 2 existing blueprints	
	return self

func remove_blueprint(toDeleteId: int) -> LoadOut:
	for index in self.blueprints:
		var bpId : int = self.blueprints[index]
		if bpId == null:
			continue
		if bpId == toDeleteId : 
			self.blueprints[index] = null
			break
	return self
	
func get_load_slot_to_bp_id() -> Dictionary:
	return self.blueprints

func _increaseLoadout():
	self.current_blueprint_slots += 1
