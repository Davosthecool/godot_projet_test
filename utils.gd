class_name Utils

enum PlayerState { IDLE, RUNNING, CROUCHING, SLIDING, JUMPING, DEAD, ENDED}
const PlayerState_data = {
	PlayerState.IDLE: "IDLE",
	PlayerState.RUNNING: "RUNNING",
	PlayerState.CROUCHING: "CROUCHING",
	PlayerState.SLIDING: "SLIDING",
	PlayerState.JUMPING: "JUMPING",
	PlayerState.DEAD: "DEAD",
	PlayerState.ENDED: "ENDED",
}

static func get_world_position_from_camera(screen_pos: Vector2, camera: Camera2D):
	var top_left = camera.get_screen_center_position() - (camera.get_viewport_rect().size / 2)
	var world_pos = top_left + screen_pos
	return world_pos

static func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)

static func get_physics_layers():
	var layers = {}
	for i in range(0, 5, 1):
		var layer = ProjectSettings.get_setting("layer_names/2d_physics/layer_" + str(i + 1))
		layers[layer] = pow(2, i)
	return layers

static func is_colliding_with_layer(player: CharacterBody2D, layer_name: String):
	
	if player.get_last_slide_collision():
		var layer
		if player.get_last_slide_collision().get_collider() is TileMapLayer:
			layer = player.get_last_slide_collision().get_collider().tile_set.get_physics_layer_collision_layer(0)
		elif player.get_last_slide_collision().get_collider() is CollisionObject2D:
			layer = player.get_last_slide_collision().get_collider().collision_layer
			
			
		if not get_physics_layers().get(layer_name,null):
			print("Layer Not Found")
			return false
		else:
			return get_physics_layers().get(layer_name,null) == layer
	return false
