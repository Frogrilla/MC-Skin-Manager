class_name Utils

static func data_from_dict(data : Dictionary) -> SkinData:
	var skin = SkinData.new(
		decode_image(data["skinImage"]),
		decode_image(data["modelImage"]),
		data["name"],
		data["slim"]
	)
	
	skin.created = Time.get_unix_time_from_datetime_string(data["created"])
	
	if data.has("capeId"):
		skin.cape_id = data["capeId"]
	
	if data.has("textureId"):
		skin.texture_id = data["textureId"]
	
	return skin

static func decode_image(image_data : String) -> Texture2D:
	var bytes = Marshalls.base64_to_raw(image_data.replace("data:image/png;base64,", "").replace("\\u003d", ""))
	var image = Image.new()
	image.load_png_from_buffer(bytes)
	return ImageTexture.create_from_image(image)

static func encode_image(image : Image) -> String:
	return "data:image/png;base64," + Marshalls.raw_to_base64(image.save_png_to_buffer())
