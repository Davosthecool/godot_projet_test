class_name FilesUtils

static func get_folder_scenes(path):
	var scene_loads = {}	

	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				if file_name.get_extension() == "tscn":
					var full_path = path.path_join(file_name)
					scene_loads[file_name.get_basename()] = load(full_path)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

	return scene_loads

static func save_keybindings_file(keybinds: Dictionary):
	var file = FileAccess.open("user://custom/preferences/keybindings.cfg", FileAccess.WRITE)
	file.store_var(keybinds)
	file.close()

static func load_keybindings_file():
	var file = FileAccess.open("user://custom/preferences/keybindings.cfg", FileAccess.READ)
	if file==null: 
		return
	
	var data = file.get_var()
	file.close()
	return data



static func delete_folder_contents(path: String):
	var dir = DirAccess.open(path)
	if dir == null: print("Error opening dir :", path)
	
	for file in dir.get_files():
		var error = dir.remove(file)
		if error != 0: print("Error removing file :", file)
	
	
static func reset_preferences():
	delete_folder_contents("user://custom/preferences")

static func delete_datas():
	delete_folder_contents("user://custom/data")

static func get_best_timers():
	var file = FileAccess.open("user://custom/data/maps_scores.cfg", FileAccess.READ)
	if file==null: 
		return {}

	return file.get_var() as Dictionary


static func save_timer(timer: float, map: String):
	var timers : Dictionary
	
	var file = FileAccess.open("user://custom/data/maps_scores.cfg", FileAccess.READ)
	if file!=null: 
		timers = file.get_var()
		file.close()
	else: 
		print("else")
		timers = {}
	
	timers[map] = timer
	
	file = FileAccess.open("user://custom/data/maps_scores.cfg", FileAccess.WRITE)
	file.store_var(timers)
	file.close()
	
static func save_best_timer(timer: float, map: String):
	var timers = get_best_timers()
	if timers != null and timers.get(map,INF)<timer:
		return
	
	save_timer(timer,map)
