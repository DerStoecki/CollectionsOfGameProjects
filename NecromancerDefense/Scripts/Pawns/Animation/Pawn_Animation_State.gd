class_name PAWN_ANIMATION

enum STATE {
	NOTHING, #0
	IDLE, #1
	IDLE_2, #2
	IDLE_3, #3
	MOVING, #4
	ATTACKING, #5
	DETECTING, #6
	DYING, #7
	DAMAGE_TAKEN #8
}

static func int_to_enum(value: int) -> STATE:
	match value:
		0: return STATE.NOTHING
		1: return STATE.IDLE
		2: return STATE.IDLE_2
		3: return STATE.IDLE_3
		4: return STATE.MOVING
		5: return STATE.ATTACKING
		6: return STATE.DETECTING
		7: return STATE.DYING
		8: return STATE.DAMAGE_TAKEN
		_: return STATE.NOTHING # Default case, handle invalid values
