extends Window
class_name UnknownCapeVerifier

@export var cape_image : TextureRect
@export var description : Label
@export var cape_selector : OptionButton
var unknown_ids : Array[String]

func _ready():
	for key in CapeData.cape_dict.keys():
		var cape = CapeData.cape_dict[key]
		if cape is UnknownCapeData:
			cape_selector.add_item(key)
			unknown_ids.append(key)
	
	if unknown_ids.size() > 0:
		var cape = CapeData.cape_dict[unknown_ids[cape_selector.get_selected_id()]] as UnknownCapeData
		cape_image.texture = cape.user_image
		description.text = "Cape found on skin: %s" % cape.user

func _on_edit_button_pressed():
	var index = cape_selector.get_selected_id()
	if index == -1:
		return
	var cape_creator = preload("res://scenes/cape_creator.tscn").instantiate() as CapeCreator
	get_parent().add_child(cape_creator)
	cape_creator.set_cape(unknown_ids[index])
	queue_free()


func _on_cape_selector_item_selected(index):
	var cape = CapeData.cape_dict[unknown_ids[index]] as UnknownCapeData
	cape_image.texture = cape.user_image
	description.text = "Cape found on skin: %s" % cape.user

func _on_close_requested():
	queue_free()
