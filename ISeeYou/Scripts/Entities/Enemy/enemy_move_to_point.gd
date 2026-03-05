extends Node2D
class_name EnemyMoveToPoint


@export var pathEnemy: BossGhost

func activate():
	self.pathEnemy.visible = true
	self.pathEnemy.global_position = self.global_position
	self.pathEnemy.follow._enable()
