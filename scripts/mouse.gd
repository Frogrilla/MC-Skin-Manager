extends Node2D

var grabbed = false
var container : SkinContainer
var wait = 0
@onready var area = $Area2D

func _input(event):
	if !grabbed and event.is_action_pressed("grab"):
		if area.has_overlapping_areas():
			for found in area.get_overlapping_areas():
				found.monitorable = false
				container = found.get_parent()
				container.select_graphic.visible = true
				grabbed = true
				break
	if grabbed and event.is_action_released("grab"):
		grabbed = false
		container.find_child("Area2D").monitorable = true
		container.select_graphic.visible = false
		container = null

func _process(delta):
	position = get_viewport().get_mouse_position()
	if wait == 0 and grabbed and area.has_overlapping_areas():
		for found in area.get_overlapping_areas():
			var next_to = found.get_parent() as Node
			container.get_parent().move_child(container, next_to.get_index())
			wait = 0.1
	
	if grabbed and not Input.is_action_pressed("grab"):
		grabbed = false
		container.find_child("Area2D").monitorable = true
		container.select_graphic.visible = false
		container = null
	
	if wait > 0:
		wait -= delta
	elif wait < 0:
		wait = 0
