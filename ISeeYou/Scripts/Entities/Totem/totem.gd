extends Node2D
class_name Totem

@onready var texture: Sprite2D = $TotemArea/TotemTexture
@onready var pickUpArea: PickUpArea = $PickUpArea
@export var ID: int = 1

func _ready():
	self.updateTexture()
	
func updateTexture():
	self.texture.texture = load("res://Assets/Images/Totems/Totem_%s.png" % ID)
