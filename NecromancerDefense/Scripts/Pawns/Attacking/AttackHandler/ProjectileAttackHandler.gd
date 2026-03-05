extends Attack_Handler
class_name ProjectileAttackHandler



@export var projectile_scene: PackedScene
@export var direction: Vector2 = Vector2(-1, 0)

@export var speed_bonus: float = 1
@export var damage_bonus: float = 1
@export var spawnPoint: Vector2

		
func launch_projectile():
	var projectile = projectile_scene.instantiate() as Projectile
	self.parentPawn.get_gridManager().add_child(projectile)
	projectile.global_position = self.global_position + self.spawnPoint
	projectile.set_direction(direction)
	projectile.set_detected_enemies(self.detected_enemies)
	projectile.setYGridPosition(self.parentPawn.getCurrentGridPosition().y)
	projectile.start = true
	self.parentPawn.canAttack = false
	self.timer.start(self.attack_rate)
	
