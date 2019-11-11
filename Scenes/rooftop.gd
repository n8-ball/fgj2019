extends Node2D

var pile1
var pile2
var timer=0
var score1 = 17
var score2 = 24

func _ready():
	pile1=find_node("Player_1_Pile")
	pile2=find_node("Player_2_Pile")

func _process(delta):
	timer+=delta
	if(timer>0.2):
		timer=0	
		#add items to each stack
		pass