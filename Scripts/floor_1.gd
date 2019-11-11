extends Node2D

# Declare member variables here. Examples:
var elevator_leave_time = 3
var elevator_timer = 0
var left_elevator
var right_elevator
var player1
var player2
var next_floor = preload("res://Scenes/floor_2.tscn")
var shop_fronts = preload("res://Scenes/shop_front.tscn")
var shop_doors = preload("res://Scenes/door.tscn")
var num_levels = 9
var level_dif = 100
var num_shops_per_level = 4
var shops_dif = 250

# Called when the node enters the scene tree for the first time.
func _ready():
	left_elevator = self.find_node("left_elevator")
	right_elevator = self.find_node("right_elevator")
	player1 = self.find_node("player1")
	player2 = self.find_node("player2")
	player1.total_stuff = 0
	player1.current_stuff = 0
	player2.total_stuff = 0
	player2.current_stuff = 0
	create_shops()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if check_in_elevator():
		elevator_timer += delta
	if elevator_timer > elevator_leave_time:
		left_elevator.move_offscreen()
		right_elevator.move_offscreen()
	if elevator_timer > elevator_leave_time + 2:
		next_floor = next_floor.instance()
		get_parent().add_child(next_floor)
		next_floor.player1_left = (left_elevator.child == player1)
		next_floor.player2_left = (left_elevator.child == player2)
		next_floor.player1_right = (right_elevator.child == player1)
		next_floor.player2_right = (right_elevator.child == player2)
		next_floor.find_node("player1").total_stuff = player1.total_stuff
		next_floor.find_node("player1").current_stuff = 0
		next_floor.find_node("player2").total_stuff = player2.total_stuff
		next_floor.find_node("player2").current_stuff = 0
		get_tree().current_scene = next_floor
		get_parent().remove_child(self)

func create_shops():
	for i in range(num_levels):
		for j in range(num_shops_per_level):
			var cur_shop = shop_fronts.instance()
			var cur_door = shop_doors.instance()
			self.add_child(cur_shop)
			self.add_child(cur_door)
			cur_door.global_position = Vector2(575 + (j * shops_dif), 930 - (level_dif * i))
			cur_shop.global_position = Vector2(575 + (j * shops_dif), 930 - (level_dif * i))
			cur_shop.z_index = -10

func check_in_elevator():
	return player1.in_elevator || player2.in_elevator
