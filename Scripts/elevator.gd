extends KinematicBody2D

# Declare member variables here. Examples:
var need_to_move = 900
var has_moved = 0
var speed_default = 5
var child = null
var childFound = false
var move_up = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if has_moved < need_to_move:
		self.global_position += Vector2(0, -speed_default)
		has_moved += speed_default
	else:
		self.find_node("entrance").disabled = false
	if self.find_node("entrance").disabled == false && !childFound:
		child = move_and_collide(Vector2(0,0))
	if child != null && !childFound:
		childFound = true
		child = child.get_collider()
	if childFound:
		child.global_position = self.global_position
		child.total_stuff += child.current_stuff
		child.current_stuff = 0
		child.in_elevator = true
	if move_up:
		self.global_position += Vector2(0, -speed_default)

func move_offscreen():
	move_up = true
