extends KinematicBody2D

#Moving Defaults
var speed_default = 5
var dir = 0

#Falling Defaults
var fall_acceleration_default = 1
var max_fall_speed_default = 20

#Jumping
var jump_speed_default = 0.5
var jump_time_default = 15
var jump_short_hop_height = 0.3

var moving_right = 0
var moving_left = 0

#Jumping and falling
var falling = 0
var jumping = 0
var grounded = 0

#Attacking
var attack_time = 0.4
var attacking_timer = 0
var attacking = 0

#Attacking
var attacking_cooldown = 0.3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_player(delta)

# Controls inputs and calls physics commands
func move_player(delta):
	if !attacking:
		control_right()
		control_left()
		control_move()
	control_jumping()
	control_falling()
	control_attacking(delta)

func control_right():
	moving_right = false
	if Input.is_key_pressed(KEY_D):
		moving_right = true
		move_and_slide(Vector2(speed_default*60, 0))
		self.global_position += Vector2(-0.1, -0.5)
		dir = 0

func control_left():
	moving_left = false
	if Input.is_key_pressed(KEY_A):
		moving_left = true
		move_and_slide(Vector2(-speed_default*60, 0))
		self.global_position += Vector2(0.1, -0.5)
		dir = 1

func control_move():
	if (moving_right && moving_left) || (!moving_left && !moving_right):
		self.find_node("running").visible = false
		self.find_node("standing").flip_h = dir
		self.find_node("standing").visible = true
		self.find_node("punching").visible = false
	else:
		self.find_node("running").visible = true
		self.find_node("standing").visible = false
		self.find_node("punching").visible = false
		self.find_node("running").flip_h = dir

func control_jumping():
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
func control_attacking(delta):
	if Input.is_key_pressed(KEY_SPACE) && !attacking:
		attacking = 1
		attacking_timer = 0
	if attacking:
		attacking_timer += delta
		if attacking_timer < attack_time * 0.5:
			self.find_node("punching").frame = 0
		else:
			self.find_node("punching").frame = 1
		if attacking_timer > attack_time:
			attacking = 0
			attacking_timer = 0
		self.find_node("running").visible = false
		self.find_node("standing").visible = false
		self.find_node("punching").visible = true
		self.find_node("punching").flip_h = dir