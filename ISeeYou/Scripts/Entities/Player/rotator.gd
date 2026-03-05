extends Marker2D
class_name Rotator

@export var sensitivity = 300


func _physics_process(_delta: float) -> void:
	var right_stick_vector = Input.get_vector("Move_Flashlight_Left", "Move_Flashlight_Right", "Move_Flashlight_Up", "Move_Flashlight_Down")
	if right_stick_vector.x != 0 && right_stick_vector.y != 0 :
		look_at(self.global_position + right_stick_vector.normalized() * sensitivity)
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		look_at(get_global_mouse_position())
