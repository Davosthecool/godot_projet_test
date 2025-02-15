extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_button_pressed():
	$MainMenuContainer.hide()
	$LevelSelectorContainer.show()


func _on_exit_button_pressed():
	get_tree().quit()


func _on_settings_button_pressed():
	$MainMenuContainer.hide()
	$SettingsContainer.show()

func _on_settings_back_button_pressed():
	$MainMenuContainer.show()
	$SettingsContainer.hide()


func _on_level_selector_back_button_pressed():
	$MainMenuContainer.show()
	$LevelSelectorContainer.hide()
