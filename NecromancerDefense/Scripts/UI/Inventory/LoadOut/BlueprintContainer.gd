extends PanelContainer

class_name BlueprintContainer

## This is a helper class to help the loadout/inventory setup phase
## This hold BlueprintSlots -> and therefor godot can check if it is possible to drop/drag data
## This can either be used by the inventory slot or the Inventory indicated by "isLoadout" variable
## If it is a Loadout Container and the game has started -> jump to process gui input -> check if it is selected
##

var bpSlot : BlueprintSlot
var isLoadout = false
var camera: Camera2D
var previewTexture2d: Sprite2D
var selected: bool = false
var manager: GridManager
@export var previewPawn: PackedScene = preload("res://Scenes/Pawns/PreviewPawn/PreviewPawn.tscn")

signal loadoutChanged(isLoadut: bool, bpIndex: int)


func _my_init(cam: Camera2D, gridManager: GridManager):
	self.bpSlot = $BlueprintSlot as BlueprintSlot
	self.bpSlot._my_init()
	self.camera = cam
	self.manager = gridManager

func _can_drop_data(_at_position, data):
	print ("Asking if can_drop_data")
	print("data: ")
	print(str (data))
	if self.bpSlot.is_game_started and data is Grid_Container:
		return (data as Grid_Container).slot_can_drop_here(data)
	return not self.bpSlot.is_game_started and data is BlueprintSlot and is_validDrop(data as BlueprintSlot)
	
## Can be confusing but essentially -> drop into empty slot and "hide" inventory slot -> bc its used
## swap between two loadouts, swap inventory<->loadout and either hide inventory or loadout
## Important -> BP Slots from loadout to inventory can only be parsed if correct id etc inventory bps are only hidden, not deleted
func _drop_data(_pos, data):
	var incomingBpSlot = data as BlueprintSlot
	if self.bpSlot.slot_type == incomingBpSlot.slot_type and self.bpSlot.slot_type == 0:
		return
		# 1. wenn selber loadout und anderes loadout <-> einfach swappen
	if self.bpSlot.slot_type == incomingBpSlot.slot_type and self.bpSlot.slot_type == 1:
		var tempBluePrint : BluePrint = self.bpSlot.containingBlueprint
		var temppreviewPawn = self.bpSlot.previewPawn.texture
		var tempIsHidden = self.bpSlot.isHidden
		self.applyValuesFromOtherBpSlot(incomingBpSlot)
		incomingBpSlot.containingBlueprint = tempBluePrint
		incomingBpSlot.previewPawn.texture = temppreviewPawn
		incomingBpSlot._hide(tempIsHidden)
	elif self.bpSlot.slot_type == 1: # from inventory -> change isLoadout on incomingBpSlot
		if incomingBpSlot.isHidden:
			return
		if self.bpSlot.containingBlueprint != null:
			var tempBpId = self.get_id()
			incomingBpSlot.get_parent().emit_signal("loadoutChanged", false, tempBpId)
		self.applyValuesFromOtherBpSlot(incomingBpSlot)
		self._set_loadout(true)
		self.bpSlot._hide(false)
		print("emitting loadout Changed")
		incomingBpSlot.get_parent().emit_signal("loadoutChanged", true, self.bpSlot._getId())
		pass
	elif self.bpSlot.slot_type == 0 and self.is_id(incomingBpSlot._getId()): # self is inventory -> 
		# 2. wenn selber inventory und data id == self id -> setze selbst visible true und setze incoming data zurück + hide
		self.bpSlot._hide(false)
		incomingBpSlot._empty_the_slot()
		
func applyValuesFromOtherBpSlot(slot: BlueprintSlot):
	self.bpSlot.containingBlueprint = slot.containingBlueprint
	self.bpSlot.previewPawn.texture = slot.previewPawn.texture
	self.bpSlot._hide(slot.isHidden)

func _get_drag_data(at_position):
	if self.bpSlot.is_game_started:
		return
	if self.bpSlot.slot_type == 0 and self.bpSlot.is_locked:
		return
	set_drag_preview(get_drag_preview(at_position))
	return self.bpSlot
	
func get_drag_preview(_at_position) -> Control:
	if self.bpSlot.slot_type == 0 and self.bpSlot._is_hidden():
		return null
	var previewTexture = TextureRect.new()
	previewTexture.texture = self.bpSlot.previewPawn.texture
	previewTexture.expand_mode  = 1
	var minSize = 32
	previewTexture.size = Vector2(minSize, minSize)
	var preview = Control.new()
	preview.add_child(previewTexture)
	return preview
	
func _set_blueprint(blueprint: BluePrint): # on init via InventoryManager
	self.bpSlot.set_blueprint(blueprint)

func _unlock():
	self.bpSlot._unlock()
	
func is_id(id : int) -> bool:
	if self.bpSlot == null or self.bpSlot.containingBlueprint == null:
		return false
	return self.bpSlot.containingBlueprint.id == id
	
func get_id() -> int:
	return self.bpSlot.containingBlueprint.id

func _set_loadout(loadout: bool) :
	self.isLoadout = loadout

func _set_slotType(type: int) : 
	self.bpSlot.slot_type = type
	if type == 1:
		self.bpSlot._unlock()

func is_validDrop(otherBpSlot: BlueprintSlot) -> bool:
	return self.bpSlot.slot_type == 1 or self.is_id(otherBpSlot._getId()) # bp either Loadout or LoadoutBP Id == Inventory BP Id

func _empty_the_slot():
	self.bpSlot._empty_the_slot()
	
func _gui_input(event):
	if !self.bpSlot.is_game_started and event.is_action_pressed("action_right_click"):
		notify_loadout_empty()
		self._empty_the_slot()
	if !event.is_action_pressed("action_left_click"):
		return
	if self.selected != true:
		return
	if self.bpSlot.slot_type != 1 :
		return
	if self.bpSlot.containingBlueprint == null:
		return
	if self.bpSlot.is_game_started and self.bpSlot.containingBlueprint._is_timer_up():
		var preview = self.previewPawn.instantiate() as PreviewPawn
		preview._my_init(self.manager, self.bpSlot.containingBlueprint)
		self.manager.add_child(preview)
		return	

func notify_loadout_empty(): # only called by bp container in loadout
	var par = self.get_parent()
	if par == null:
		return
	if par.has_method("_notify_loadout_empty"):
		par._notify_loadout_empty(self.bpSlot._getId())

func _set_game_start():
	self.bpSlot.is_game_started = true
	
func _on_mouse_entered():
	self.selected = true

func _on_mouse_exited():
	self.selected = false
