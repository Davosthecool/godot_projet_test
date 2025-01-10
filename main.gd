extends Node

var camera : Camera2D
var player : CharacterBody2D
var player_ui : Control

var current_map : Node2D
var endScreen : Control

var is_player_started : bool = false
var is_player_ended : bool = false
var elapsed_time : float

func on_player_start():
	camera.speed = camera.move_speed
	is_player_started = true

func finish_game(text: String):
	is_player_ended = true
	camera.speed = 0
	player_ui.hide()
	endScreen.setText(text)
	endScreen.setTimer(elapsed_time)
	endScreen.set_position(Utils.get_world_position_from_camera(Vector2(0,0),camera))
	endScreen.show()
	
func on_player_dead():
	finish_game("GAME OVER")
func on_player_ended():
	FilesUtils.save_best_timer(Utils.round_to_dec(elapsed_time,2),Global.current_map)
	finish_game("YOU WIN")
	

func restart_game():
	get_tree().reload_current_scene()
	
func back_to_menu():
	get_tree().change_scene_to_file("res://MainMenu/main_menu.tscn")
	
# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		match child.name:
			"Camera": camera = child
			"Player": player = child
			"PlayerUI": player_ui = child
			"EndScreen": endScreen = child
			

	current_map = Global.maps[Global.current_map].instantiate()
	add_child(current_map)
	
	player.position = get_meta("spawn")
	player.position.y -= 100
	current_map.position = get_meta("spawn")
	camera.position = get_meta("spawn")
	
	player.connect("player_started",Callable(self,"on_player_start"))
	player.connect("player_died",Callable(self,"on_player_dead"))
	player.connect("player_ended",Callable(self,"on_player_ended"))
	endScreen.connect("restart_game",Callable(self,"restart_game"))
	endScreen.connect("back_to_menu",Callable(self,"back_to_menu"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_player_started or is_player_ended:
		return
		
	elapsed_time+=delta
	player_ui.position = Utils.get_world_position_from_camera(Vector2(0,0),camera)
	player_ui.timerCD = player.get_node("slide_cooldown").time_left
	player_ui.elapsed = elapsed_time
	
	var screen_size = camera.get_viewport_rect().size
	if player.position.x > camera.position.x:
		camera.speed = lerp(camera.speed,player.speed*1.3,delta)
	else:
		camera.speed = lerp(camera.speed,camera.move_speed,delta)
