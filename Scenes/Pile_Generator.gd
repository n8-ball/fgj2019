extends Node2D

var pile_size=200
var pile_1
var pile_2
var pile_1_theta = 0
var pile_2_theta = 0
var timer=0
var time_per_gift=1
var total_gifts_1=32
var total_gifts_2=24
var placed_gifts_1=0
var placed_gifts_2=0
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	#total_gifts_1 = self.get_parent().find_node("player1").total_stuff
	#total_gifts_2 = self.get_parent().find_node("player2").total_stuff
	pile_1 = self.get_parent().find_node("Player_1_Pile")
	pile_2 = self.get_parent().find_node("Player_2_Pile")
	if max(total_gifts_1,total_gifts_2)==0:
		time_per_gift = 0
	else:
		time_per_gift = 2.75/max(total_gifts_1,total_gifts_2)

func _process(delta):
	timer += delta
	if(timer > time_per_gift):
		timer = 0
		if placed_gifts_1 < total_gifts_1:
			add_to_pile_1()
			placed_gifts_1 += 1
		if placed_gifts_2 < total_gifts_2:
			add_to_pile_2()
			placed_gifts_2 += 1
		if(placed_gifts_1>=total_gifts_1 && placed_gifts_2>=total_gifts_2):
			end_game()
			self.get_parent().remove_child(self)

func add_to_pile_1():
	pile_1_theta+=rng.randf_range(-0.3,0.3)
	var gift = Sprite.new()
	gift.texture = load("res://Sprites/loot/item_"+str(rng.randi_range(0,9))+".png")
	gift.position.y = -placed_gifts_1*16
	gift.position.x = 40*sin(pile_1_theta)
	pile_1.add_child(gift)

func add_to_pile_2():
	pile_2_theta+=rng.randf_range(-0.3,0.3)
	var gift = Sprite.new()
	gift.texture = load("res://Sprites/loot/item_"+str(rng.randi_range(0,9))+".png")
	gift.position.y = -placed_gifts_2*16
	gift.position.x = 40*sin(pile_2_theta)
	pile_2.add_child(gift)

func end_game():
	var victory_message = self.get_parent().find_node("Victory_Message")
	if total_gifts_1==total_gifts_2:
		victory_message.texture=load("res://Sprites/tie_game.png")
	elif total_gifts_1>total_gifts_2:
		victory_message.texture=load("res://Sprites/player_1_wins.png")
	else: #total_gifts_1<total_gifts_2
		victory_message.texture=load("res://Sprites/player_2_wins.png")