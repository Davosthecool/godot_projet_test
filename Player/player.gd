extends CharacterBody2D

var parent
var slide_cooldown : Timer
var sprite : AnimatedSprite2D
var hitbox_up : CollisionShape2D
var hitbox_down : CollisionShape2D

@export var speed = 400
@export var jump_power = 1000
@export var slide_power = 800
@export var slide_decrease_power = 20
@export var slide_height_delta = 20
var actual_slide_speed = slide_power
var can_slide = true
var on_slide = false
var is_dead = false
var death_pos: Vector2

signal player_exited_screen

func switch_hitbox():
	hitbox_up.disabled = not hitbox_up.disabled
	hitbox_down.disabled = not hitbox_down.disabled
	
func die(death_position: Vector2):
	is_dead = true
	death_pos = death_position
	hitbox_up.disabled = true
	hitbox_down.disabled = true
	sprite.play("death")
	
# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()
	sprite = $AnimatedSprite2D
	hitbox_up = $CollisionShape2D_up
	hitbox_down = $CollisionShape2D_down
	slide_cooldown = $slide_cooldown
	
	position = parent.get_meta("spawn")
	position.y -= 100
	sprite.play("idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if is_dead:
		velocity = (death_pos - position).normalized() * speed
		if (position-death_pos).length() < 10:
			queue_free()
		else:
			move_and_slide()
			
		return
		
		
	# gestion de la hauteur (gravité, saut)
	if not is_on_floor():
		velocity.y += parent.get_meta('gravity',0)
	elif Input.is_action_pressed("jump"):
		velocity.y = -jump_power
		
	# gestion de la largeur (gauche, droite)
	var direction = Input.get_axis("move_backward","move_forward")
	velocity.x = direction * speed
	
	# gestion du slide
	if is_on_floor() and velocity.x !=0 and Input.is_action_pressed("crouch"):
		if can_slide and Input.is_action_just_pressed("crouch"):
			actual_slide_speed = slide_power
			slide_cooldown.start()
			can_slide = false
			on_slide = true
			velocity.x = actual_slide_speed * direction
			sprite.play("slide")
			switch_hitbox()
		elif on_slide:
			actual_slide_speed = actual_slide_speed-slide_decrease_power
			if actual_slide_speed<0: actual_slide_speed=0
			velocity.x = actual_slide_speed * direction
		
	if on_slide and (Input.is_action_just_released("crouch") or velocity.x == 0):
		on_slide = false
		sprite.play("slideEndTransition")
		switch_hitbox()
	
	# gestion des animations
	if velocity.length() == 0:
		sprite.play("idle")

	if velocity.x != 0:
		sprite.flip_h = velocity.x < 0
		
		if is_on_floor() and not on_slide:
			sprite.play("run")


	move_and_slide()


func _on_visible_on_screen_notifier_2d_screen_exited():
	emit_signal("player_exited_screen")


func _on_slide_cooldown_timeout():
	can_slide = true # Replace with function body.
