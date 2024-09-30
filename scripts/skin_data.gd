extends Resource
class_name SkinData

@export var name : String
@export var skin_image : Texture2D
@export var model_image : Texture2D
@export var slim : bool
@export var cape_id : String
@export var created : int
@export var texture_id : String

func _init(skin := Texture2D.new(), model := Texture2D.new(), name_in := "",  slim_in := false, cape := ""):
	self.name = name_in
	self.skin_image = skin 
	self.model_image = model
	self.slim = slim_in
	self.cape_id = cape
	
	if model_image.get_image():
		var img = model_image.get_image()
		img.resize(288, 384, Image.INTERPOLATE_BILINEAR)
		model_image = ImageTexture.create_from_image(img)

func _to_string():
	return name

func head_image() -> Image:
	return skin_image.get_region(Rect2i(8,8,8,8))

static func compare(a : SkinData, b : SkinData) -> bool:
	return a.created > b.created
