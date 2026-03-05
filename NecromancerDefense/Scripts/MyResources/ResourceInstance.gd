extends Area2D

class_name PawnResourceInstance

@export var value: int = 1
@export var type: PawnResource.Res = PawnResource.Res.BONES # Bone
@export var animTree: AnimationTree
@export var resManager : ResourceManager
@export var despawn: float = 30

var selected: bool

func _my_init(mgr: ResourceManager):
	self.resManager = mgr

func _ready():
	self.animTree = $Tree
	var timer = Timer.new()
	timer.wait_time = self.despawn
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	self.add_child(timer)
	timer.start()

func _on_timer_timeout():
	self.queue_free()

func _on_mouse_entered():
	print("selected")
	self.selected = true

func _on_mouse_exited():
	print("unselected")
	self.selected = false

func _input(event: InputEvent):
	if event.is_action_pressed("action_left_click") and self.selected:
		print("actionPressed")
		self.animTree.set("parameters/conditions/collect", true)
		var viewport: Viewport = self.get_viewport()
		if viewport:
			viewport.set_input_as_handled()

func collected():
	if self.resManager:
		self.resManager.add_resource(self.type, self.value)
		
func set_resource_value(am: int):
	self.value = am
	
func increase_value(am: int):
	var temp = self.value + am
	self.value = max(0, temp)
