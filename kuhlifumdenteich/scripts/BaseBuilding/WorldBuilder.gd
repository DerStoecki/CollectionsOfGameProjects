class_name WorldBuilder extends GridMap

@export var grid_x_size : int = 20

@export var grid_z_size : int = 20

@export var y_pos : int = 0

var alternate: int = 0

var dic = {} :
	get:
		return dic

# 0 and 1 -> wood and fish

# Called when the node enters the scene tree for the first time.
func _ready():
	create_base_game()
	pass # Replace with function body.


func create_base_game():
	for x in grid_x_size:
		for z in grid_z_size:
			var vec3 : Vector3i = Vector3i(x, y_pos, z)
			var tile = tileSelect()
			self.dic[vec3] = {
				"occupied" : false,
				"type": tile
			}
			self._add_qualities(vec3);
			set_cell_item(vec3, tile, 0)
	#print(str(self.dic))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func tileSelect() -> int : 
	return randi_range(0,1)#
	
# TODO Depending on Type -> Set qualities
func _add_qualities(vec : Vector3i) -> void :
	if(self.dic.has(vec)):
		var entry = self.dic[vec]
		var type = entry["type"]
		for key in GameResource.MyResource.keys():
			entry[key] = _pick_quality(type)
	

func _pick_quality(type: int) -> String:
	# TODO use type(tile) to determine quality in future for now use random
	var ranInt = randi_range(0, (Quality.bpQuality.size()-1))
	var quality : String = str(Quality.bpQuality.IMPOSSIBLE);
	for qKey in Quality.bpQuality.keys():
		if Quality.bpQuality[qKey] == ranInt:
			quality = qKey
			break
	return quality
