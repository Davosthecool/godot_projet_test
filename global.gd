extends Node

var maps = FilesUtils.get_folder_scenes("res://Map/")
var current_map = "map1"

func _ready():
	DirAccess.make_dir_recursive_absolute("user://custom/preferences")
	DirAccess.make_dir_recursive_absolute("user://custom/data/")
