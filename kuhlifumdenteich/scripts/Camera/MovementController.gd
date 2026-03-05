class_name CameraMoveSubController extends Node3D

var controlledNode : Node3D
var controlledCam : Camera3D

@export var cameraPath : NodePath

@export var minZoom = 0.1
@export var maxZoom = 20.0


@export var moveSpeed : float = 5.0
@export var zoomSpeed : float = 100.0

var move : bool

var zoomIn : bool
var zoomOut: bool

var zoomTimer : Timer


func _ready():
	self.controlledNode = get_parent_node_3d()
	self.controlledCam = get_node(cameraPath) as Camera3D
	self.zoomTimer = Timer.new()
	add_child(self.zoomTimer)
	var callable = Callable(self, "_reset_zoom")
	self.zoomTimer.connect("timeout", callable)
	self.zoomTimer.autostart = false

func _input(event):
	if event is InputEvent:
		var inputEvent = event as InputEvent
		if inputEvent.is_action("CameraMovementStart"):
			if inputEvent.is_pressed():
				move = true
				print("moving active")
			else:
				move = false
				print("moving inactive")

func _process(delta):
	var curCamSize = self.controlledCam.size
	if Input.is_action_just_released("CameraZoomIn"):
		zoomIn = true
		zoomOut = false
		self.zoomTimer.start()
		curCamSize -= delta * zoomSpeed
		if curCamSize < minZoom:
			curCamSize = minZoom
	if Input.is_action_just_released("CameraZoomOut"):
		zoomOut = true
		zoomIn = false
		self.zoomTimer.start()
		curCamSize += delta * zoomSpeed
		if curCamSize > maxZoom:
			curCamSize = maxZoom
	if self.move:
		self._handle_camera_movement(delta)
	self.controlledCam.size  = curCamSize
		


func _reset_zoom():
	self.zoomIn = false
	self.zoomOut = false
	
func _handle_camera_movement(delta: float):
	var input_dir = Input.get_vector("Left", "Right", "Up", "Down")
	var velocity = Vector3(0,0,0)
	velocity += input_dir.x * self.controlledNode.transform.basis.x
	velocity += -input_dir.y * self.controlledNode.transform.basis.y
	self.controlledNode.transform.origin += velocity * delta * self.moveSpeed
