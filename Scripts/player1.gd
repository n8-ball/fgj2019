extends KinematicBody2D

#Moving Defaults
var speed_default = 10
var decceleration_frames_default = 6
var acceleration_default = 0.15
var in_air_control_default = 0.1

#Falling Defaults
var fall_acceleration_default = 1
var max_fall_speed_default = 20

#Jumping
var jump_speed_default = 1
var jump_time_default = 25
var jump_short_hop_height = 0.3
var jump_decceleration_default = 4

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
	move_player(delta)
	

# Controls inputs and calls physics commands
func move_player(delta):
	#Move Right
	if Input.is_key_pressed(KEY_D):
		move_and_slide_with_snap(Vector2(speed_default/delta, 0), Vector2(0, 1))
		moving_right = decceleration_frames_default
	elif moving_right && (jumping || falling):
		move_and_slide_with_snap(Vector2(speed_default * acceleration_default * moving_right/delta, 0), Vector2(0, 1))
		moving_right -= 1
	#Move Left
	if Input.is_key_pressed(KEY_A):
		move_and_slide_with_snap(Vector2(-speed_default/delta, 0), Vector2(0, 1))
		moving_left = decceleration_frames_default
	elif moving_left:
		move_and_slide_with_snap(Vector2(-speed_default * acceleration_default * moving_right/delta, 0), Vector2(0, 1))
		moving_left -= 1
	#Jumping
	if Input.is_key_pressed(KEY_W) && grounded:
		jumping += 1
		falling = 0
		grounded = false
	elif jumping:
		self.global_position += Vector2(0, jump_speed_default*(jumping-jump_time_default));
		jumping += 1
		if jumping >= jump_time_default:
			jumping = 0
			falling = 1
		elif jumping > jump_time_default * jump_short_hop_height && !Input.is_key_pressed(KEY_W):
			jumping = 0
			falling = 1

	#Falling
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

	