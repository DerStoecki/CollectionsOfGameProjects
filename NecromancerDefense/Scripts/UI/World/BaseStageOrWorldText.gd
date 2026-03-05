extends RichTextLabel
class_name BaseStageOrWorldText

@export var parentTexture: BaseStageOrWorldTextureButton

func _ready():
	self.visible = false
	self.parentTexture.enter_highlight.connect(Callable(self, "enter"))
	self.parentTexture.exit_highlight.connect(Callable(self, "exit"))


func enter():
	self.visible = true

func exit():
	self.visible = false
	

