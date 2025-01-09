extends Camera2D

var move_speed: float = 200.0
@export var speed: float = 0.0

var parent

# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += speed * delta
