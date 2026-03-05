class_name ResourceCreator extends Node3D


@export var RESOURCE_TYPE := GameResource.MyResource.WOOD

@export var farm_time_seconds : int = 5

@export var farm_flat_value : int = 10

@export var farm_multiplier : float = 1.3

@export var max_slot_spaces : int = 3 # TODO make them objects "Grids" and each grid can hav an object

@export var min_farm_time : float = 0.2

@export var max_farm_multiplier : float = 10

@export var max_farm_flat_value: float = 150

@onready var current_farm_time : float
@onready var current_farm_value : float
@onready var current_farm_multiplier : float

@onready var available_slot_spaces : int = max_slot_spaces


var timer : Timer

var value_on_timeout : float = 1

var value_per_second : float = 0

var resourceEnhancer : Array[ResourceEnhancer] = []

signal harvest_time(node: ResourceCreator)

# Called when the node enters the scene tree for the first time.
func _ready():
	print("ready call")
	_setup_timer()
	update_values()
	
func _on_Harvest_Time():
	emit_signal("harvest_time", self)
	#print(str("HarvestTime: ", value_on_timeout ))
	
func add_resource_enhancer(enhancer: ResourceEnhancer) -> void:
	print("Adding Resource Enhancer")
	#add_child(enhancer)
	self.resourceEnhancer.append(enhancer)
	var callable = Callable(self, "update_values")
	enhancer.connect("update", callable)
	#print("calling update values after resource enhancement")
	self.update_values()
	
func update_values():
	#print("Updating Values")
	reset_farm_values()
	var temp_bonus_farm_multiplier_flat : float = 0
	var temp_bonus_farm_multiplier_percentage: int = 0
	
	var temp_bonus_farm_value_flat : float = 0
	var temp_bonus_farm_value_percentage: int = 0
	
	var temp_bonus_farm_time_flat : float = 0 # Will alway be positive and then subtracted
	var temp_bonus_farm_time_percentage : int = 0 # Will alway be positive and then subtracted
	for enhancer in resourceEnhancer:
		enhancer._to_string()
		temp_bonus_farm_multiplier_flat += enhancer.current_multiplier_increase_flat 
		temp_bonus_farm_multiplier_percentage += enhancer.current_multiplier_increase_percentage 
		temp_bonus_farm_time_flat += enhancer.current_speed_increase_flat
		temp_bonus_farm_time_percentage += enhancer.current_speed_increase_percentage
		temp_bonus_farm_value_flat += enhancer.current_value_increase_flat 
		temp_bonus_farm_value_percentage += enhancer.current_value_increase_percentage
		
	self.current_farm_multiplier = _calculate_bonus(self.current_farm_multiplier, 
	temp_bonus_farm_multiplier_flat, 
	temp_bonus_farm_multiplier_percentage)
	self.current_farm_value = _calculate_bonus(self.current_farm_value, 
	temp_bonus_farm_value_flat, 
	temp_bonus_farm_value_percentage)
	self.current_farm_time = _calculate_bonus_time(self.current_farm_time, 
	temp_bonus_farm_time_flat, 
	temp_bonus_farm_time_percentage)
	self.value_on_timeout = min(self.max_farm_flat_value, max(self.current_farm_value * self.current_farm_multiplier, 0))
	self.timer.set_wait_time(max(self.min_farm_time, self.current_farm_time))
	self.value_per_second = roundf((self.value_on_timeout / self.timer.wait_time) * 100) / 100
	
	
func reset_farm_values():
	current_farm_multiplier = farm_multiplier
	current_farm_time = farm_time_seconds
	current_farm_value = farm_flat_value
	
func _calculate_bonus(current_value : float, flat_bonus : float, percentage_bonus : float) -> float : 
	var temp_value : float = current_value + flat_bonus
	var temp_percentaged_value = round(temp_value * percentage_bonus * 100) / 10_000 
	return temp_value + temp_percentaged_value

func _calculate_bonus_time(current_value : float, flat_bonus : float, percentage_bonus : float) -> float : 
	var temp_value : float = current_value - flat_bonus
	var temp_percentaged_value = round(flat_bonus * percentage_bonus * 100) / 10_000 
	return temp_value - temp_percentaged_value

func _setup_timer():
	#print("Setting up timer")
	self.timer = Timer.new()
	self.timer.set_wait_time(farm_time_seconds)
	self.timer.autostart = true
	add_child(timer)
	var callable = Callable(self, "_on_Harvest_Time")
	self.timer.connect("timeout", callable)
