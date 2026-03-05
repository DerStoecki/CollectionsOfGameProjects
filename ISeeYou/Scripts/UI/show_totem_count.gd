extends Label
class_name MinTotemLabel

@onready var gm: GameManager = $"../../../GameManager"
@export_range(0, 10) var minTotemCount : int

func _ready() -> void:
	self.text = self._totem_text()

func _on_interact_area_body_entered(_body: Node2D) -> void:
	var count = self.gm.game_state.collected_totems.size()
	print(str("count: %s minCount: %s" %[count, minTotemCount]))
	if count < self.minTotemCount:
		self.visible = true

func _totem_text() -> String :
	var collectedTotems = self.gm.game_state.collected_totems.size()
	var txt =  str(collectedTotems, " / ", self.minTotemCount)
	return txt

func _on_interact_area_body_exited(_body: Node2D) -> void:
	self.visible = false
	pass # Replace with function body.
