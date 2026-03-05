extends Label

class_name BaseStageOrWorldWorldLabel

@export var containerParent : BaseStageOrWorldContainer
@export var parentTexture: BaseStageOrWorldTextureButton

func _ready():
	self.text = self.containerParent.number
	self.parentTexture.enter_highlight.connect(Callable(self, "enter"))
	self.parentTexture.exit_highlight.connect(Callable(self, "exit"))


func enter():
	self.text = self.containerParent.callingName

func exit():
	self.text = self.containerParent.number
	

