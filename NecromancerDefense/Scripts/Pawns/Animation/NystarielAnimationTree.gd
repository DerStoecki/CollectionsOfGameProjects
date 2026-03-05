extends AnimationTree
class_name PawnAnimation


@export var state : PAWN_ANIMATION.STATE = PAWN_ANIMATION.STATE.IDLE_3

var finished: bool = false
#var next_state : SWORD_STATE.STATE = SWORD_STATE.STATE.WAIT

var parent : Pawn
var state_machine : AnimationNodeStateMachinePlayback = get("parameters/playback")

func set_Animation_state(_next_state: PAWN_ANIMATION.STATE) -> void :
	if self.state == _next_state:
		if finished:
			self.state_machine.start(self.getAnimationNameFromState())
		return
	self.state = _next_state
	self.state_machine.next()
	pass # Replace with function body.
	
func _ready():
	self.active = true
	self.state = PAWN_ANIMATION.int_to_enum(randi_range(1,3))
	
func my_initialize(parentPawn: Pawn):
	self.parent = parentPawn

func getAnimationNameFromState() -> String:
	match self.state:
		PAWN_ANIMATION.STATE.IDLE_2:
			return "Idle_2"
		PAWN_ANIMATION.STATE.IDLE_3:
			return "Idle_3"
		PAWN_ANIMATION.STATE.MOVING:
			return "Move"
		PAWN_ANIMATION.STATE.ATTACKING:
			return "Attack"
		PAWN_ANIMATION.STATE.DETECTING:
			return "Detect"
		PAWN_ANIMATION.STATE.DYING:
			return "Death"
	return "Idle_1"	

func _on_animation_finished(_anim_name: String):
		self.finished = true


func _on_animation_player_changed():
	self.finished = false
