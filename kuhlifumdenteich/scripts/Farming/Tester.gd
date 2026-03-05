extends Node3D

@export var creator_path : NodePath
@export var enhancer_path : NodePath

var creator: ResourceCreator
var enhancer: ResourceEnhancer

var resourceCreatorSignal : bool = false
var resourceEnhancerSignal : bool = false

var timer : Timer
# Called when the node enters the scene tree for the first time.
func _ready():
	if creator_path != null and enhancer_path != null:
		self.timer = Timer.new()
		self.timer.wait_time = 15
		self.timer.one_shot = true
		self.timer.autostart = true
		add_child(timer)
		self.creator = get_node(creator_path) as ResourceCreator
		self.enhancer = get_node(enhancer_path) as ResourceEnhancer
		var callable = Callable(self, "_connect")
		timer.connect("timeout", callable)
	
func _connect():
	print("timeout occured")
	if (resourceCreatorSignal and resourceEnhancerSignal) or ( self.creator.is_node_ready() and self.enhancer.is_node_ready()):
			creator.add_resource_enhancer(self.enhancer)

