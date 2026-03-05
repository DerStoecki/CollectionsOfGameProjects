extends Label

var builder : BuilderDummy

# Called when the node enters the scene tree for the first time.
func _ready():
	self.builder = self.get_parent() as BuilderDummy


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.text = str("BuildMode: ", builder.isBuildMode )
