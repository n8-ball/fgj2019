extends Node2D

# Declare member variables here. Examples:
var rng = RandomNumberGenerator.new()
var x_speed
var y_speed
var rotate_speed
var item
var num_items = 10
var speed = 2
var mod = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	x_speed = rng.randf_range(-1 * speed , 1 * speed)
	y_speed = rng.randf_range(-1 * speed, 1 * speed)
	rotate_speed = rng.randf_range(0, 0.05)
	item = rng.randi_range(0, num_items-1)
	item = self.find_node(str(item))
	item.visible = true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.global_position += Vector2(x_speed*mod, y_speed*mod)
	self.rotate(rotate_speed*mod)
	item.modulate = Color(item.modulate.r, item.modulate.g, item.modulate.b, mod)
	mod -= 0.01
	if mod <= 0:
		self.get_parent().remove_child(self)
