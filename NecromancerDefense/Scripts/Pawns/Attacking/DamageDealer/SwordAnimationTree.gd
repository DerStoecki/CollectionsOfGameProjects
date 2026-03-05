class_name Sword_Animation_Tree
extends PawnAnimation

@export var next_sword_state : SWORD_STATE.STATE = SWORD_STATE.STATE.WAIT
var curSwordState: SWORD_STATE.STATE = SWORD_STATE.STATE.WAIT


func set_Animation_state(_next_state: PAWN_ANIMATION.STATE) -> void :
	if _next_state == PAWN_ANIMATION.STATE.ATTACKING:
		self.setNextSwordState()
	super.set_Animation_state(_next_state)


func setNextSwordState():
	var states = SWORD_STATE.STATE
	var state_value = states.values().find(self.current_state)
	if state_value == -1:
		curSwordState = SWORD_STATE.STATE.WAIT
		return
	state_value += 1
	if state_value >= states.size() - 1:
		self.curSwordState = self.SWORD_STATE.STATE.SWING_UP
		print(str("CurrentSwordState: ", self.curSwordState))
		return
	for key in states.keys():
		if states[key] == state_value:
			self.curSwordState = states[key]
			break
	print(str("CurrentSwordState: ", self.curSwordState))
	
