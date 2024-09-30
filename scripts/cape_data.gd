extends Resource
class_name CapeData

static var capes : Array[CapeData]
static var cape_dict : Dictionary

@export var name : String
@export var texture : Texture

func _init(name : String, texture : Texture):
	self.name = name
	self.texture = texture

func _to_string():
	return name

func create_dict():
	return {
		"name": name,
		"texture": Utils.encode_image(texture.get_image())
	}

static func id_exists(cape_id : String):
	if cape_dict.has(cape_id):
		return true

static func put_cape(id : String, data : CapeData):
	cape_dict[id] = data
	print("put cape %s" % data.name)
