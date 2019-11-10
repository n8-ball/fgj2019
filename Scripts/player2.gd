extends KinematicBody2D

#Moving Defaults
var speed_default = 5

#Falling Defaults
var fall_acceleration_default = 1
var max_fall_speed_default = 20

#Jumping
var jump_speed_default = 1
var jump_time_default = 15
var jump_short_hop_height = 0.3

var moving_right = 0
var moving_left = 0

#Jumping and falling
var falling = 0
var jumping = 0
var grounded = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_player()

# Controls inputs and calls physics commands
func move_player():
	control_right()
	control_left()
	control_jumping()
	control_falling()

func control_right():
	if Input.is_key_pressed(KEY_RIGHT):
		move_and_slide(Vector2(speed_default*60, 0))
		self.global_position += Vector2(-0.1, -0.5)
		self.find_node("running").set_dir(0)

func control_left():
	if Input.is_key_pressed(KEY_LEFT):
		move_and_slide(Vector2(-speed_default*60, 0))
		self.global_position += Vector2(0.1, -0.5)
		self.find_node("running").set_dir(1)

func control_jumping():
	if Input.is_key_pressed(KEY_UP) && grounded:
		jumping += 1
		falling = 0
		grounded = false
	elif jumping:
		self.global_position += Vector2(0, jump_speed_default*(jumping-jump_time_default));
		jumping += 1
		if jumping >= jump_time_default:
			jumping = 0
			falling = 1
		elif jumping > jump_time_default * jump_short_hop_height && !Input.is_key_pressed(KEY_UP):
			jumping = 0
			falling = 1

func control_falling():
	var cur_falling_speed = falling * fall_acceleration_default;
	if max_fall_speed_default < cur_falling_speed:
		cur_falling_speed = max_fall_speed_default;
	if !jumping && move_and_collide(Vector2(0, cur_falling_speed)) != null:
		grounded = true
		falling = 0
		jumping = 0
	elif falling:
		falling += 1
	else:
		falling = 1
	if !grounded && !falling && !jumping:
		falling += 1
