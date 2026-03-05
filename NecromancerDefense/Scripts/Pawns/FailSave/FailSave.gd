extends Area2D
class_name PanCake

@export var damage = 200
@export var speed = 10

var idle: bool = true

var pawnsToDamage : Array[Pawn] = []
signal startPancaking

func _ready():
	self.area_entered.connect(Callable(self, "_on_area_entered"))
		
	
func move():
	self.position.x += speed	


func _on_area_entered(area):
	if area is PawnArea:
		pawnsToDamage.append(area.get_parent() as Pawn)
		if idle:
			self.idle = false
			startPancaking.emit()

func flattenThem():
	for pawn in pawnsToDamage:
		pawn.receive_damage(self.damage)
	pawnsToDamage.clear()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
