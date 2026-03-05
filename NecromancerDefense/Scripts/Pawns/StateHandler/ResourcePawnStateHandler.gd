extends StateHandler
class_name ResourcePawnStateHandler


@export var animationTree: ResourcePawnAnimationTree
var castedParentPawn : ResourceSpawnPawn

func my_initialize(parent: ResourceSpawnPawn):
	self.parentPawn = parent
	self.castedParentPawn = self.parentPawn
	self.animationTree.animation_finished.connect(Callable(self, "_on_animationPlayerFinished"))
	pass
	
func _detect_next_state():
	if self.parentPawn.health <= 0:
		self.animationTree.setDead()
		self.parentPawn.set_state(Pawn.State.DYING)
		return
	if self.castedParentPawn.canCreateResource:
		self.parentPawn.set_state(Pawn.State.ATTACKING)
		self.animationTree.setSpawn()
		return
	self.animationTree.setIdle()
	self.parentPawn.set_state(Pawn.State.IDLE)
	
func death():
	_detect_next_state()

func _on_animationPlayerFinished(animName: String):
	if animName.to_lower().contains("death"):
		return # no further handling needed
	self._detect_next_state()
