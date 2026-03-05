extends Label
class_name MultiplierLabel

@onready var spawner: CollectibleSpawner = $"../../../CollectibleSpawner"

func _ready():
	spawner.multiplierChange.connect(Callable(self, "update"))
	self.update()
	
func update():
	self.text = str(self.spawner.score_multiplier, "X")
