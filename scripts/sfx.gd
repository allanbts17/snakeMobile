extends Node2D


onready var p1 = get_node("p1")
onready var p2 = get_node("p2")
onready var p3 = get_node("p3")
onready var p4 = get_node("p4")
onready var eat_food = get_node("eat_food")
onready var eat_scarce = get_node("eat_scarce")
onready var pick_power = get_node("pick_power")
onready var lose = get_node("lose")

onready var power = get_parent().get_node("game_board/power_ups")


func food_sound():
	eat_food.play()
	
func scarce_sound():
	eat_scarce.play()

func pick_power_sound():
	pick_power.play()

func lose_sound():
	lose.play()

func power_sound(power: String, play: bool):
	if play:
		match power:
			"attract":
				p1.play()
			"cut":
				p2.play()
			"invincibility": 
				p3.play()
			"slow_down":
				p4.play()
	else:
		match power:
			"attract":
				p1.stop()
			"cut":
				p2.stop()
			"invincibility":
				p3.stop()
			"slow_down":
				p4.stop()
