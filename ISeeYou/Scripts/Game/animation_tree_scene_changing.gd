extends AnimationTree


func _ready() -> void:
	self.set("parameters/conditions/FadeOut", true)
	self.set("parameters/conditions/FadeIn", false)
