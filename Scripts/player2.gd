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
var punch_stun_timer = 0.6
var throw_stun_timer = 1.5
var stun_timer = 0
var am_hit = 0
var things_hit
var other_player
var am_rolling = false
var am_thrown = false

# Called when the node enters the scene tree for the first time.
func _ready():
	other_player = self.get_parent().find_node("player1")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_player(delta)

func animate(animation):
	self.find_node("running").visible = false
	self.find_node("standing").visible = false
	self.find_node("punching").visible = false
	self.find_node("hurt").visible = false
	self.find_node("rolling").visible = false
	self.find_node("thrown").visible = false
	self.find_node(animation).visible = true
	self.find_node(animation).flip_h = dir
	
# Controls inputs and calls physics commands
func move_player(delta):
	if !am_hit && !am_rolling && !am_thrown:
		if !attacking:
			control_right()
			control_left()
			control_move()
		control_jumping()
		control_attacking(delta)
	if !am_rolling && !am_thrown:
		control_falling()
	control_hurting(delta)
	if self.find_node("rolling").cur_frame == self.find_node("rolling").total_frames - 1:
		am_rolling = false

func control_right():
	moving_right = false
	if Input.is_key_pressed(KEY_RIGHT):
		moving_right = true
		move_and_slide(Vector2(speed_default*60, 0))
		self.global_position += Vector2(-0.1, -0.5)
		dir = 0

func control_left():
	moving_left = false
	if Input.is_key_pressed(KEY_LEFT):
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
	if Input.is_key_pressed(KEY_UP) && grounded && !attacking:
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

func get_hit(which_attack):
	am_hit = which_attack
	self.find_node("thrown").cur_frame = 0

func control_punched():
	animate("hurt")
	if stun_timer > punch_stun_timer:
		am_hit = 0
		stun_timer = 0

func control_thrown():
	animate("thrown")
	self.global_position = other_player.global_position
	if stun_timer > throw_stun_timer:
		self.find_node("hurt_box").disabled = false
		am_thrown = false
		am_hit = 0
		stun_timer = 0

func control_hurting(delta):
	stun_timer += delta
	if am_hit == 1:
		control_punched()
	elif am_hit == 2:
		am_thrown = true
		self.find_node("hurt_box").disabled = true
		control_thrown()
	

func hit_opponent(which_attack):
	other_player.get_hit(which_attack)
	

func control_attacking(delta):
	if Input.is_key_pressed(KEY_CONTROL) && !attacking:
		attacking = 1
		attacking_timer = 0
		self.find_node("fist").find_node("fist_box").disabled = false
	if attacking:
		animate("punching")
		things_hit = self.find_node("fist").get_overlapping_bodies()
		if things_hit.find(other_player) != -1:
			if other_player.dir == self.dir:
				hit_opponent(2)
				self.animate("rolling")
				am_rolling = true
			else:
				hit_opponent(1)
			self.find_node("fist").find_node("fist_box").disabled = true
		attacking_timer += delta
		if attacking_timer < attack_time * 0.5:
			self.find_node("punching").frame = 0
		else:
			self.find_node("punching").frame = 1
		if attacking_timer > attack_time:
			attacking = 0
			attacking_timer = 0
	else:
		self.find_node("fist").find_node("fist_box").disabled = true