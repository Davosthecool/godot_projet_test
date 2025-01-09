extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_reset_settings_button_pressed():
	FilesUtils.reset_preferences()
	get_tree().reload_current_scene()


func _on_delete_datas_button_pressed():
	FilesUtils.delete_datas()
	get_tree().reload_current_scene()
