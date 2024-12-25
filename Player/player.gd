extends CharacterBody2D

var parent
var slide_cooldown : Timer
var hitbox_up : CollisionShape2D
var hitbox_down : CollisionShape2D

@export var run_speed = 400
@export var crouch_speed = 200
var speed
@export var jump_power = 1000
@export var slide_power = 800
@export var slide_decrease_power = 20
@export var slide_height_delta = 20
var actual_slide_speed = slide_power

var can_slide = true
var on_slide = false
var on_crouch = true
var is_dead = false


var death_pos: Vector2

signal player_exited_screen

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
	hitbox_up = $CollisionShape2D_up
	hitbox_down = $CollisionShape2D_down
	slide_cooldown = $slide_cooldown
	speed = run_speed
	position = parent.get_meta("spawn")
	position.y -= 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if is_dead:
		velocity = Vector2(0,parent.get_meta('gravity',0))
		move_and_slide()
		return
		
		
	# gestion de la hauteur (gravité, saut)
	if not is_on_floor():
		velocity.y += parent.get_meta('gravity',0)
	elif Input.is_action_pressed("jump"):
		if switch_hitbox(true):
			velocity.y = -jump_power
		
	# gestion de la largeur (gauche, droite)
	var direction = Input.get_axis("move_backward","move_forward")
	velocity.x = direction * speed
	
	# gestion du slide et de l'accroupi
	if is_on_floor() and Input.is_action_pressed("crouch"):
		#crouch
		if velocity.x==0:
			switch_hitbox(false)
			speed = crouch_speed
			on_crouch = true
			
		#slide
		else:
			
			#start_slide
			if can_slide and Input.is_action_just_pressed("crouch"):
				actual_slide_speed = slide_power
				slide_cooldown.start()
				can_slide = false
				on_slide = true
				velocity.x = actual_slide_speed * direction
				switch_hitbox(false)
				
			#continue_slide
			elif on_slide:
				actual_slide_speed = actual_slide_speed-slide_decrease_power
				if actual_slide_speed<0: actual_slide_speed=0
				velocity.x = actual_slide_speed * direction
		
	
	#End crouch
	if on_crouch and not Input.is_action_pressed("crouch"):
		if switch_hitbox(true):
			speed = run_speed
			on_crouch = false
		

	#End slide
	if on_slide and (Input.is_action_just_released("crouch") or velocity.x == 0):
		on_slide = false
		if not switch_hitbox(true):
			speed = crouch_speed
			on_crouch = true
			
		
		# crouch
		if Input.is_action_pressed("crouch"):
			speed = crouch_speed
			on_crouch = true
		else:
			switch_hitbox(true)
		
		
	move_and_slide()


func _on_visible_on_screen_notifier_2d_screen_exited():
	emit_signal("player_exited_screen")
	is_dead = true


func _on_slide_cooldown_timeout():
	can_slide = true # Replace with function body.
