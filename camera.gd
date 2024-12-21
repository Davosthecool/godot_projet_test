extends Camera2D

@export var speed = 200 
var parent

# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()
	position = parent.get_meta("spawn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += speed * delta
