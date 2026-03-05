extends Resource
class_name Health

@export var state: HealthState = HealthState.HEALTHY

enum HealthState{HEALTHY, POSESSED, DEAD}

signal damaged()
signal dead()
signal healed()

func damage():
	if self.state == 0:
		self.state = HealthState.POSESSED
		self.damaged.emit()
	elif self.state == 1:
		self.state = HealthState.DEAD
		self.dead.emit()
		
func heal():
	self.state = HealthState.HEALTHY
	self.healed.emit()
	
func createSave() -> String:
	var dic  = {}
	dic["health"] = self.state
	return JSON.stringify(dic)
	
func fromSave(file : FileAccess) -> Health:
	var json = JSON.parse_string(file.get_as_text())
	if json :
		json = json as Dictionary 
		self.state = json["health"]
	return self
