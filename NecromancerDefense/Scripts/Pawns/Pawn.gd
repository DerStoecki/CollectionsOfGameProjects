extends Node2D
class_name Pawn

## A Pawn is the base class for Enemies or Player Units
## A Paw usually Contains a State Handler, and usually cannot move when in Attack Mode.
## When instantiated it receives a reference to the GridManager
## Additionally when a Pawn moves / changes the location
## Send a Signal that the position has changed. Usually the GridManager receives those signals to update all Positions.
## Those will be fetched later by Detectors etc.
## A Pawn is always damageable
## A Pawn usually has a 2D - Sprite, a Collision, an EnemyDetection Class
## Mover and an AttackHandler
## In the future it may have a UI control to display its current health etc


@export var health: int = 100
@export var initialState: State = State.IDLE
@export var stateHandler: StateHandler = null
@export var groups: Array[PawnGroup.Group]
@export var id : int = -1
@export var collisionAreaPath : NodePath
@export var isPlayerPawn: bool = false
@export var ableToMove: bool = false
@export var invulnerable : bool = false
var collisionArea: Area2D

var hasDetectedEnemies: bool = false
var canAttack: bool = false

enum State {IDLE, WALKING, DETECTING_ENEMY, ATTACKING, DYING}
var current_state: State = State.IDLE
var init: bool = false

signal received_damage(amount)
signal healed(amount)
signal died

var target: Node = null
var grid_manager : GridManager

func _ready() -> void:
	set_state(self.initialState)
	
func _process(_delta):
	if self.init and self.grid_manager != null:
		self.initialize_children()
		self.collisionArea = self.get_node(collisionAreaPath)
		self.set_process(false)
	
func _myInitialize(gridManager: GridManager):
	self.grid_manager = gridManager
	self.init = true

			
func initialize_children() -> void:
	for child in get_children():
		if child.has_method("my_initialize"):
			child.my_initialize(self)

func set_state(next_state: State) -> void:
		current_state = next_state

func receive_damage(amount: int) -> void:
	if not invulnerable:
		health -= amount
	emit_signal("received_damage", amount)
	if health <= 0:
		if self.stateHandler:
			self.stateHandler.death()
		else:
			self.die()
		
func apply_status(_status: State): # TODO Change state to Pawn_Condition -> charmed etc
	pass

func heal(amount: int) -> void:
	health += amount
	emit_signal("healed", amount)

func die() -> void:
	self.grid_manager.unregister_pawn_with_local_coordinates(self, self.position)
	queue_free()
	
func get_gridManager() -> GridManager:
	return self.grid_manager
	
func has_PawnGroup(group: int) -> bool:
	return self.groups.has(group)

func has_Collided() -> bool:
	if self.collisionArea :
		return self.collisionArea.monitoring and self.collisionArea.has_overlapping_areas()
	return false
	
func getLayer() -> int: # Note: Layer and Mask returned as int but are binary! 
	if self.collisionArea:
		return self.collisionArea.collision_layer
	return 0
	
func getMask() -> int:
	if self.collisionArea:
		return self.collisionArea.collision_mask;
	return 0
	
func getCurrentGridPosition() -> Vector2i:
	return self.grid_manager.local_to_map(self.position)
