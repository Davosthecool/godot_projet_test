class_name Utils


static func get_world_position_from_camera(screen_pos: Vector2, camera: Camera2D):
	var top_left = camera.get_screen_center_position() - (camera.get_viewport_rect().size / 2)
	var world_pos = top_left + screen_pos
	return world_pos

static func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)
	
