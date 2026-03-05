extends Label

@export var lookUpType = PawnResource.Res.BONES
@export var resMgr : ResourceManager
var lookUpTime : float = 0.5
var curTime : float = 2
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	curTime += delta
	if curTime < lookUpTime:
		return
	curTime = 0
	self.text = str(resMgr.get_resourceAmount(lookUpType))
	pass
