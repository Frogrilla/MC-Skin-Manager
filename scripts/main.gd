extends Node
class_name Main

@onready var skin_parent = $VBoxContainer/ScrollContainer/HFlowContainer
@onready var container_scene = preload("res://scenes/skin_container.tscn")

var json_path = ""

func _ready():
	load_capes()
	load_poses()

func load_from_path(path : String):
	var json = JSON.new()
	var error = json.parse(FileAccess.get_file_as_string(path))
	
	if error == OK:
		json_path = path
		
		for child in skin_parent.get_children():
			child.queue_free()
		
		for child in get_tree().get_nodes_in_group("window"):
			child.queue_free()
		
		var skins : Array[SkinData]
		for id in json.data["customSkins"]:
			var skin = json.data["customSkins"][id] as Dictionary
			skins.append(Utils.data_from_dict(skin))
			print("Parsed skin " + skin["name"])
		
		skins.sort_custom(SkinData.compare)
		
		for skin in skins:
			var container = container_scene.instantiate() as SkinContainer
			skin_parent.add_child(container)
			container.data = skin
			container.reload_skin()
			print("Added skin container for " + container.data.name)
			
			if !CapeData.id_exists(skin.cape_id):
				CapeData.put_cape(skin.cape_id, UnknownCapeData.new(skin))
	else:
		print("JSON Parse SkinData error")

func save_to_path(path : String):
	if path == "":
		return
	
	var json_dict = {"customSkins" : {}, "version" : 1}
	var time = Time.get_unix_time_from_system()
	var i = 1
	
	for child in skin_parent.get_children():
		var skin = child.data
		var id = "skin_%d" % (i)
		
		var dict = {
			"capeId" : skin.cape_id,
			"created" : Time.get_datetime_string_from_unix_time(time),
			"id" : id,
			"modelImage" : Utils.encode_image(skin.model_image.get_image()),
			"name" : skin.name,
			"skinImage" : Utils.encode_image(skin.skin_image.get_image()),
			"slim": skin.slim,
			"textureId": skin.texture_id,
			"updated": Time.get_datetime_string_from_unix_time(time)
		} as Dictionary
		
		if skin.cape_id == "":
			dict.erase("capeId")
			
		if skin.texture_id == "":
			dict.erase("textureId")
		
		time -= 1
		i += 1
		
		json_dict["customSkins"][id] = dict
	
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(JSON.stringify(json_dict, "\t"))
	file.close()

func load_capes():
	if not FileAccess.file_exists("user://capes.json"):
		CapeData.put_cape("", CapeData.new("No Cape", load("res://cape_textures/none.png")))
		CapeData.put_cape("7412868d-7be3-429f-b629-ed5074d2455c", CapeData.new("Vanilla", load("res://cape_textures/vanilla.png")))
		CapeData.put_cape("30743269-ab43-46e6-b25d-3b50b0f1ed41", CapeData.new("Blossom", load("res://cape_textures/blossom.png")))
		CapeData.put_cape("e7fcd100-d7dd-4c6c-a5f2-34bad18a3869", CapeData.new("Purple Heart", load("res://cape_textures/purple heart.png")))
		CapeData.put_cape("5af20372-79e0-4e1f-80f8-6bd8e3135995", CapeData.new("Migrator", load("res://cape_textures/migrator.png")))
		CapeData.put_cape("ef9e95b6-48a3-4fd7-93d4-7e7d9448d2f1", CapeData.new("15th Anniversary", load("res://cape_textures/15th anniversary.png")))
		CapeData.put_cape("d1c0e04c-a227-4b3a-8cb1-fb1cf9e1e960", CapeData.new("MCC 15th Year", load("res://cape_textures/mcc 15.png")))
		CapeData.put_cape("c3cec265-d3dc-4868-a793-b61b0ba10389", CapeData.new("Follower's", load("res://cape_textures/follower's.png")))
		save_capes()
		return
	
	var json = JSON.new()
	var error = json.parse(FileAccess.get_file_as_string("user://capes.json"))
		
	if error == OK:
		for id in json.data:
			var dict = json.data[id] as Dictionary
			var cape = CapeData.new(dict["name"], Utils.decode_image(dict["texture"]))
			CapeData.put_cape(id, cape)
			print("Parsed cape " + cape.name)
	else:
		print("JSON Parse CapeData error")

