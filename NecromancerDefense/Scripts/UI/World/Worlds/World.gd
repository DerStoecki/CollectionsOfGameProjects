extends Control
class_name World

@export var selectedWorld : WorldContainer

signal worldChange

func _ready():
	hide_children()
	worldChange.emit()

func nextWorld():
	if self.selectedWorld.hasNext():
		self._hide()
		self.selectedWorld = self.selectedWorld.next
		self._changeWorld()
		
func previousWorld():
	if self.selectedWorld.hasPrevious():
		self._hide()
		self.selectedWorld = self.selectedWorld.previous
		self._changeWorld()
		
func _changeWorld():
	self.selectedWorld.visible = true
	worldChange.emit()
		
func _hide():
	self.selectedWorld.visible = false
	
func hasNext():
	if self.selectedWorld == null:
		return true
	return self.selectedWorld.hasNext()
	
func hasPrevious():
	if self.selectedWorld == null:
		return true
	return self.selectedWorld.hasPrevious()
	
func hide_children():
	var worlds : Array[WorldContainer] = []
	worlds.assign(self.get_children().filter(isContainer).filter(isNotSelected))
	for world in worlds:
		world.visible = false
	
func isContainer(node: Node) -> bool:
	return node is WorldContainer
	
func isNotSelected(container: WorldContainer):
	return container != self.selectedWorld
