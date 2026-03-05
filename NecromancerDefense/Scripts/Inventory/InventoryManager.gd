extends Node
class_name InventoryManager

## The InventoryManager

## Contains all Available Blueprints, and checks what blueprints are unlocked.
## also it handles how many slots for the loadout are available and what the maximum loadout size might be
## also it contains how many BluePrints are in total available.

@export var blueprintJsonConfigFile: String  = "res://Scripts/Inventory/BlueprintLookUp/BluePrintConstants.json"
@export var unlockedBpsFile: String = "res://Scripts/Inventory/BlueprintLookUp/UnlockedBps.json"
@export var baseBlueprintScene : PackedScene = preload("res://Scenes/Pawns/BluePrint/BluePrint.tscn")
@export var currently_available_slots : int = 2
@export var max_loadOut_size: int = 10 
@export var gridManager: GridManager
@export var totalAvailableBluePrints : int = 45
var all_blueprints: Dictionary = {} # all available blueprints

const unlocked : String = "unlocked"

var unlockedBlueprints: Array[int]

var loadout: LoadOut

signal bpUnlocked(int)
signal slotUnlocked()
signal init_inventory()
signal init_loadout()
signal inventory_manager_start_game()
signal wavespawner_start_game()

# Called when the node enters the scene tree for the first time.
func _ready():
	all_blueprints.clear()
	self.unlockedBlueprints = []
	for floatKey in parse_unlocked_blueprints()[unlocked]:
		self.unlockedBlueprints.append(roundi(floatKey))
	var bpData : Dictionary = parse_blueprints_from_json()
	for blueprintData in bpData.get("BluePrints", []) :
		var bp : BluePrint = self.baseBlueprintScene.instantiate() as BluePrint 
		bp.set_gridManager(self.gridManager)
		if isValidBpData(blueprintData):
			bp = bp._my_init(
					roundi(blueprintData[BluePrintConstantKeys.ID]),
					blueprintData[BluePrintConstantKeys.BP_NAME],
					roundi(blueprintData[BluePrintConstantKeys.RECHARGE_TIME]),
					roundi(blueprintData[BluePrintConstantKeys.RESOURCE_COST]),
					roundi(blueprintData[BluePrintConstantKeys.GROUP]),
					blueprintData[BluePrintConstantKeys.PAWN_SCENE],
					blueprintData[BluePrintConstantKeys.PREVIEW_PAWN_SCENE],
					blueprintData[BluePrintConstantKeys.PEVIEW_TEXTURE])
			if bp == null:
				print("error during parsing of bp data, resetting to default bp")
				bp = self.baseBlueprintScene.instantiate() as BluePrint
			self.all_blueprints[bp.id] = bp
	print("emitting inventory init")
	emit_signal("init_inventory")
	#TODO parse_current

func create_new_loadout():
	self.loadout = LoadOut.new()
	self.loadout.current_blueprint_slots = self.currently_available_slots
	emit_signal("init_loadout")

func isValidBpData(bpData: Dictionary) -> bool:
	return bpData.has(BluePrintConstantKeys.ID) \
	and bpData.has(BluePrintConstantKeys.BP_NAME) \
	and bpData.has(BluePrintConstantKeys.RECHARGE_TIME) \
	and bpData.has(BluePrintConstantKeys.RESOURCE_COST) \
	and bpData.has(BluePrintConstantKeys.GROUP) \
	and bpData.has(BluePrintConstantKeys.PAWN_SCENE) \
	and bpData.has(BluePrintConstantKeys.PREVIEW_PAWN_SCENE) \
	and bpData.has(BluePrintConstantKeys.PREVIEW_PAWN_SCENE)

func parse_unlocked_blueprints() -> Dictionary :
	return parse_json(self.unlockedBpsFile)
	
func parse_blueprints_from_json() -> Dictionary :
	return parse_json(self.blueprintJsonConfigFile)
	
func parse_json(filepath: String) -> Dictionary:
	var fileExists = FileAccess.file_exists(filepath)
	if fileExists:
		var dataFile : FileAccess = FileAccess.open(filepath, FileAccess.READ)
		var unlockedBpsJson = JSON.parse_string(dataFile.get_as_text())
		print(str(unlockedBpsJson))
		return unlockedBpsJson as Dictionary
	else :
		print("File not existing: %s" % filepath )
	return {}

func write_unlocked_blueprint_json():
	var fileExists = FileAccess.file_exists(self.unlockedBpsFile)
	if fileExists:
		var dataFile : FileAccess = FileAccess.open(self.unlockedBpsFile, FileAccess.WRITE_READ)
		var dictionary : Dictionary = {}
		dictionary[unlocked] = self.unlockedBlueprints
		var json_string = JSON.stringify(dictionary)
		dataFile.store_string(json_string)

func unlock_Blueprint(key: int):
	if self.unlockedBlueprints.has(key):
		return
	self.unlockedBlueprints.append(key)
	self.write_unlocked_blueprint_json()
	emit_signal("bpUnlocked", key)
	
func unlock_loadout_slot():
	if self.currently_available_slots < self.max_loadOut_size:
		self.currently_available_slots += 1
		self.loadout._increaseLoadout()
		emit_signal("slotUnlocked")
	
func get_loadout() -> LoadOut:
	return self.loadout
	
func get_unlocked_Blueprints() -> Array[int] :
	return self.unlockedBlueprints
	
func get_blueprint_by_id(id: int) -> BluePrint:
	if not self.all_blueprints.has(id):
		return null
	return self.all_blueprints[id]
	
func get_blueprint_by_id_if_unlocked(id: int) -> BluePrint:
	if self.unlockedBlueprints.has(id):
		return self.get_blueprint_by_id(id)
	return null
	
func start_game():
	inventory_manager_start_game.emit()
