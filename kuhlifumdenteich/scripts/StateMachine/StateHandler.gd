class_name StateHandler extends Resource

var parent

func _init(par):
	self.parent = par
	

func _onEntry():
	pass

func _onExit() -> bool:
	return true

func run(delta):
	print("i am in base statehandler")
	pass
	

func is_correct_handler(state) -> bool:
	return false
