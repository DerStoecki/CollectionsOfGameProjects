extends StaticBody2D

class_name Frame

@export var rotationSpeed : float = 15
@export var maxRotation : int = 50

func _ready():
	self.maxRotation = randi_range(10, 50)
	self.rotation_degrees = randi_range(-maxRotation, maxRotation)
	if self.rotation_degrees < 0:
		rotationSpeed *= -1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	self.rotation_degrees += delta * rotationSpeed
	if abs(rotation_degrees) > maxRotation:
		rotationSpeed *= -1
