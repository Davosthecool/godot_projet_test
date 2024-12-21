extends CharacterBody2D

@export var speed = 400
@export var jump_power = 1000
var parent
var is_dead = false
var death_pos: Vector2

signal player_exited_screen

func die(death_position: Vector2):
	is_dead = true
	death_pos = death_position
	$CollisionShape2D.disabled = true
	$AnimatedSprite2D.play("death")
	
# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()
	position = parent.get_meta("spawn")
	position.y -= 100

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
	
	# gestion des animations
	if velocity.length() == 0:
		$AnimatedSprite2D.play("idle")

	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0
		$AnimatedSprite2D.play("run")
		
	move_and_slide()


func _on_visible_on_screen_notifier_2d_screen_exited():
	emit_signal("player_exited_screen")
