extends Area2D

# Declare member variables here. Examples:
var available = true
var player1
var player2
var touching_door

# Called when the node enters the scene tree for the first time.
func _ready():
	player1 = self.get_parent().find_node("player1")
	player2 = self.get_parent().find_node("player2")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if available:
		self.find_node("open").visible = true
		self.find_node("closed").visible = false
		touching_door = self.get_overlapping_bodies()
		if touching_door.find(player1) != -1:
			player1.current_stuff += 1
			available = false
			print(player1.total_stuff)
		if touching_door.find(player2) != -1:
			player2.current_stuff += 1
			available = false
			print(player2.total_stuff)
	else:
		self.find_node("open").visible = false
		self.find_node("closed").visible = true
