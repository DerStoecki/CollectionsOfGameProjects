extends GridContainer
class_name Inventory_GUI


## The Inventory GUI sided.
## This contains all blueprint containers by loading json files and parsing them and setting up all the blueprintcontainer with data
var inventory_manager: InventoryManager
@export var bpContainerScene : PackedScene = preload("res://Scenes/UI/Inventory/BlueprintContainer.tscn")
const bpContainerPrefix: String = "BluePrintContainer_"
var camera : Camera2D
## Limit InventorySize, if not greater 0 this is ignored. If invalid: Use Total BP Size
@export var overrideInventorySize : int = -1
## Only allow certain Pawns to be in the inventory -> only used if not empty
@export var allowdPawns : Array[int] = []

func _my_init(manager: InventoryManager, cam : Camera2D):
	self.inventory_manager = manager
	self.camera = cam

func connect_signals():
	inventory_manager.connect("bpUnlocked", Callable(self, "_on_inventory_manager_bp_unlocked"))
	inventory_manager.connect("init_inventory", Callable(self, "_on_inventory_manager_init_inventory"))
		
func setup_gui():
	var unlocked_bps = inventory_manager.get_unlocked_Blueprints()
	var total_bp_size = inventory_manager.totalAvailableBluePrints
	for index in setupSize(total_bp_size):
		if isNotAllowedIndex(index):
			continue
		var blueprint_container = self.bpContainerScene.instantiate() as BlueprintContainer
		var bpContainername = str(bpContainerPrefix, ResourceUID.create_id()) as String
		blueprint_container.name = bpContainername
		var bp  = inventory_manager.get_blueprint_by_id(index) as BluePrint
		if bp == null:
			print("Blueprint is null, skipped")
			continue
		add_child(blueprint_container)
		blueprint_container = self.get_node(bpContainername)
		print("setting blueprint")
		blueprint_container._my_init(self.camera, self.inventory_manager.gridManager)
		blueprint_container._set_slotType(0)
		blueprint_container._set_blueprint(bp)
		if unlocked_bps.has(index):
			blueprint_container._unlock()
		blueprint_container.connect("loadoutChanged", Callable(self, "_on_blueprint_container_loadout_changed"))
		print("adding child blueprintcontainer")
	self.inventory_manager.create_new_loadout()
	

func _on_inventory_manager_bp_unlocked(id: int):
	for child in get_children():
		if child is BlueprintContainer:
			if child.is_id(id):
				child._unlock()
				return
				

func _on_inventory_manager_init_inventory():
	print("GUI: Inventory Init")
	self.setup_gui()


func _on_blueprint_container_loadout_changed(isLoadut, bpIndex):
	print("on blueprint container loadout changed called")
	for child in get_children():
		if child is BlueprintContainer:
			if child.is_id(bpIndex):
				child.bpSlot._hide(isLoadut)
				break


func unhide(id: int):
	for child in get_children():
		if child is BlueprintContainer:
			if child.is_id(id):
				child.bpSlot._hide(false)

func _get_container() -> Array[BlueprintContainer]:
	return get_children().filter(Callable(self, "isContainer"))
	
func isContainer(child):
	return child is BlueprintContainer
	
func setupSize(_size : int) -> int :
	if self.overrideInventorySize > 0 :
		return self.overrideInventorySize
	return _size
func isNotAllowedIndex(index: int) :
	if self.allowdPawns.size() == 0:
		return false
	return !self.allowdPawns.has(index)
