extends Window
class_name CapeCreator

@export var cape_image : TextureRect
@export var cape_name : LineEdit
@export var cape_id : LineEdit

func set_cape(id : String):
	var cape = CapeData.cape_dict[id]
	cape_image.texture = cape.texture
	cape_name.text = cape.name
	cape_id.text = id

func cape_image_selected(path):
	var image = Image.new()
	var err = image.load(path)
	if err != OK:
		return
	if image.get_width() != 64 or image.get_height() != 32:
		return;
	var texture = ImageTexture.create_from_image(image)
	cape_image.texture = texture;

func _on_add_button_pressed():
	var cape = CapeData.new(cape_name.text, cape_image.texture)
	CapeData.cape_dict[cape_id.text] = cape
	queue_free()

func _on_upload_cape_pressed():
	var file_chooser = preload("res://scenes/file_chooser.tscn").instantiate()
	add_child(file_chooser)
	
	file_chooser.add_filter("*.png", "PNG files")
	file_chooser.file_selected.connect(cape_image_selected)
	file_chooser.popup()

func _on_close_requested():
	queue_free()
