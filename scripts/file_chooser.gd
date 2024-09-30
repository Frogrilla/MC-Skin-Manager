extends FileDialog

func _on_closed():
	queue_free()
