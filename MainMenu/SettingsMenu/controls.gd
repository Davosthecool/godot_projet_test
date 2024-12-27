extends TabBar

enum Bindings { FORWARD, BACKWARD, JUMP, CROUCH, UNKNOWN }

var bindings_datas = {
	Bindings.FORWARD : {"name":"Move Left", "key":"move_forward"},
	Bindings.BACKWARD : {"name":"Move Right", "key":"move_backward"},
	Bindings.JUMP : {"name":"Jump", "key":"jump"},
	Bindings.CROUCH : {"name":"Sneak", "key":"crouch"},
	Bindings.UNKNOWN : {"name": "Unknown", "key":""}
}

func get_binding_from_key(key: String):
	for bind in bindings_datas.values():
		if bind["key"]==key: return bind
	return Bindings.UNKNOWN
	
func create_bindings(container: VBoxContainer):
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
		
		action_container.add_child(separator.duplicate())
		action_container.add_child(action_label)
		action_container.add_child(action_button)
		action_container.add_child(separator.duplicate())
		
		container.add_child(action_container)
		
	container.add_child(separator)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	create_bindings($ControlsContainer/ControlsList)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
