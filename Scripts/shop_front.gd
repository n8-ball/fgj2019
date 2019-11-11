extends Sprite

# Declare member variables here. Examples:
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	var red
	var green
	var blue
	var colorChoice = rng.randi_range(0, 2)
	if colorChoice == 0:
		red = 1
		green = rng.randf_range(.7, 1)
		blue = rng.randf_range(.7, 1)
	if colorChoice == 1:
		red = rng.randf_range(.7, 1)
		green = 1
		blue = rng.randf_range(.7, 1)
	if colorChoice == 2:
		red = rng.randf_range(.7, 1)
		green = rng.randf_range(.7, 1)
		blue = 1
	self.modulate = Color(red, green, blue)