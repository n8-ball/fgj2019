extends Node2D

# Declare member variables here. Examples:
var elevator_leave_time = 3
var elevator_timer = 0
var left_elevator
var right_elevator
var player1
var player2

# Called when the node enters the scene tree for the first time.
func _ready():
	left_elevator = self.find_node("left_elevator")
	right_elevator = self.find_node("right_elevator")
	player1 = self.find_node("player1")
	player2 = self.find_node("player2")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if check_in_elevator():
		elevator_timer += delta
	if elevator_timer > elevator_leave_time:
		left_elevator.move_offscreen()
		right_elevator.move_offscreen()
	if elevator_timer > elevator_leave_time + 2:
		get_tree().change_scene("res://Scenes/floor_1.tscn")

func check_in_elevator():
	return player1.in_elevator || player2.in_elevator
