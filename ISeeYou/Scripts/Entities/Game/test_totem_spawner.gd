extends Node2D
class_name TestTotemSpawner

## To be able to use "seeds" effectively, each TotemSpawner should have a RngState to set before determening the random position of the Totem Spawn
@export var watchGm: bool = false
@export var totemScene: PackedScene = preload("res://Scenes/Entities/Totem.tscn")

@onready var gm: GameManager = $"../GameManager"
@onready var totemctrl: TotemControl = $"../PlayerUI/TotemsControl"
@export var generated_done: bool = false

@export_range(1,10) var totemNo : int = 5

func _ready() -> void:
	call_deferred("createaAndSetTotem")
		
func createaAndSetTotem():
	if watchGm:
		if self.gm.hasTotem(self.totemNo):
			return
	var totem: Totem = self.totemScene.instantiate()
	totem.ID = self.totemNo
	totem.global_position = self.global_position
	self.get_parent().add_child.call_deferred(totem)
	self.generated_done = true
	self.gm.call_deferred("addTotemPickUpListener", totem)
	self.totemctrl.call_deferred("addTotemListener", totem)
