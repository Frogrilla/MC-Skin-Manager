extends CapeData
class_name UnknownCapeData

var user : String
var user_image : Texture

func _init(skin : SkinData):
	self.name = "<unknown cape>"
	self.texture = preload("res://cape_textures/fallback.png")
	self.user = skin.name
	self.user_image = skin.model_image
