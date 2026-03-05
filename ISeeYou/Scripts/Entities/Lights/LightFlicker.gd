extends PointLight2D

@onready var baseScale :Vector2 = self.scale
@export var variationAmount : Vector2  = Vector2(0.1,0.1)
@export var variationSpeed : float = 1.5


func _process(_delta: float) -> void:
	self.scale = baseScale + variationAmount * sin(Time.get_ticks_msec() / 1000.0 * variationSpeed)
