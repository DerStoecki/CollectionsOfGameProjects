extends Node2D
class_name WarningSpawner

@onready var spawner: CollectibleSpawner = $"../CollectibleSpawner"
@export var exclamation: PackedScene = preload("res://Scenes/ExclamationMark.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawner.poison_spawned.connect(Callable(self, "_on_poison_spawned"))
	spawner.tuna_spawned.connect(Callable(self, "_on_tuna_spawned"))

func _on_poison_spawned(poison : CollectibleParent):
	var exclaInstance = exclamation.instantiate()
	exclaInstance.set_modulate(Color(1,0,0))
	self.setAndAddExcla(exclaInstance, poison)
	pass
	
func _on_tuna_spawned(tuna: CollectibleParent):
	var exclaInstance = exclamation.instantiate()
	exclaInstance.set_modulate(Color(1,1,0))
	self.setAndAddExcla(exclaInstance, tuna)

func setAndAddExcla(instance: Exclamation, collectible : CollectibleParent) -> void :
	instance.position = Vector2(collectible.position.x, 0)
	self.add_child(instance)
