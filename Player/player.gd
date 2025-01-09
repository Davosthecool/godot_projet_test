extends CharacterBody2D

var parent
var slide_cooldown : Timer
var hitbox_up : CollisionShape2D
var hitbox_down : CollisionShape2D

@export var run_speed = 400.0
@export var crouch_speed = 200.0
var speed : float
@export var jump_power = 1000.0
@export var slide_power = 800.0
@export var slide_decrease_power = 20.0
@export var slide_height_delta = 20.0
var actual_slide_speed = slide_power

var has_started = false
var can_slide = true
var player_states = Utils.PlayerState
var state = Utils.PlayerState.IDLE

var death_pos: Vector2

signal player_started
signal player_died
signal player_ended

func switch_hitbox(to_up: bool):
	var is_switching = true
	if to_up and $SpaceForUp.is_colliding():
		to_up = false
		is_switching = false

	hitbox_up.disabled = not to_up
	hitbox_down.disabled = to_up
	return is_switching
	
# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()
	hitbox_up = $Hitbox_up
	hitbox_down = $Hitbox_down
	slide_cooldown = $slide_cooldown
	speed = run_speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#print(Utils.PlayerState_data[state])
	
	if state == player_states.DEAD:
		emit_signal("player_died")
		velocity = Vector2(0,parent.get_meta('gravity',0))
		move_and_slide()
		return
	
	if state == player_states.ENDED:
		velocity = Vector2(0,velocity.y+parent.get_meta('gravity',0))
		move_and_slide()
		return
		
	# mort à l'interieur de l'ecran
	if Utils.is_colliding_with_layer(self,"enemies"):
		if is_on_floor_only():
			state = player_states.DEAD
			return
	
	# mort des bordures
	var pos = self.get_global_transform_with_canvas().get_origin()
	if not get_viewport_rect().has_point(pos):
		if not (pos.y<0 and pos.x>0):
			state = player_states.DEAD
			return
	
	# fin du niveau
	if $EndDetector.is_colliding():
		emit_signal("player_ended")
		state = player_states.ENDED
		return
	
	
	
	# gestion de la hauteur (gravité, saut)
	if not is_on_floor():
		velocity.y += parent.get_meta('gravity',0)
	elif Input.is_action_pressed("jump"):
		if switch_hitbox(true):
			velocity.y = -jump_power
		
	# gestion de la largeur (gauche, droite)
	var direction = Input.get_axis("move_backward","move_forward")
	if state==player_states.IDLE and direction != 0 :
		state = player_states.RUNNING
	velocity.x = direction * speed
	
	# gestion du slide et de l'accroupi
	if is_on_floor() and Input.is_action_pressed("crouch"):
		#crouch
		if velocity.x==0:
			switch_hitbox(false)
			speed = crouch_speed
			state = player_states.CROUCHING
			
		#slide
		else:
			
			#start_slide
			if can_slide and Input.is_action_just_pressed("crouch"):
				actual_slide_speed = slide_power
				slide_cooldown.start()
				can_slide = false
				state = player_states.SLIDING
				velocity.x = actual_slide_speed * direction
				switch_hitbox(false)
				
			#continue_slide
			elif state == player_states.SLIDING:
				actual_slide_speed = actual_slide_speed-slide_decrease_power
				if actual_slide_speed<0: actual_slide_speed=0
				velocity.x = actual_slide_speed * direction
		
	#End crouch
	if state == player_states.CROUCHING and not Input.is_action_pressed("crouch"):
		if switch_hitbox(true):
			speed = run_speed
			state = player_states.IDLE
		

	#End slide
	if state == player_states.SLIDING and (Input.is_action_just_released("crouch") or velocity.x == 0):
		state = player_states.IDLE
		if not switch_hitbox(true):
			speed = crouch_speed
			state = player_states.CROUCHING
			
			
		# crouch
		if Input.is_action_pressed("crouch"):
			speed = crouch_speed
			state = player_states.CROUCHING
		else:
			switch_hitbox(true)
	
	#Stop Running
	if state != player_states.CROUCHING and velocity.x == 0:
		state = player_states.IDLE
		
	move_and_slide()

func _input(event):
	if event is InputEventKey and not has_started:
		has_started = true
		emit_signal("player_started")

func _on_slide_cooldown_timeout():
	can_slide = true # Replace with function body.
