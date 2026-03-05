extends TextureButton

class_name WorldSelector

enum Type {LEFT, RIGHT}

@export var type : Type
@export var world: World
@export var neighborButton: WorldSelector
var wasPressed: bool = false

func _ready():
	world.connect("worldChange", Callable(self, "worldChanged"))
	self.connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	if self.type == Type.RIGHT:
		self.grab_focus()

func _pressed():
	wasPressed = true
	if self.type == Type.LEFT:
		if world.selectedWorld.hasPrevious(): # usually has previous bc ohterwise hidden
			world.previousWorld()
	elif self.type == Type.RIGHT:
		if world.selectedWorld.hasNext():
			world.nextWorld()
	
func worldChanged():
	self.focus_neighbor_top = str(world.selectedWorld.get_path(), "/WorldButton")
	if world == null:
		return
	if self.type == Type.LEFT:
		self.visible = world.hasPrevious()
	elif self.type == Type.RIGHT:
		self.visible = world.hasNext()
	self.checkFocus()
	self.wasPressed = false
	
func checkFocus():
	if not self.wasPressed:
		return
	if not self.visible:
		self.get_node(focus_neighbor_top).grab_focus()
		
func _on_mouse_entered():
	self.grab_focus()
