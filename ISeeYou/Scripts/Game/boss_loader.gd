extends Node
class_name BossLoader

@onready var bansheeScene : PackedScene = preload("res://Scenes/Entities/Enemy/banshee_boss.tscn")
@onready var zoomOutAnimPlayer: Boss_ZoomPlayerCamOut = $ZoomOutAnimPlayer
@export var player : Player
@export var bossGhosts: Array[BossGhost]
@onready var spriteAnimPlayer : AnimationPlayer = $Spawn_And_Death_Banshee
@onready var animSprites : AnimatedSprite2D  = $Spawn_And_Death_Banshee/Banshee_Sprite_Frames
var banshee_instance : Banshee

func _ready():
	for ghost in bossGhosts:
		ghost.visible = false

func _on_ritual_ritual_started(_ritual: Ritual) -> void:
	# todo spawn animatedSpriteFrames on RitualSite
	self.get_tree().paused = true
	self.spriteAnimPlayer.play("Spawn")
	pass

func _on_spawn_finished() -> void:
	self.get_tree().paused = false
	var banshee : Banshee = bansheeScene.instantiate()
	banshee.player = self.player
	var index = 0
	self.player.add_child(banshee)
	self.banshee_instance = self.player.get_child(self.player.get_child_count(false) - 1)
	var rdy = banshee_instance.ready
	if not banshee_instance.is_node_ready():
		await rdy
	self.player.camera.zoom = Vector2(5,5)
	for enemy in banshee_instance.group.enemyPoints:
		enemy.pathEnemy = self.bossGhosts[index]
		index = index + 1 % bossGhosts.size()
	self.banshee_instance.enable()
	

func _on_ritual_ritual_ended() -> void:
	self.get_tree().paused = true
	self.banshee_instance.visible = false
	#self.animSprites.position = self.banshee_instance.global_position
	self.spriteAnimPlayer.play("End")


func _on_ritual_ritual_initiated() -> void:
	pass # Replace with function body.

func _roll_credits() -> void:
	self.get_tree().paused = false
	self.get_tree().call_deferred("change_scene_to_file","res://Scenes/End/end_credits.tscn")
