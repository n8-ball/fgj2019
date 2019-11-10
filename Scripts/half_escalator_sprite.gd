extends Sprite

# Declare member variables here. Examples:
var total_frames = 3
var cur_frame = 0
var animation_speed = 0.05
var animation_timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	animate(delta)

func animate(delta):
	animation_timer += delta
	if animation_timer >= animation_speed:
		cur_frame -= 1
		animation_timer = 0
	if cur_frame < 0:
		cur_frame = total_frames - 1
	self.frame = cur_frame
