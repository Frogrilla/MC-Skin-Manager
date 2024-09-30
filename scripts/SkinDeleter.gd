extends ConfirmationDialog
class_name SkinDeleter

func _ready():
	self.title = "Confirm skin deletion"

func set_skin(data : SkinData):
	self.dialog_text = "Delete skin %s?" % data.name
