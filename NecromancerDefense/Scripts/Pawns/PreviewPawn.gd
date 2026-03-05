extends Sprite2D
class_name PreviewPawn

## The PreviewPawn is used to show a PREVIEW of the Pawn that is being build.
## E.g when clicking in your current loadout -> there is a "pawn" that needs to be created
### however the Pawn itself has too much logic, therefor create a preview that has everything
## handling if it is possible to build this on the hovered placement etc.
## also could handle compatible pawns -> e.g. stage 1,2,3 pawns (upgrades)

var blueprint: BluePrint
var current_cell_pos : Vector2i  = Vector2i.MAX
var gridManager: GridManager
@export var tint_color : Color = Color(0.8, 0, 0, 0.5)
var await_free: bool = false

func _my_init(manager: GridManager, blueprint_instance: BluePrint):
	self.gridManager = manager
	self.blueprint = blueprint_instance
	self.texture = self.blueprint.previewPawnTexture
	self.scale = Vector2(16,16) / texture.get_size()
	self.position = self.gridManager.get_camera().get_global_mouse_position()
	pass
	
	
func _process(_delta):
	var mouse_pos = self.gridManager.get_camera().get_global_mouse_position()
	var snapped_position = mouse_pos
	self.current_cell_pos = self.gridManager.local_to_map(snapped_position) as Vector2i
	var canSpawnPawn: bool = self.can_instantiate_pawn()
	if canSpawnPawn:
		snapped_position = self.gridManager.map_to_local(self.current_cell_pos)
	self.position = snapped_position
	self.handleSpriteTint(canSpawnPawn)
	
	
func handleSpriteTint(canSpawnPawn: bool) -> void:
	var color: Color = Color(1,1,1,1)
	if not canSpawnPawn:
		color = self.tint_color
	set_self_modulate(color)
	
func _input(event):
	if await_free:
		return
	if event is InputEventMouseButton:
		var ev = event as InputEventMouseButton
		if ev.is_action_released("action_left_click"): # TODO REFACTOR
			if can_instantiate_pawn():
				var pawn = self.blueprint.pawn_scene.instantiate() as Pawn
				pawn.position = self.position
				pawn.id = self.blueprint.id
				pawn.groups.append(0)
				pawn._myInitialize(self.gridManager)
				self.gridManager.register_pawn(pawn, current_cell_pos)
				self.gridManager.add_child(pawn)
				self.gridManager.subtract_resources(self.blueprint.resource_cost, self.blueprint.resourceType)
			else: 
				print("Cannot instantiate Pawn since Invalid Cell Position")
			await_free = true
			self.queue_free()	

func can_instantiate_pawn() -> bool:
	return self.gridManager.is_within_bounds(self.current_cell_pos, true) \
	and self.space_not_occupied() \
	and self.enoughResources(self.blueprint)
	
func enoughResources(bp: BluePrint) -> bool:
	var resEnough =  self.gridManager.has_resources(bp.resource_cost, bp.resourceType)
	if not resEnough:
		print("Not enough Resources!")
	return resEnough
	
func space_not_occupied() -> bool:
	var isCompatible = true
	var pawnsInCell = self.gridManager.get_pawns_in_cell(self.current_cell_pos)
	if pawnsInCell.size() > 0:
		pawnsInCell = pawnsInCell.filter(func(pawn: Pawn): return pawn.groups.has(0))
	if pawnsInCell.size() > 0:
		var compList = CompatibleBlueprints.compatibilityList
		isCompatible = compList.has(self.blueprint.id) \
			and (compList[self.blueprint.id] as Array[int]).has(pawnsInCell[0].id)
	if !isCompatible:
		print("Space already occupied!")
	return isCompatible