func save_capes():
	var cape_file = FileAccess.open("user://capes.json", FileAccess.WRITE)
	var dict : Dictionary
	for key in CapeData.cape_dict.keys():
		var cape = CapeData.cape_dict[key]
		if not(cape is UnknownCapeData):
			dict[key] = cape.create_dict()
	
	var json_string = JSON.stringify(dict, "\t")
	cape_file.store_string(json_string)
	cape_file.close()

func load_poses():
	if not FileAccess.file_exists("user://poses.json"):
		PlayerModel.poses["default"] = {}
		PlayerModel.poses["walk"] = {
			"RightArm": Vector3(15,0,0), 
			"LeftArm" : Vector3(-15,0,0),
			"RightLeg": Vector3(-15,0,0), 
			"LeftLeg" : Vector3(15,0,0)
		}
		PlayerModel.poses["sit"] = {
			"Head": Vector3(5,0,0),
			"RightArm": Vector3(-15,4,15), 
			"LeftArm" : Vector3(-15,4,-15),
			"RightLeg": Vector3(75,-15,0), 
			"LeftLeg" : Vector3(75,15,0)
		}
		PlayerModel.poses["jump"] = {
			"Head": Vector3(15,0,0),
			"RightArm": Vector3(7.5, -15.8, 148.9),
			"LeftArm" : Vector3(7.4, 13.1, -149.1),
			"RightLeg" : Vector3(-13,7.6,14.1),
			"LeftLeg" : Vector3(-13,-7.6,-14.1)
		}
		PlayerModel.poses["zombie"] = {
			"": Vector3(-15,0,0),
			"Head": Vector3(4,0,0),
			"RightArm": Vector3(75,0,0), 
			"LeftArm" : Vector3(75,0,0),
			"LeftLeg" : Vector3(30,0,0)
		}
		PlayerModel.poses["point"] = {
			"": Vector3(0,30,0),
			"Head": Vector3(0,-15,0),
			"RightArm": Vector3(42.7,42.2,70.1), 
			"LeftArm" : Vector3(-13,15.9,-7.6),
			"RightLeg" : Vector3(-20.2,-3.1,6.1),
			"LeftLeg" : Vector3(20.2,-3.1,-6.1)
		}
		save_poses()
		return
	
	var json = JSON.new()
	var error = json.parse(FileAccess.get_file_as_string("user://poses.json"))
	
	if error == OK:
		for pose in json.data:
			PlayerModel.poses[pose] = {}
			for part in json.data[pose]:
				var xyz = json.data[pose][part]
				PlayerModel.poses[pose][part] = Vector3(xyz[0], xyz[1], xyz[2])
	else:
		print("JSON Parse poses error")

func save_poses():
	var pose_file = FileAccess.open("user://poses.json", FileAccess.WRITE)
	
	var dict = {}
	
	for pose in PlayerModel.poses:
		dict[pose] = {}
		for part in PlayerModel.poses[pose]:
			var rotation = PlayerModel.poses[pose][part]
			dict[pose][part] = [rotation.x, rotation.y, rotation.z]
	
	var json_string = JSON.stringify(dict, "\t")
	pose_file.store_string(json_string)
	pose_file.close()

func _on_file_id_pressed(id):
	match id:
		0:
			var file_chooser = preload("res://scenes/file_chooser.tscn").instantiate() as FileDialog
			add_child(file_chooser)
			file_chooser.add_filter("*.json", "JSON files")
			file_chooser.file_selected.connect(load_from_path)
			file_chooser.popup()
		1:
			save_to_path(json_path)

func _on_skin_id_pressed(id):
	if json_path != "":		
		match id:
			0:
				var container = container_scene.instantiate() as SkinContainer
				skin_parent.add_child(container)
				container.data = preload("res://resources/blank_skin.tres").duplicate()
				container.reload_skin()
				skin_parent.move_child(container, 0)

func _on_cape_id_pressed(id):
	match id:
		0:
			var cape_creator = preload("res://scenes/cape_creator.tscn").instantiate()
			add_child(cape_creator)
		1:
			var cape_verifier = preload("res://scenes/unknown_cape_verifier.tscn").instantiate()
			add_child(cape_verifier)

func _on_order_id_pressed(id):
	for i in skin_parent.get_child_count()-1:
		for j in skin_parent.get_child_count()-i-1:
			var a = skin_parent.get_child(j)
			var b = skin_parent.get_child(j+1)
			
			match id:
				0: # Random
					if randi() % 2 == 0:
						skin_parent.move_child(a, j+1)
				1: # Alphabetical
					if a.data.name.to_lower() > b.data.name.to_lower():
						skin_parent.move_child(a, j+1)

func _on_tree_exiting():
	save_capes()
