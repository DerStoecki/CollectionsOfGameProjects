extends BasicPawnStateHandler
class_name SlimeStateHandler

func my_initialize(parent: Pawn):
	parent.received_damage.connect(Callable(self, "_on_damage_received"))
	super.my_initialize(parent)
	
func _detect_next_state():
	if self.parentPawn.health <= 0:
		return
	self.setIdle()

func setIdle():
	self.parentPawn.set_state(Pawn.State.IDLE)
	var selectIdleState : Array[int] = []
	selectIdleState.assign(self.idleStateArray)
	if self.curIdleState >= 0:
		selectIdleState.erase(self.curIdleState)
	selectIdleState.shuffle()
	self.curIdleState = selectIdleState[0]
	self.set_Animation_state(self.curIdleState) 

func _on_damage_received(amount):
	self.animationTree.set_Animation_state(8)
	pass
	
func set_Animation_state(stateAsInt: int):
		self.animationTree.set_Animation_state(PAWN_ANIMATION.int_to_enum(stateAsInt))

func _on_animationPlayerFinished(animName: String):
	if animName.to_lower().contains("death"):
		return # no further handling needed
	self._detect_next_state()
	
func death():
	self.parentPawn.set_state(Pawn.State.DYING)
	self.set_Animation_state(7)
