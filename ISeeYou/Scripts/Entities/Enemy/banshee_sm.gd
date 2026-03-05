extends AnimationTree
class_name BansheeSM

var attack_path : String = "parameters/conditions/AbleToAttack"
var attack_wind_up_path : String = "parameters/conditions/AttackWindUp"
var dead_path = "parameters/conditions/dead"

func set_prepare():
	self.set(attack_wind_up_path, true)
	pass
	
func set_attack():
	self.set(attack_path, true)
	pass
	
func set_death():
	self.set(dead_path, true)

func set_idle():
	self.set(attack_path, false)
	self.set(attack_wind_up_path, false)
	pass
