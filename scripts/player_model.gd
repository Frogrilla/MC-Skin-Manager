extends Node3D
class_name PlayerModel

static var poses = {}

func set_skin(data : SkinData):
	set_slim(data.slim)
	set_size(data.skin_image.get_height() == 64)
	set_texture(data.skin_image)
	set_cape(CapeData.cape_dict.get(data.cape_id).texture)

func set_slim(slim : bool):
	for child_slim in find_children_in_group(self, "slim"):
		child_slim.visible = slim
	
	for child_wide in find_children_in_group(self, "wide"):
		child_wide.visible = !slim

func set_size(x64 : bool):
	for child64 in find_children_in_group(self, "64"):
		child64.visible = x64
	
	for child32 in find_children_in_group(self, "32"):
		child32.visible = !x64

func show_part(part : String, show : bool):
	for node in find_children_in_group(self, part):
		node.visible = show

func show_cape(show : bool):
	for node in find_children_in_group(self, "cape"):
		node.visible = show

func set_cape(texture : Texture):
	var material = preload("res://materials/blank.tres").duplicate()
	material.albedo_texture = texture
	for node in find_children_in_group(self, "cape"):
		if node is MeshInstance3D:
			node.set_surface_override_material(0, material)

func set_texture(texture : Texture):
	var base_material = preload("res://materials/blank.tres").duplicate()
	base_material.albedo_texture = ImageTexture.create_from_image(texture.get_image().get_region(Rect2i(0,0,64,64)));
	var layer_material = base_material.duplicate()
	base_material.transparency = BaseMaterial3D.TRANSPARENCY_DISABLED
	layer_material.cull_mode = BaseMaterial3D.CULL_DISABLED
	for node in find_children_in_group(self, "player"):
		if node is MeshInstance3D:
			node.set_surface_override_material(0, layer_material if node.is_in_group("layer") else base_material)

func find_children_in_group(parent : Node, group : String) -> Array[Node]:
	var nodes : Array[Node]
	for child in parent.get_children():
		if child.is_in_group(group):
			nodes.append(child)
		nodes.append_array(find_children_in_group(child, group))
	return nodes

func set_pose(id : String):
	var pose = poses[id] as Dictionary
	
	for child in get_children():
		if child.name == "Cape":
			continue
		
		if child.name in pose.keys():
			child.rotation_degrees = pose[child.name]
		else:
			child.rotation = Vector3.ZERO
	
	if pose.has(""):
		rotation_degrees = pose[""]
	else:
		rotation = Vector3.ZERO

func set_cape_angle(value):
	find_child("Cape").rotation_degrees.x = value
