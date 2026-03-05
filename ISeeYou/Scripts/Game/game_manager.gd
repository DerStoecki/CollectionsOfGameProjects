extends Node
class_name GameManager

var game_state: GameStateResource

#var game_state_path : String = "res://GameState/game_state.json"
#var healing_path : String = "res://GameState/health.json"
var game_state_path : String = "user://Game_State.json"
var healing_path : String = "user://Health.json"
@export var game_seed : String = "ISeeYou"
@onready var totemPickupSFXplayer: AudioStreamPlayer2D = $TotemPickupSFXPlayer
@onready var totemParticleParent : Node2D = $"../Player/TotemParticelParent"
@onready var randomRoomGen: RandomRoomIdToTotemGenerator = $RandomRoomIdToTotemGenerator

var rng : RandomNumberGenerator
## SFX that are usually triggered by entering of player and are only triggered once


signal game_resource_loaded()
signal rite_start_timer(timer: Timer)

func _ready():
	rng = RandomNumberGenerator.new()
	if not FileAccess.file_exists(game_state_path): ##shouldn't happen with exists but just to make sure
		self.generate_seed()
		self.create_new_game()
	elif FileAccess.file_exists(game_state_path):
		var file = FileAccess.open(self.game_state_path, FileAccess.READ)
		self.game_state = GameStateResource.new().fromSaveFile(file)
		self.game_seed = self.game_state.random_seed
		print("loaded totem dictionary:")
		print(str(self.game_state.totem_placement_dictionary))
		self.game_resource_loaded.emit()
		call_deferred("_check_for_active_enemies")
		
func generate_seed():
	self.game_seed = str(rng.randi_range(1000, 100000))
	pass
	
func set_seed(customSeed: String):
	self.game_seed = customSeed

## May be called when creating new game either via code or when new Game button in menu is clicked
## Also when hitting new Game Button hit set_seed in before!
func create_new_game():
	createNewPlayerHealth()
	game_state = GameStateResource.new()
	game_state.random_seed = self.game_seed
	game_state.posessedEnemyId = -1
	setup_rng()
	self.game_resource_loaded.emit()
	

func hasLocalSFXplayed(id: int) -> bool:
	return self.game_state.alreadyPlayedSFX.has(id)
	
func localSFXplayed(id: int):
	if self.game_state.alreadyPlayedSFX.has(id):
		return
	self.game_state.alreadyPlayedSFX.append(id)
	self.save_state()
	
func set_enemy_posessed(id: int):
	self.game_state.posessedEnemyId = id
	self.save_state()

func _free_enemy_posession():
		# Not happening here but only on totem pickup AND if totem count is ok -> same logic -> can be moved
#	for node in self.get_tree().get_nodes_in_group("Enemy"):
#		var enabler : EnemyEnabler  = node.get_node("EnemyEnabler") as EnemyEnabler
#		if enabler.EnemyID == self.game_state.posessedEnemyId:
#			enabler._set_active()
#	for enabler in self.get_tree().get_nodes_in_group("EnemyEnabler") as Array[EnemyEnabler]:
#		if enabler.EnemyID == self.game_state.posessedEnemyId:
#			enabler._set_active()
	self.game_state.posessedEnemyId = -1
	
func totem_pickup(totem: Totem):
	#var totemPos = totem.position
	if not self.game_state.collected_totems.has(totem.ID):
		self.totemPickupSFXplayer.play(0)
		#self.totemParticleParent.position = totemPos
		(self.totemParticleParent.get_node("TotemParticles") as CPUParticles2D).set_emitting(true)
		self.game_state.collected_totems.append(totem.ID)
		self._free_enemy_posession()
		self.save_state()
		_check_for_active_enemies()
	
func _check_for_active_enemies():
	for enabler in self.get_tree().get_nodes_in_group("EnemyEnabler") as Array[EnemyEnabler]:
		if enabler.activeAtTotemCount <= self.game_state.collected_totems.size():
			enabler._set_active()
			
func setup_rng():
	if randomRoomGen:
		randomRoomGen.setSeed(self.game_seed)
		if not randomRoomGen.generated_done.is_connected(_on_rng_generated_done):
			randomRoomGen.generated_done.connect(_on_rng_generated_done)
			randomRoomGen.generateRoomToIds()
		
func _on_rng_generated_done(dictionary: Dictionary[int, int]):
	self.game_state.totem_placement_dictionary = dictionary
	self.save_state()
	print(self.game_state.totem_placement_dictionary)


func _on_root_child_entered_tree(node: Node) -> void:
	if node is Totem:
		call_deferred("addTotemPickUpListener", node)
	elif node.is_in_group("Enemy"):
		call_deferred("_check_for_active_enemies")

func addTotemPickUpListener(totem: Totem):
	if not totem.pickUpArea.interact.is_connected(totem_pickup):
		totem.pickUpArea.interact.connect(totem_pickup)
	
func createNewPlayerHealth():
	var health: Health = Health.new()
	health.state = Health.HealthState.HEALTHY
	var fileExists = FileAccess.file_exists(healing_path)
	if fileExists:
		var file : FileAccess = FileAccess.open(healing_path, FileAccess.WRITE_READ)
		file.store_string(health.createSave())
	
func save_state():
	var file : FileAccess = FileAccess.open(game_state_path, FileAccess.WRITE_READ)
	var json : String = self.game_state.createSaveFile()
	file.store_string(json)
	
	
func totemPlaced(id: int) -> void:
	self.game_state.collected_totems.erase(id)
	
func hasTotem(id: int) -> bool:
	return self.game_state.collected_totems.has(id)
	
func _on_ritual_started(ritual: Ritual):
	rite_start_timer.emit(ritual.timer)
func _on_ritual_ended():
	pass

## When an interact area was entered -> a spawnpoint sets its id
func set_exit_id(id: int, next_spawn_point: int):
	self.game_state.current_exit_id = id
	self.game_state.spawn_id = next_spawn_point
	save_state()

func get_current_spawn_id() -> int:
	return self.game_state.spawn_id
	
func has_totem_in_room(roomId: int) -> bool:
	var dic = self.game_state.totem_placement_dictionary
	if dic.has(roomId):
		var totemId = dic[roomId]
		return not hasTotem(totemId)
	return false
