extends BaseStageOrWorldContainer
class_name WorldContainer

@export var next: WorldContainer
@export var previous: WorldContainer

func hasNext() -> bool : 
	return self.next != null
	
func hasPrevious() -> bool : 
	return self.previous != null
		
