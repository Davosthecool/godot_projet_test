extends Control

var timerCD : float
var slideCdText : RichTextLabel
var slideCdContainer : HBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	slideCdContainer = $SlideCDContainer
	slideCdText = $SlideCDContainer/SlideCDText
	slideCdContainer.position = Vector2(10,5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	slideCdContainer.visible = timerCD > 0
	slideCdText.text = str(Utils.round_to_dec(timerCD,2))
