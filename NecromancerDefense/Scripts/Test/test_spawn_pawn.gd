extends Node2D

@export var pawn: ResourceSpawnPawn


# Called when the node enters the scene tree for the first time.
func _ready():
	pawn.initialize_children()
