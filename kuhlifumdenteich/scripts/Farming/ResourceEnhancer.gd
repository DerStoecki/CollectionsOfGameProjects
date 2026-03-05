# Can have children Enhancer, enhancing this one

class_name ResourceEnhancer extends MeshInstance3D

enum Type{SPEED, VALUE, MULTIPLIER}

@export var parent_path : NodePath

@export var speed_increase_flat : float = 0

@export var speed_increase_percentage : int = 0

@export var value_increase_flat : float = 0

@export var value_increase_percentage : int = 0

@export var multiplier_increase_flat : float = 0

@export var multiplier_increase_percentage : int = 0

@export var has_parentEnhancer = false

@onready var current_speed_increase_flat : float = speed_increase_flat

@onready var current_speed_increase_percentage : int = speed_increase_percentage

@onready var current_value_increase_flat : float = value_increase_flat

@onready var current_value_increase_percentage : int = value_increase_percentage

@onready var current_multiplier_increase_flat : float = multiplier_increase_flat

@onready var current_multiplier_increase_percentage : int = multiplier_increase_percentage


var parentEnhancer : ResourceEnhancer

signal update()

# Called when the node enters the scene tree for the first time.
func _ready():
	if(has_parentEnhancer):
		if (parent_path != null) :
			self.parentEnhancer = get_node(parent_path) as ResourceEnhancer
			self.parent_resource_creator.add_resource_enhancer(self)
	emit_signal("update")
	

func add_resource_enhancer(enhancer: ResourceEnhancer):
	add_child(enhancer)
	var callable = Callable(self, "update_enhancer")
	enhancer.connect("_update", callable)


func update_value(flat: float, percentage: int, type: Type):
	# TODO DOO SOMETHING
	match type:
		Type.SPEED:
			self.current_speed_increase_flat += flat
			self.current_speed_increase_percentage += percentage
		Type.VALUE: 
			self.current_value_increase_flat += flat
			self.current_speed_increase_percentage += percentage
		Type.MULTIPLIER:
			self.current_multiplier_increase_flat += flat
			self.current_multiplier_increase_percentage += percentage	
	emit_signal("update")
	
func update_enhancer(enhancer : ResourceEnhancer):
	self.update_value(enhancer.current_speed_increase_flat, 
	enhancer.current_speed_increase_percentage, Type.SPEED)
	self.update_value(enhancer.current_value_increase_flat, 
	enhancer.current_value_increase_percentage, Type.VALUE)
	self.update_value(enhancer.current_multiplier_increase_flat, 
	enhancer.current_multiplier_increase_percentage, Type.MULTIPLIER)
	
func _to_string():
	print(str("ResourceEnhancerValues: ", 
	"\nSpeed Flat Bonus: ", self.current_speed_increase_flat,
	"\nSpeed Percentage Bonus: ", self.current_speed_increase_percentage,
	"\nValue Flat Bonus: ", self.current_value_increase_flat,
	"\nValue Percentage Bonus: ", self.current_value_increase_percentage,
	"\n Multiplier Flat Bonus: ", self.current_multiplier_increase_flat,
	"\n Multiplier Percentage Bonus: ", self.current_multiplier_increase_percentage
	))
