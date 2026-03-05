extends Sprite2D
class_name MoveBackgroundHorizontal
@export var dissapearPoint : float = -900
@export var entryPoint: float = 3750
@export var direction : Vector2i = Vector2i.LEFT
@export var speed : float = 40


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.position += delta * speed * direction
	if self.direction == Vector2i.LEFT:
		if self.dissapearPoint >= self.position.x:
			self.position.x = entryPoint
	elif self.direction == Vector2i.RIGHT:
		if self.dissapearPoint <= self.position.x:
			self.position.x = entryPoint
