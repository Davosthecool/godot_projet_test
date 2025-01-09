extends VBoxContainer

func start_game(map_name : String):
	Global.current_map = map_name
	get_tree().change_scene_to_file("res://main.tscn")
	
func create_levels_buttons(container: VBoxContainer, timers : Dictionary):
	var lines = len(Global.maps) % 5
	for i in range(lines):
		var hbox = HBoxContainer.new()
		hbox.clip_contents = true
		hbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
		
		var rows = 5 if len(Global.maps)>= 5*(i+1) else len(Global.maps) - (5*i)
		for j in range(rows):
			var name = Global.maps.keys()[(i*5)+j]
			var button = Button.new()
			button.text = "{}\n{}".format([j+1, timers.get(name, "")],"{}")
			button.custom_minimum_size = Vector2(100,100)
			button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER + Control.SIZE_EXPAND
			button.size_flags_vertical = Control.SIZE_SHRINK_CENTER
			button.connect("pressed",func(): start_game(name))
			hbox.add_child(button)
		
		container.add_child(hbox)
		
		
# Called when the node enters the scene tree for the first time.
func _ready():
	create_levels_buttons(self,FilesUtils.get_best_timers())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
