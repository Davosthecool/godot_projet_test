extends Node

var camera : Camera2D
var map : Node2D
var player : CharacterBody2D
var player_ui : Control

var deathScreen : Control


func on_player_dead():
	camera.speed = 0
	player_ui.hide()
	deathScreen.set_position(Utils.get_world_position_from_camera(Vector2(0,0),camera))
	deathScreen.show()

func restart_game():
	get_tree().reload_current_scene()
	
func back_to_menu():
	get_tree().change_scene_to_file("res://MainMenu/main_menu.tscn")
	
# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		match child.name:
			"Camera": camera = child
			"Map": map = child
			"Player": player = child
			"PlayerUI": player_ui = child
			"DeathScreen": deathScreen = child
	
	
	player.position = get_meta("spawn")
	player.position.y -= 100
	map.position = get_meta("spawn")
	camera.position = get_meta("spawn")
	
	
	player.connect("player_died",Callable(self,"on_player_dead"))
	deathScreen.connect("restart_game",Callable(self,"restart_game"))
	deathScreen.connect("back_to_menu",Callable(self,"back_to_menu"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	player_ui.position = Utils.get_world_position_from_camera(Vector2(0,0),camera)
	player_ui.timerCD = player.get_node("slide_cooldown").time_left
