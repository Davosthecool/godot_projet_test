extends Control

signal restart_game
signal back_to_menu

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_restart_button_pressed():
	emit_signal("restart_game") # Replace with function body.


func _on_menu_button_pressed():
	emit_signal("back_to_menu") # Replace with function body.
