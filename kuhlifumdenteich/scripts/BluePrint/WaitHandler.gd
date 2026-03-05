class_name WaitHandlerBP extends StateHandler

#Init == Done mesh but transparent and with new flat material
# In this state the parent is not set/build therefore check for quality on WORLD GRID!
# 1. check quality something else should set the quality so no reference to world grid needed
# 2. set color depending on quality
# 3. on exit -> transparency is back at normal again, color is default again.
# 4. parents always call when currentstate 

# TODO LATER
# for each surface Material -> save index and save option into dictionary 
#var default_transparancy : Dictionary = {}
# also save Albedo color as dictionary
#var default_color : Dictionary = {}

var colorQualityMap : Dictionary = { 
	# actually don't show IMPOSSIBLE
	"BAD" : Color(Color.RED, 0.5),
	"OK" : Color(Color.GRAY, 0.5),
	"GOOD" : Color(Color.DARK_GREEN, 0.5),
	"VERY_GOOD" : Color(Color.REBECCA_PURPLE, 0.5),
	"PERFECT": Color(Color.GOLD, 0.5)
	
	}
	
var parentMesh : MeshColorUtility


func _init(par: BluePrint):
	self.parent = par as BluePrint
	self.parentMesh = par.get_creatorMesh()
	
# Called when the node enters the scene tree for the first time.

func run(delta):
	# check current state
	# set the next state depending on what the current state is!
	# in this case only update color depending on quality / set quality!
	self._handleColor()
	pass

func _onEntry():
	self._handleColor()

func _onExit():
	# exits the system
	# exits the state on transition
	self.parentMesh.reset(false)
	pass
	

func _handleColor():
	var p = (self.parent as BluePrint)
	if self.colorQualityMap.has(p.qualityLevel):
		self.parentMesh.set_visible(true)
		self.parentMesh.setAllColorsTo(self._get_corresponding_Color(p.qualityLevel))
		p.placeable = true
		
	else :
		self.parentMesh.set_visible(false)
		p.placeable = false


func _get_next_state():
	# if placeable -> set next state to WATING else stay at init. needs to be interacted with first
	pass
	
# parent check / other utility check if next state is correct -> if not call onExit for this handler (await)
# and then set nextState to this state
# after await you can create a new Handler and call onInit

func is_correct_handler(state : BluePrintState.state) -> bool:
	
	return state == BluePrintState.state.INIT or !(self.parent as BluePrint).placeable
	
func _get_corresponding_Color(q : String) -> Color:
	var color = Color.RED
	if colorQualityMap.has(q):
		color = colorQualityMap[q]
	return color
