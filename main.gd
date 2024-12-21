extends Node

var camera : Camera2D
var map : TileMapLayer
var player : CharacterBody2D

func on_player_dead():
	camera.speed = 0
	player.die(camera.get_screen_center_position())
	
# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		match child.name:
			"Camera": camera = child
			"Map": map = child
			"Player": player = child
	
	player.connect("player_exited_screen",Callable(self,"on_player_dead"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
