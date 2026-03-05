extends CharacterBody2D
class_name Player

@export var health_res : Health 
@export var tileMap: TileMapsParent

@onready var footStepAudio: FootSteps = $FootSteps
@onready var camera :  Camera2D = $Camera2D

var FLOOR_OFFSET : Vector2 = Vector2(0, 8)
var lastFloorTileData : TileData

#var health_path : String = "res://GameState/health.json"
var health_path : String = "user://Health.json"

func _ready():
	if FileAccess.file_exists(health_path):
		var file : FileAccess = FileAccess.open(health_path, FileAccess.READ)
		self.health_res = Health.new().fromSave(file)
		connectHealthSignals()
	else:
		self.health_res = Health.new()
		save_health()
		connectHealthSignals()

func getHealth() -> Health:
	return self.health_res

func _process(_delta: float) -> void:
	if tileMap and is_on_floor():
		var floor_data = tileMap.floorLayer.get_cell_tile_data(tileMap.floorLayer.local_to_map(self.global_position + FLOOR_OFFSET))
		if floor_data and lastFloorTileData != floor_data:
			if floor_data.has_custom_data("FloorType") and floor_data.has_custom_data("isFloorTile"):
				self.lastFloorTileData = floor_data
				var isFloorTile : bool = floor_data.get_custom_data("isFloorTile")
				var floorType : int = floor_data.get_custom_data("FloorType")
				if isFloorTile:
					self.footStepAudio.set_sound(floorType)
					
func _on_healthChange():
	save_health()
	
func save_health():
	var file : FileAccess = FileAccess.open(health_path, FileAccess.WRITE_READ)
	file.store_string(self.health_res.createSave())

func connectHealthSignals():
	if not self.health_res.damaged.is_connected(_on_healthChange):
			self.health_res.damaged.connect(_on_healthChange)
			self.health_res.healed.connect(_on_healthChange)
