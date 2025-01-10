extends Node

var maps
var current_map = "map1"

func _ready():
	maps = FilesUtils.get_folder_scenes("res://Map/")
	DirAccess.make_dir_recursive_absolute("user://custom/preferences")
	DirAccess.make_dir_recursive_absolute("user://custom/data/")
