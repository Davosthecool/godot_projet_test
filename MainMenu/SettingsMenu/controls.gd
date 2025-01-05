extends TabBar

var waiting_input: String = ""
var button_on_change: Button = null

enum Bindings { FORWARD, BACKWARD, JUMP, CROUCH, UNKNOWN }

var bindings_datas = {
	Bindings.FORWARD : {"name":"Move Right", "key":"move_forward"},
	Bindings.BACKWARD : {"name":"Move Left", "key":"move_backward"},
	Bindings.JUMP : {"name":"Jump", "key":"jump"},
	Bindings.CROUCH : {"name":"Sneak", "key":"crouch"},
	Bindings.UNKNOWN : {"name": "Unknown", "key":""}
}

func on_button_pressed(bind: String, button: Button):
	waiting_input = bind
	button_on_change = button
	button_on_change.text = ""
	
func get_binding_from_key(key: String):
	for bind in bindings_datas.values():
		if bind["key"]==key: return bind
	return Bindings.UNKNOWN
	
func create_bindings_nodes(container: VBoxContainer):
	var actions = InputMap.get_actions()
	var index = actions.find("ui_swap_input_direction")
	var new_actions = actions.slice(index+1,actions.size())
	
	var separator = Control.new()
	separator.name = "Separator"
	container.add_child(separator)
	
	for act in new_actions:
		var action = get_binding_from_key(act)
		var node_name = action["name"].replace(" ","")
		
		var action_container = HBoxContainer.new()
		action_container.name = "{}Container".format([node_name],"{}")
		action_container.custom_minimum_size = Vector2(0,50)
		action_container.add_theme_constant_override("separation",40)
		
		var action_label = RichTextLabel.new()
		action_label.name = "{}Label".format([node_name],"{}")
		action_label.bbcode_enabled = true
		action_label.fit_content = true
		action_label.autowrap_mode = TextServer.AUTOWRAP_OFF
		action_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		action_label.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		action_label.text = "[center][font_size=25]{}[/font_size][/center]".format([action['name']],"{}")
		
		var action_button = Button.new()
		action_button.name = "{}Button".format([node_name],"{}")
		action_button.text = InputMap.action_get_events(action["key"])[0].as_text()
		action_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		action_button.connect("pressed",func() : on_button_pressed(action["key"],action_button))
		
		action_container.add_child(separator.duplicate())
		action_container.add_child(action_label)
		action_container.add_child(action_button)
		action_container.add_child(separator.duplicate())
		
		container.add_child(action_container)
		
	container.add_child(separator)

func save_keybindings():
	var file = FileAccess.open("user://keybindings.cfg", FileAccess.WRITE)
	var keybindings = {}
	
	for data in bindings_datas.values():
		if data["key"]=="":
			continue
		keybindings[data["key"]] = var_to_str(InputMap.action_get_events(data["key"])[0])

	file.store_var(keybindings)
	file.close()

func load_keybindings():
	var file = FileAccess.open("user://keybindings.cfg", FileAccess.READ)
	var keybindings = file.get_var()
	for key in keybindings.keys():
		InputMap.action_erase_events(key)
		InputMap.action_add_event(key,str_to_var(keybindings[key]))
	file.close()






# Called when the node enters the scene tree for the first time.
func _ready():
	load_keybindings()
	create_bindings_nodes($ControlsContainer/ControlsList)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if waiting_input!="" and event is InputEventKey and event.pressed:
		InputMap.action_erase_events(waiting_input)
		InputMap.action_add_event(waiting_input, event)
		waiting_input = ""
		button_on_change.text = event.as_text()
		button_on_change = null
		save_keybindings()
		
	
