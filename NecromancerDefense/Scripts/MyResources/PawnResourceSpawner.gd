extends GlobalResourceSpawner
class_name PawnResourceSpawner

var parentPawn: ResourceSpawnPawn

func my_initialize(parent: ResourceSpawnPawn):
	self.parentPawn = parent
	self.resManager = self.parentPawn.grid_manager.resourceManager
	
func _ready():
	super._ready()
	self._timer.one_shot = true

func create():
	if self.parentPawn :
		var pos : Vector2i = self.parentPawn.position
		super.instantiateResource(pos)
		self.parentPawn.canCreateResource = false
		self._timer.start()
		
		
func _on_timer_timeout():
	if self.parentPawn:
		self.parentPawn.canCreateResource = true
