extends KinematicBody2D

#Moving Defaults
var speed_default = 5
var dir = 0

#Falling Defaults
var fall_acceleration_default = 1
var max_fall_speed_default = 20

#Jumping Defaults
var jump_speed_default = 0.5
var jump_time_default = 15
var jump_short_hop_height = 0.3

#Moving
var moving_right = 0
var moving_left = 0

#Jumping and falling
var falling = 0
var jumping = 0
var grounded = 0

#Attacking
var other_player
var attacking = 0
var attacking_frames = 20
var rolling = 0
var throwing = 0
var thrown_frames = 60
var throw_start = 40
var throw_dir = 0
var throw_speed = 40
var when_to_slide = 0.3


#Score
var total_stuff
var current_stuff
var in_elevator = false

# Called when the node enters the scene tree for the first time.
func _ready():
	other_player = get_parent().find_node("player2")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_player()
	move_hands()

func move_hands():
	if dir == 0:
		self.find_node("fist").find_node("fist_box").position = Vector2(12, -26)
	else:
		self.find_node("fist").find_node("fist_box").position = Vector2(-12, -26)

func animate(animation):
	self.find_node("running").visible = false
	self.find_node("standing").visible = false
	self.find_node("punching").visible = false
	self.find_node("rolling").visible = false
	self.find_node("throwing").visible = false
	self.find_node("sliding").visible = false
	self.find_node(animation).visible = true
	self.find_node(animation).flip_h = dir
	
# Controls inputs and calls physics commands
func move_player():
	if !rolling && !throwing:
		if!attacking:
			control_right()
			control_left()
			control_move()
		control_jumping()
		control_falling()
	if !rolling && !throwing:
		control_attacking()
	control_throwing()
	control_rolling()

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
		animate("standing")
	else:
		animate("running")

func control_jumping():
	if Input.is_key_pressed(KEY_W) && grounded && !attacking:
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

func set_throwing(passed_dir):
	throwing = 1
	throw_dir = passed_dir
	if passed_dir == 1:
		self.global_position += Vector2(throw_start, 0)
	else:
		self.global_position += Vector2(-throw_start, 0)
	other_player.animate("invisible")
	self.find_node("rolling").cur_frame = 0

func control_attacking():
	if Input.is_key_pressed(KEY_SPACE) && !attacking && !rolling:
		attacking += 1
	if attacking:
		self.find_node("fist").find_node("fist_box").disabled = false
		var overlapping_bodies = self.find_node("fist").get_overlapping_bodies()
		attacking += 1
		animate("punching")
		if attacking < attacking_frames / 2:
			self.find_node("punching").frame = 0
		else:
			self.find_node("punching").frame = 1
		if other_player in overlapping_bodies:
			other_player.set_throwing(dir)
			rolling = 1
			self.animate("rolling")
			self.find_node("rolling").cur_frame = 0
			attacking = 0
		if attacking > attacking_frames:
			attacking = 0
	else:
		self.find_node("fist").find_node("fist_box").disabled = true

func control_throwing():
	if throwing:
		animate("invisible")
	if throwing == 1 && other_player.find_node("rolling").cur_frame == other_player.find_node("rolling").total_frames - 2:
		throwing = 2
	if throwing >= 2:
		throwing += 1
		animate("throwing")
		if throw_dir == 1:
			self.global_position += Vector2(throw_speed/throwing, 0)
		else:
			self.global_position += Vector2(-throw_speed/throwing, 0)
	if throwing > thrown_frames * when_to_slide:
		animate("sliding")
		self.find_node("sliding").flip_h = throw_dir
	if throwing > thrown_frames:
		throwing = 0

func control_rolling():
	if self.find_node("rolling").cur_frame == self.find_node("rolling").total_frames - 1:
		rolling = 0