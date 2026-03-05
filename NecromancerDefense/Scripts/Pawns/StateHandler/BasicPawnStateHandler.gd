extends StateHandler

class_name BasicPawnStateHandler

@export var animationTree: PawnAnimation
var curIdleState: int = -1
var idleStateArray: Array[int] = [1,2,3] #TODO

func my_initialize(parent: Pawn):
	self.parentPawn = parent
	self.animationTree.animation_finished.connect(Callable(self, "_on_animationPlayerFinished"))
	pass
	
func _detect_next_state():
	if self.parentPawn.health <= 0:
		return
	var cur_state : Pawn.State = self.parentPawn.current_state
	match cur_state:
		Pawn.State.IDLE:
			if self.parentPawn.hasDetectedEnemies:
				if self.parentPawn.canAttack:
					self.setAttack()
					return
			self.setDetecting()
		Pawn.State.DETECTING_ENEMY:
			if self.parentPawn.hasDetectedEnemies:
				self.setAttack()
			elif self.parentPawn.ableToMove:
				self.parentPawn.set_state(Pawn.State.WALKING)
				self.set_Animation_state(4)
			else:
				self.setIdle()
		Pawn.State.ATTACKING:
			setIdle()
		Pawn.State.WALKING:
			setIdle()

func setDetecting():
	self.parentPawn.set_state(Pawn.State.DETECTING_ENEMY)
	self.set_Animation_state(6)

func setAttack():
	self.parentPawn.set_state(Pawn.State.ATTACKING)
	self.set_Animation_state(5)

func setIdle():
	self.parentPawn.set_state(Pawn.State.IDLE)
	var selectIdleState : Array[int] = []
	selectIdleState.assign(self.idleStateArray)
	if self.curIdleState >= 0:
		selectIdleState.erase(self.curIdleState)
	selectIdleState.shuffle()
	self.curIdleState = selectIdleState[0]
	self.set_Animation_state(self.curIdleState) 


func set_Animation_state(stateAsInt: int):
		self.animationTree.set_Animation_state(stateAsInt)

func _on_animationPlayerFinished(animName: String):
	if animName.to_lower().contains("death"):
		return # no further handling needed
	self._detect_next_state()
	
func death():
	self.parentPawn.set_state(Pawn.State.DYING)
	self.set_Animation_state(7)
