extends PawnAnimation
class_name PawnSlimeAnimation

var idleStateMachine : AnimationNodeStateMachinePlayback = get("parameters/StateMachine/playback")

func _ready():
	super._ready()
	self.set_Animation_state(self.state)
	
func set_Animation_state(_next_state: PAWN_ANIMATION.STATE) -> void :
	match (_next_state):
		PAWN_ANIMATION.STATE.IDLE:
			self._set_idle_params(1, true)
			self._set_idle_params(2, false)
			self._set_idle_params(3, false)
		PAWN_ANIMATION.STATE.IDLE_2:
			self._set_idle_params(2, true)
			self._set_idle_params(1, false)
			self._set_idle_params(3, false)
		PAWN_ANIMATION.STATE.IDLE_3:
			self._set_idle_params(3, true)
			self._set_idle_params(1, false)
			self._set_idle_params(2, false)
		PAWN_ANIMATION.STATE.DAMAGE_TAKEN:
			self.set_damaged(true)
		PAWN_ANIMATION.STATE.DYING:
			self._set_death()
			
	if _isNextIdleState(_next_state):
		if finished:
			var idleString = str("Idle_", self.state)
			self.idleStateMachine.start(idleString) # should return an int 1,2,3
			self.state = _next_state
		return
	self.state = _next_state
	self.state_machine.next()
	pass # Replace with function body.

func _isNextIdleState(_next_state : PAWN_ANIMATION.STATE):
	return _next_state > 0 && _next_state < 4

func _set_death():
	self.set("parameters/conditions/death", true)

func set_damaged(onOff: bool):
	self.set("parameters/conditions/damaged", onOff)	

func _set_idle_params(idleType: int, onOff: bool):
	var setString = str("parameters/StateMachine/conditions/idle", idleType)
	self.set(setString, onOff)
	
func _on_animation_finished(_anim_name: String):
	if _anim_name.to_lower().contains("damage"):
		set_damaged(false)
	super._on_animation_finished(_anim_name)
