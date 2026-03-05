extends Node
class_name TotemConnectorTest

@onready var totemctrl: TotemControl = $"../CanvasLayer/TotemsControl"
@onready var gm : GameManager


func _ready() -> void:
	self.totemctrl.addTotemListener(self.totem)
