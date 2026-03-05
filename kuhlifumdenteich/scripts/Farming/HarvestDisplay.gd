class_name ResourceDisplayer extends Node3D

@onready var resource_label : Label3D = get_node("ResourceValue")

var timer : Timer
var displayTime : int = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	resource_label.hide()
	timer = Timer.new()
	add_child(timer)
	timer.autostart = false
	timer.set_wait_time(displayTime)
	var callable = Callable(self, "_on_hide_display")
	timer.connect("timeout", callable)	
	
	var callableHarvest = Callable(self, "handle_harvest")
	self.get_parent().connect("harvest_time", callableHarvest)
	
func handle_harvest(harvest: ResourceCreator) -> void :
	#print("harvest signal received")
	resource_label.text = str("+", harvest.value_on_timeout)
	resource_label.set_visible(true)
	timer.start()
	pass
	
func _on_hide_display() -> void:
	#print("on hide called")
	resource_label.hide()
	timer.stop()
