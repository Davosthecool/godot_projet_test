extends Node

var camera : Camera2D
var map : TileMapLayer
var player : CharacterBody2D

var deathScreen : Control


func on_player_dead():
	camera.speed = 0
	player.die(camera.get_screen_center_position())
	
	var top_left = camera.get_screen_center_position() - (camera.get_viewport_rect().size / 2)
	deathScreen.set_position(top_left)
	deathScreen.show()

func restart_game():
	get_tree().reload_current_scene()
	
func back_to_menu():
	get_tree().quit()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		match child.name:
			"Camera": camera = child
			"Map": map = child
			"Player": player = child
			"DeathScreen": deathScreen = child
	
	player.connect("player_exited_screen",Callable(self,"on_player_dead"))
	deathScreen.connect("restart_game",Callable(self,"restart_game"))
	deathScreen.connect("back_to_menu",Callable(self,"back_to_menu"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
