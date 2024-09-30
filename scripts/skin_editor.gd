extends Window
class_name SkinEditor

signal skin_saved(data : SkinData)

var data : SkinData

@export var model_image : TextureRect
@export var skin_image : TextureRect
@export var skin_name : LineEdit
@export var cape_selector : OptionButton
@export var slim_button : CheckBox

@export var fov_picker : SpinBox
@export var part_hiders : Array[BaseButton]
@export var pose_picker : OptionButton

@export var player_pivot : Node3D
@export var player_model : PlayerModel
@export var camera_pivot : Node3D
@export var camera : Camera3D

var cape_ids : Array[String]
var pose_ids : Array[String]

func _ready():
	for key in CapeData.cape_dict.keys():
		cape_ids.append(key)
		var cape = CapeData.cape_dict.get(key)
		var image = cape.texture.get_image().get_region(Rect2i(1,1,10,16))
		cape_selector.add_icon_item(ImageTexture.create_from_image(image), cape.name if cape.name != "" else "<unnamed cape>")
	for key in PlayerModel.poses.keys():
		pose_ids.append(key)
		pose_picker.add_item(key)

func set_skin(skin):
	data = skin.duplicate()
	skin_name.text = data.name
	title = data.name if data.name != "" else "<unnamed skin>"
	model_image.texture = data.model_image
	skin_image.texture = data.skin_image
	cape_selector.select(cape_ids.find(data.cape_id))
	slim_button.button_pressed = data.slim
	player_model.set_skin(skin)

func model_image_selected(path):
	var image = Image.new()
	var err = image.load(path)
	if err != OK:
		return
	image.resize(288, 384)
	var texture = ImageTexture.create_from_image(image)
	data.model_image = texture
	model_image.texture = texture

func skin_image_selected(path):
	var image = Image.new()
	var err = image.load(path)
	if err != OK:
		return
	if image.get_width() != 64 or (image.get_width() != 32 and image.get_width() != 64):
		return;
	var texture = ImageTexture.create_from_image(image)
	data.skin_image = texture
	skin_image.texture = texture
	player_model.set_texture(texture)
	player_model.set_size(texture.get_height() == 64)

func model_image_from_camera():
	var img = camera.get_viewport().get_texture().get_image()
	var texture = ImageTexture.create_from_image(img)
	data.model_image = texture
	model_image.texture = texture

func _on_close_requested():
	queue_free()

func _on_name_changed(new_text : String):
	data.name = new_text
	title = data.name if data.name != "" else "<unnamed skin>"

func _on_cape_selected(index : int):
	data.cape_id = cape_ids[index]
	player_model.set_cape(CapeData.cape_dict[data.cape_id].texture)

func _on_slim_toggled(slim : bool):
	data.slim = slim
	player_model.set_slim(slim)

func _on_save_button():
	skin_saved.emit(data)

func _on_upload_model_pressed():
	var file_chooser = preload("res://scenes/file_chooser.tscn").instantiate()
	get_tree().root.add_child(file_chooser)
	file_chooser.title = "Upload model image"
	file_chooser.add_filter("*.png", "PNG files")
	file_chooser.file_selected.connect(model_image_selected)
	file_chooser.popup()

func _on_upload_skin_pressed():
	var file_chooser = preload("res://scenes/file_chooser.tscn").instantiate()
	get_tree().root.add_child(file_chooser)
	file_chooser.title = "Upload skin image"
	file_chooser.add_filter("*.png", "PNG files")
	file_chooser.file_selected.connect(skin_image_selected)
	file_chooser.popup()

func _on_pose_selection(index):
	player_model.set_pose(pose_ids[index])

func set_cape_angle(value):
	player_model.set_cape_angle(value)

func set_pos_x(value):
	player_pivot.position.x = value

func set_pos_y(value):
	player_pivot.position.y = value

func set_pos_z(value):
	player_pivot.position.z = value

func set_rot_x(value):
	player_pivot.rotation_degrees.x = value

func set_rot_y(value):
	player_pivot.rotation_degrees.y = value

func set_rot_z(value):
	player_pivot.rotation_degrees.z = value

func set_scale_x(value):
	player_pivot.scale.x = value

func set_scale_y(value):
	player_pivot.scale.y = value

func set_scale_z(value):
	player_pivot.scale.z = value

func set_fov(value):
	if value == 0:
		if camera.projection != Camera3D.PROJECTION_ORTHOGONAL:
			camera.set_orthogonal(2.75, 0.05, 4000)
	else:
		if camera.projection != Camera3D.PROJECTION_PERSPECTIVE:
			camera.set_perspective(value, 0.05, 4000)
		else:
			camera.fov = value
		camera.position.z = (-16 / (value/10))

func change_part_visibility():
	for part in part_hiders:
		player_model.show_part(part.name, part.button_pressed)
