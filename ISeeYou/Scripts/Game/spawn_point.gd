extends Node2D
class_name SpawnPoint
@export_range(-1, 1000) var id : int = 0
@export_range(-1, 1000) var connectedToSpawnPointId: int = 0

@onready var gm: GameManager = $"../../../GameManager"
@onready var player: Player = $"../../../Player"
@export var interactArea: InteractArea
@export var nextScenePath: String = "res://Test_Scene_Exit_and_Enter.tscn"
@onready var scenechanger: SceneChanger = $"../../../SceneChanger"

func _ready():
	interactArea.body_entered.connect(_on_player_entered)
	interactArea.interacted.connect(_on_interacted)
	if self.gm.get_current_spawn_id() == self.id:
		player.global_position = self.global_position
		
func _on_player_entered(_body):
	self.gm.set_exit_id(self.id, connectedToSpawnPointId)

func _on_interacted():
	self.scenechanger.change_to_next_scene(self.nextScenePath)
