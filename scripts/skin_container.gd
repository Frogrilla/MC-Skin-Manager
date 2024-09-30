extends Node
class_name SkinContainer

@export var data : SkinData

@export var label : Label
@export var image : TextureRect
@export var select_graphic : TextureRect

var editor_open = false
var delete_open = false

func _ready():	
	reload_skin()

func reload_skin():
	label.text = data.name if data.name != "" else "<unnamed skin>"
	image.texture = data.model_image

func skin_modified(data_in):
	data = data_in
	reload_skin()

func open_editor():
	
	if editor_open:
		return
	
	editor_open = true
	var window = preload("res://scenes/skin_editor.tscn").instantiate() as SkinEditor
	get_tree().root.add_child(window)
	window.set_skin(data)
	window.show()
	window.close_requested.connect(closed_editor)
	window.skin_saved.connect(skin_modified)

func closed_editor():
	editor_open = false
	
func open_delete_confirmation():
	if delete_open:
		return
	
	delete_open = true
	var window = preload("res://scenes/delete_confirmation.tscn").instantiate() as SkinDeleter
	get_tree().root.add_child(window)
	window.set_skin(data)
	window.show()
	window.canceled.connect(closed_delete_confirmation)
	window.confirmed.connect(delete_container)

func closed_delete_confirmation():
	delete_open = false

func delete_container():
	queue_free()

func duplicate_container():
	var container = preload("res://scenes/skin_container.tscn").instantiate() as SkinContainer
	get_parent().add_child(container)
	get_parent().move_child(container, get_index()+1)
	container.data = data.duplicate()
	container.data.name += " (copy)"
	container.reload_skin()
