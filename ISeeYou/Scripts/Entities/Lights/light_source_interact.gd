extends PointLight2D
class_name InteractLightSource

@onready var baseScale :float = self.texture_scale
@export var variationAmount : float  = 0.1
@export var variationSpeed : float = 1.5


func _process(_delta: float) -> void:
	self.texture_scale = baseScale + variationAmount * sin(Time.get_ticks_msec() / 1000.0 * variationSpeed)


func _on_interact_area_interacted() -> void:
	self.enabled = true
