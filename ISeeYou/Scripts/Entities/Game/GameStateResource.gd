extends Resource
class_name GameStateResource

@export var random_seed: String  = "ISeeYou"
@export var totem_placement_dictionary : Dictionary[int, int] = {}
@export var alreadyPlayedSFX: Array[int] = []
@export var posessedEnemyId: int = -1
@export var collected_totems : Array[int] = []
##Currently set exit ID
@export var current_exit_id = 0
@export var spawn_id = 0


func createSaveFile() -> String:
	var dictionary  = {}
	dictionary["seed"] = random_seed
	dictionary["totem_placement"] = totem_placement_dictionary
	dictionary["playedSFX"] = alreadyPlayedSFX
	dictionary["enemy"] = posessedEnemyId
	dictionary["totems"] = collected_totems
	dictionary["exit"] = current_exit_id
	dictionary["spawn"] = spawn_id
	return JSON.stringify(dictionary)

func fromSaveFile(file : FileAccess) -> GameStateResource :
	var txt = file.get_as_text()
	var json = JSON.parse_string(txt)
	if json == null:
		return GameStateResource.new()
	var data : Dictionary = JSON.parse_string(file.get_as_text())
	self.random_seed = data["seed"]
	str_to_int_Totem(data["totem_placement"])
	data_to_already_played_sfx(data["playedSFX"])
	self.posessedEnemyId = data["enemy"] as int
	totems_conversion(data["totems"])
	self.current_exit_id = data["exit"] as int
	self.spawn_id = data["spawn"] as int
	return self
	
func str_to_int_Totem(dic: Dictionary):
	for entry in dic:
		self.totem_placement_dictionary[int(entry)] = int(dic[entry])
		
func data_to_already_played_sfx(arr: Array) :
	for entry in arr:
		self.alreadyPlayedSFX.append(int(entry))
func totems_conversion(arr: Array) :
	for e in arr:
		self.collected_totems.append(int(e))
