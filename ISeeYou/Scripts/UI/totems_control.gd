extends Control
class_name TotemControl

@onready var hbox : TotemsHBox = $TotemsHBox
@onready var gm: GameManager = $"../../GameManager"

func _ready():
	if gm:
		for totemId in self.gm.game_state.collected_totems:
			self.hbox.add_totem(load("res://Assets/Images/Totems/Totem_%s.png" % totemId))
	

func addTotemListener(totem: Totem):
	if not totem.pickUpArea.interact.is_connected(_on_totem_pickup):
		totem.pickUpArea.interact.connect(_on_totem_pickup)

func _on_totem_pickup(totem: Totem):
	self.hbox.add_totem(totem.texture.texture)
	totem.free()


func _on_root_child_entered_tree(node: Node) -> void:
	if node is Totem:
		call_deferred("addTotemListener", node)
