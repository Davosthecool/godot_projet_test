extends Sprite2D

@export var animation_tree : AnimationTree
@export var player : CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	self.flip_h = player.velocity.x < 0
	animation_tree.set("parameters/MoveY/blend_position",player.velocity.y)
