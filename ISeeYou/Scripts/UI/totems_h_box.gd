extends HBoxContainer
class_name TotemsHBox


@export var curIndex : int = 0

var totems: Array[TextureRect]

func _ready():
	for rect in self.get_children():
		if rect is TextureRect:
			self.totems.append(rect)
			var rectNameAsInt : int = int(rect.name)
			if !rect.texture and rectNameAsInt < curIndex :
				self.curIndex = rectNameAsInt


func add_totem(sprite: Texture2D):
	if curIndex < 0:
		curIndex = 0
	elif curIndex > totems.size() - 1: # i know min max possible but easier to debug here
		curIndex = totems.size() -1;
	var foundRect: TextureRect = self.totems[curIndex]
	if foundRect:
		foundRect.texture = sprite
		curIndex += 1
	
func remove_totem(index: int):
	if index > 0 and index < totems.size():
		var foundRect: TextureRect = self.totems[curIndex]
		if foundRect:
			foundRect.set_texture(null)
