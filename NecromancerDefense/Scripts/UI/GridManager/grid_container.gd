extends PanelContainer

class_name Grid_Container

## This is basically the main "level" setup grid where a player can place their pawns
## this is instantiated by the gridmanager itself
## This is to check if a player can drop data etc here


var parent: GridManager

var bluePrint: BluePrint
var gridCoordinates : Vector2i = Vector2i.MIN

func _my_init(par: GridManager, coordinates: Vector2i, cellSize: Vector2):
	self.parent = par
	self.gridCoordinates = coordinates
	self.set_custom_minimum_size(cellSize)
	
	
func _can_drop_data(_at_position, data):
	print("can drop data in Grid Container Called")
	return self.slot_can_drop_here(data)
	# TODO hint on not enough resources via Label or something
	
func slot_can_drop_here(data) -> bool:
	if !(data is BlueprintSlot):
		return false
	var d = data as BlueprintSlot
	return self.visible \
	and self.enoughResources(d.containingBlueprint) \
	and self.space_not_occupied(d)

func _drop_data(_pos, data):
	if self.gridCoordinates == Vector2i.MIN:
		return
	var incomingBpSlot = data as BlueprintSlot
	if self.bluePrint != null:
		#TODO Indicate GridManager replacement of Pawn
		pass
	self.bluePrint = incomingBpSlot.containingBlueprint
	self.parent._create_new_pawn_at_grid_pos(self.bluePrint, self.gridCoordinates)
	
	
func enoughResources(bp: BluePrint) -> bool:
	var resEnough =  self.parent.has_resources(bp.resource_cost, bp.resourceType)
	if not resEnough:
		print("Not enough Resources!")
	return resEnough
	
func space_not_occupied(bpSlot : BlueprintSlot) -> bool:
	if self.bluePrint == null:
		return true
	var compList = CompatibleBlueprints.compatibilityList
	var isCompatible = compList.has(self.bluePrint.id) \
	and (compList[self.bluePrint.id] as Array[int]).has(bpSlot.containingBlueprint.id)
	if !isCompatible:
		print("Space already occupied!")
	return isCompatible
