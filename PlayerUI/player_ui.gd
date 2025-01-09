extends Control

var timerCD : float
var elapsed : float

var slideCdText : RichTextLabel
var slideCdContainer : HBoxContainer
var timerLabel : RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	slideCdContainer = $SlideCDContainer
	slideCdText = $SlideCDContainer/SlideCDText
	timerLabel = $TimerLabel
	slideCdContainer.position = Vector2(10,5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	slideCdContainer.visible = timerCD > 0
	slideCdText.text = str(Utils.round_to_dec(timerCD,2))
	timerLabel.text = str(Utils.round_to_dec(elapsed,2))
