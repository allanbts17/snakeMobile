extends Node

# Global variables
const BOARD_POS = {
	Vector2(0,0):Vector2(21.5,21.5),
	Vector2(0,1):Vector2(21.5,64.5),
	Vector2(0,2):Vector2(21.5,107.5),
	Vector2(0,3):Vector2(21.5,150.5),
	Vector2(0,4):Vector2(21.5,193.5),
	Vector2(0,5):Vector2(21.5,236.5),
	Vector2(0,6):Vector2(21.5,279.5),
	Vector2(0,7):Vector2(21.5,322.5),
	Vector2(0,8):Vector2(21.5,365.5),
	Vector2(0,9):Vector2(21.5,408.5),
	Vector2(0,10):Vector2(21.5,451.5),
	Vector2(0,11):Vector2(21.5,494.5),
	Vector2(0,12):Vector2(21.5,537.5),
	Vector2(0,13):Vector2(21.5,580.5),
	Vector2(0,14):Vector2(21.5,623.5),
	Vector2(0,15):Vector2(21.5,666.5),
	Vector2(1,0):Vector2(64.5,21.5),
	Vector2(1,1):Vector2(64.5,64.5),
	Vector2(1,2):Vector2(64.5,107.5),
	Vector2(1,3):Vector2(64.5,150.5),
	Vector2(1,4):Vector2(64.5,193.5),
	Vector2(1,5):Vector2(64.5,236.5),
	Vector2(1,6):Vector2(64.5,279.5),
	Vector2(1,7):Vector2(64.5,322.5),
	Vector2(1,8):Vector2(64.5,365.5),
	Vector2(1,9):Vector2(64.5,408.5),
	Vector2(1,10):Vector2(64.5,451.5),
	Vector2(1,11):Vector2(64.5,494.5),
	Vector2(1,12):Vector2(64.5,537.5),
	Vector2(1,13):Vector2(64.5,580.5),
	Vector2(1,14):Vector2(64.5,623.5),
	Vector2(1,15):Vector2(64.5,666.5),
	Vector2(2,0):Vector2(107.5,21.5),
	Vector2(2,1):Vector2(107.5,64.5),
	Vector2(2,2):Vector2(107.5,107.5),
	Vector2(2,3):Vector2(107.5,150.5),
	Vector2(2,4):Vector2(107.5,193.5),
	Vector2(2,5):Vector2(107.5,236.5),
	Vector2(2,6):Vector2(107.5,279.5),
	Vector2(2,7):Vector2(107.5,322.5),
	Vector2(2,8):Vector2(107.5,365.5),
	Vector2(2,9):Vector2(107.5,408.5),
	Vector2(2,10):Vector2(107.5,451.5),
	Vector2(2,11):Vector2(107.5,494.5),
	Vector2(2,12):Vector2(107.5,537.5),
	Vector2(2,13):Vector2(107.5,580.5),
	Vector2(2,14):Vector2(107.5,623.5),
	Vector2(2,15):Vector2(107.5,666.5),
	Vector2(3,0):Vector2(150.5,21.5),
	Vector2(3,1):Vector2(150.5,64.5),
	Vector2(3,2):Vector2(150.5,107.5),
	Vector2(3,3):Vector2(150.5,150.5),
	Vector2(3,4):Vector2(150.5,193.5),
	Vector2(3,5):Vector2(150.5,236.5),
	Vector2(3,6):Vector2(150.5,279.5),
	Vector2(3,7):Vector2(150.5,322.5),
	Vector2(3,8):Vector2(150.5,365.5),
	Vector2(3,9):Vector2(150.5,408.5),
	Vector2(3,10):Vector2(150.5,451.5),
	Vector2(3,11):Vector2(150.5,494.5),
	Vector2(3,12):Vector2(150.5,537.5),
	Vector2(3,13):Vector2(150.5,580.5),
	Vector2(3,14):Vector2(150.5,623.5),
	Vector2(3,15):Vector2(150.5,666.5),
	Vector2(4,0):Vector2(193.5,21.5),
	Vector2(4,1):Vector2(193.5,64.5),
	Vector2(4,2):Vector2(193.5,107.5),
	Vector2(4,3):Vector2(193.5,150.5),
	Vector2(4,4):Vector2(193.5,193.5),
	Vector2(4,5):Vector2(193.5,236.5),
	Vector2(4,6):Vector2(193.5,279.5),
	Vector2(4,7):Vector2(193.5,322.5),
	Vector2(4,8):Vector2(193.5,365.5),
	Vector2(4,9):Vector2(193.5,408.5),
	Vector2(4,10):Vector2(193.5,451.5),
	Vector2(4,11):Vector2(193.5,494.5),
	Vector2(4,12):Vector2(193.5,537.5),
	Vector2(4,13):Vector2(193.5,580.5),
	Vector2(4,14):Vector2(193.5,623.5),
	Vector2(4,15):Vector2(193.5,666.5),
	Vector2(5,0):Vector2(236.5,21.5),
	Vector2(5,1):Vector2(236.5,64.5),
	Vector2(5,2):Vector2(236.5,107.5),
	Vector2(5,3):Vector2(236.5,150.5),
	Vector2(5,4):Vector2(236.5,193.5),
	Vector2(5,5):Vector2(236.5,236.5),
	Vector2(5,6):Vector2(236.5,279.5),
	Vector2(5,7):Vector2(236.5,322.5),
	Vector2(5,8):Vector2(236.5,365.5),
	Vector2(5,9):Vector2(236.5,408.5),
	Vector2(5,10):Vector2(236.5,451.5),
	Vector2(5,11):Vector2(236.5,494.5),
	Vector2(5,12):Vector2(236.5,537.5),
	Vector2(5,13):Vector2(236.5,580.5),
	Vector2(5,14):Vector2(236.5,623.5),
	Vector2(5,15):Vector2(236.5,666.5),
	Vector2(6,0):Vector2(279.5,21.5),
	Vector2(6,1):Vector2(279.5,64.5),
	Vector2(6,2):Vector2(279.5,107.5),
	Vector2(6,3):Vector2(279.5,150.5),
	Vector2(6,4):Vector2(279.5,193.5),
	Vector2(6,5):Vector2(279.5,236.5),
	Vector2(6,6):Vector2(279.5,279.5),
	Vector2(6,7):Vector2(279.5,322.5),
	Vector2(6,8):Vector2(279.5,365.5),
	Vector2(6,9):Vector2(279.5,408.5),
	Vector2(6,10):Vector2(279.5,451.5),
	Vector2(6,11):Vector2(279.5,494.5),
	Vector2(6,12):Vector2(279.5,537.5),
	Vector2(6,13):Vector2(279.5,580.5),
	Vector2(6,14):Vector2(279.5,623.5),
	Vector2(6,15):Vector2(279.5,666.5),
	Vector2(7,0):Vector2(322.5,21.5),
	Vector2(7,1):Vector2(322.5,64.5),
	Vector2(7,2):Vector2(322.5,107.5),
	Vector2(7,3):Vector2(322.5,150.5),
	Vector2(7,4):Vector2(322.5,193.5),
	Vector2(7,5):Vector2(322.5,236.5),
	Vector2(7,6):Vector2(322.5,279.5),
	Vector2(7,7):Vector2(322.5,322.5),
	Vector2(7,8):Vector2(322.5,365.5),
	Vector2(7,9):Vector2(322.5,408.5),
	Vector2(7,10):Vector2(322.5,451.5),
	Vector2(7,11):Vector2(322.5,494.5),
	Vector2(7,12):Vector2(322.5,537.5),
	Vector2(7,13):Vector2(322.5,580.5),
	Vector2(7,14):Vector2(322.5,623.5),
	Vector2(7,15):Vector2(322.5,666.5),
	Vector2(8,0):Vector2(365.5,21.5),
	Vector2(8,1):Vector2(365.5,64.5),
	Vector2(8,2):Vector2(365.5,107.5),
	Vector2(8,3):Vector2(365.5,150.5),
	Vector2(8,4):Vector2(365.5,193.5),
	Vector2(8,5):Vector2(365.5,236.5),
	Vector2(8,6):Vector2(365.5,279.5),
	Vector2(8,7):Vector2(365.5,322.5),
	Vector2(8,8):Vector2(365.5,365.5),
	Vector2(8,9):Vector2(365.5,408.5),
	Vector2(8,10):Vector2(365.5,451.5),
	Vector2(8,11):Vector2(365.5,494.5),
	Vector2(8,12):Vector2(365.5,537.5),
	Vector2(8,13):Vector2(365.5,580.5),
	Vector2(8,14):Vector2(365.5,623.5),
	Vector2(8,15):Vector2(365.5,666.5),
	Vector2(9,0):Vector2(408.5,21.5),
	Vector2(9,1):Vector2(408.5,64.5),
	Vector2(9,2):Vector2(408.5,107.5),
	Vector2(9,3):Vector2(408.5,150.5),
	Vector2(9,4):Vector2(408.5,193.5),
	Vector2(9,5):Vector2(408.5,236.5),
	Vector2(9,6):Vector2(408.5,279.5),
	Vector2(9,7):Vector2(408.5,322.5),
	Vector2(9,8):Vector2(408.5,365.5),
	Vector2(9,9):Vector2(408.5,408.5),
	Vector2(9,10):Vector2(408.5,451.5),
	Vector2(9,11):Vector2(408.5,494.5),
	Vector2(9,12):Vector2(408.5,537.5),
	Vector2(9,13):Vector2(408.5,580.5),
	Vector2(9,14):Vector2(408.5,623.5),
	Vector2(9,15):Vector2(408.5,666.5),
	Vector2(10,0):Vector2(451.5,21.5),
	Vector2(10,1):Vector2(451.5,64.5),
	Vector2(10,2):Vector2(451.5,107.5),
	Vector2(10,3):Vector2(451.5,150.5),
	Vector2(10,4):Vector2(451.5,193.5),
	Vector2(10,5):Vector2(451.5,236.5),
	Vector2(10,6):Vector2(451.5,279.5),
	Vector2(10,7):Vector2(451.5,322.5),
	Vector2(10,8):Vector2(451.5,365.5),
	Vector2(10,9):Vector2(451.5,408.5),
	Vector2(10,10):Vector2(451.5,451.5),
	Vector2(10,11):Vector2(451.5,494.5),
	Vector2(10,12):Vector2(451.5,537.5),
	Vector2(10,13):Vector2(451.5,580.5),
	Vector2(10,14):Vector2(451.5,623.5),
	Vector2(10,15):Vector2(451.5,666.5),
	Vector2(11,0):Vector2(494.5,21.5),
	Vector2(11,1):Vector2(494.5,64.5),
	Vector2(11,2):Vector2(494.5,107.5),
	Vector2(11,3):Vector2(494.5,150.5),
	Vector2(11,4):Vector2(494.5,193.5),
	Vector2(11,5):Vector2(494.5,236.5),
	Vector2(11,6):Vector2(494.5,279.5),
	Vector2(11,7):Vector2(494.5,322.5),
	Vector2(11,8):Vector2(494.5,365.5),
	Vector2(11,9):Vector2(494.5,408.5),
	Vector2(11,10):Vector2(494.5,451.5),
	Vector2(11,11):Vector2(494.5,494.5),
	Vector2(11,12):Vector2(494.5,537.5),
	Vector2(11,13):Vector2(494.5,580.5),
	Vector2(11,14):Vector2(494.5,623.5),
	Vector2(11,15):Vector2(494.5,666.5),
	Vector2(12,0):Vector2(537.5,21.5),
	Vector2(12,1):Vector2(537.5,64.5),
	Vector2(12,2):Vector2(537.5,107.5),
	Vector2(12,3):Vector2(537.5,150.5),
	Vector2(12,4):Vector2(537.5,193.5),
	Vector2(12,5):Vector2(537.5,236.5),
	Vector2(12,6):Vector2(537.5,279.5),
	Vector2(12,7):Vector2(537.5,322.5),
	Vector2(12,8):Vector2(537.5,365.5),
	Vector2(12,9):Vector2(537.5,408.5),
	Vector2(12,10):Vector2(537.5,451.5),
	Vector2(12,11):Vector2(537.5,494.5),
	Vector2(12,12):Vector2(537.5,537.5),
	Vector2(12,13):Vector2(537.5,580.5),
	Vector2(12,14):Vector2(537.5,623.5),
	Vector2(12,15):Vector2(537.5,666.5),
	Vector2(13,0):Vector2(580.5,21.5),
	Vector2(13,1):Vector2(580.5,64.5),
	Vector2(13,2):Vector2(580.5,107.5),
	Vector2(13,3):Vector2(580.5,150.5),
	Vector2(13,4):Vector2(580.5,193.5),
	Vector2(13,5):Vector2(580.5,236.5),
	Vector2(13,6):Vector2(580.5,279.5),
	Vector2(13,7):Vector2(580.5,322.5),
	Vector2(13,8):Vector2(580.5,365.5),
	Vector2(13,9):Vector2(580.5,408.5),
	Vector2(13,10):Vector2(580.5,451.5),
	Vector2(13,11):Vector2(580.5,494.5),
	Vector2(13,12):Vector2(580.5,537.5),
	Vector2(13,13):Vector2(580.5,580.5),
	Vector2(13,14):Vector2(580.5,623.5),
	Vector2(13,15):Vector2(580.5,666.5),
	Vector2(14,0):Vector2(623.5,21.5),
	Vector2(14,1):Vector2(623.5,64.5),
	Vector2(14,2):Vector2(623.5,107.5),
	Vector2(14,3):Vector2(623.5,150.5),
	Vector2(14,4):Vector2(623.5,193.5),
	Vector2(14,5):Vector2(623.5,236.5),
	Vector2(14,6):Vector2(623.5,279.5),
	Vector2(14,7):Vector2(623.5,322.5),
	Vector2(14,8):Vector2(623.5,365.5),
	Vector2(14,9):Vector2(623.5,408.5),
	Vector2(14,10):Vector2(623.5,451.5),
	Vector2(14,11):Vector2(623.5,494.5),
	Vector2(14,12):Vector2(623.5,537.5),
	Vector2(14,13):Vector2(623.5,580.5),
	Vector2(14,14):Vector2(623.5,623.5),
	Vector2(14,15):Vector2(623.5,666.5)
}
const BOARD_OFFSET = Vector2(37,137)
const BOARD_SQUARES = Vector2(15,16)
const SQUARE_SIZE = Vector2(43,43)

var speed
var end_speed
var velocity
var end_velocity
var solaped_board_squares = []
var direction = 'right'
var run = false
var invincibility = false
var body_invincibility = true
# var pixels_to_enlarge: float = 20
# var board_size = Vector2(645.75,687.45)

#atract power
var atracting = false
var atract_velocity = 5
var apple_normal_pos
var scarce_normal_pos

#slow down power
var slow_down = false
var speed_divider = 0.5
var temporal_speed

onready var apple: Area2D #= get_node("/root/main/game/game_board/food/apple")
onready var scarce: Area2D #= get_node("/root/main/game/game_board/food/scarce")
onready var freeze_player: AnimationPlayer #= get_node("/root/main/game/game_board/freeze_effect/AnimationPlayer")
onready var sfx: Node2D #= get_node("/root/main/game/sfx")

# Screens
onready var game: Node2D #= get_node("/root/main/game")
onready var start_screen: Control = get_node("/root/main/start_screen")

#Scores
var apple_score = 1
var scarce_max_score = 10
var mouse_score = 15

#Hide time
var scarce_hide_time = 5 #5
var power_up_hide_time = 10
var mouse_hide_time = 20

var mouse_trayectory = []

# Power up counter
var power_up_counter = {
	"attract":0,
	"cut":0,
	"invincibility":0,
	"slow_down":0
}

# Power up active
var power_up_is_active = "" #"" if no power up is active
var power_up_active_time = 7 #puede ser 5

var cut_percentage = 0.60
var hide_position = Vector2(-500,-500)
onready var main =  get_node("/root/main")

var score = 0
var max_score = 0

func setPathNodes():
	apple = get_node("/root/main/game/game_board/food/apple")
	scarce = get_node("/root/main/game/game_board/food/scarce")
	freeze_player = get_node("/root/main/game/game_board/freeze_effect/AnimationPlayer")
	sfx = get_node("/root/main/game/sfx")
	game = get_node("/root/main/game")


func set_init_data():
	solaped_board_squares = []
	direction = 'right'
	invincibility = false
	body_invincibility = true
	atracting = false
	apple_normal_pos = null
	scarce_normal_pos = null
	slow_down = false
	temporal_speed = null
	power_up_is_active = ""
	power_up_counter = {
	"attract":0,
	"cut":0,
	"invincibility":0,
	"slow_down":0
}


func _ready():
	pass # Replace with function body.
	
func on_before_atract_food_pos():
	if apple_normal_pos == null:
		apple_normal_pos = apple.position
	if scarce_normal_pos == null:
		scarce_normal_pos = scarce.position


func reset_food_pos():
	if apple_normal_pos != null:
		apple.position = apple_normal_pos
	if scarce_normal_pos != null:
		scarce.position = scarce_normal_pos

	
func active_power_up(power):
	#if power_up_counter[power] > 0:
	#	power_up_counter[power] -= 1
	power_up_is_active = power
	sfx.power_sound(power,true)
	match power:
		"attract":
			var atract_effect: Sprite =  get_node("/root/main/game/game_board/head/atract_effect")
			atract_effect.visible = true
			atracting = true
			pass
		"cut":
			game.snake_size = game.get_snake_size()
			game.cutting = true
			end_speed = speed*3
		"invincibility":
			invincibility = true
			game.make_transparent()
		"slow_down":
			freeze_player.play("show")
			# slow_down = true
			temporal_speed = speed
			speed = speed * speed_divider
			end_speed = speed
			pass
	print(power)
	
func power_finished():
	sfx.power_sound(power_up_is_active,false)
	match power_up_is_active:
		"attract":
			var atract_effect: Sprite =  get_node("/root/main/game/game_board/head/atract_effect")
			atract_effect.visible = false
			atracting = false
			reset_food_pos()
			pass
		"cut":
			pass
		"invincibility":
			invincibility = false
			game.make_transparent()
		"slow_down":
			freeze_player.play("hide")
			speed = temporal_speed
			end_speed = speed
			pass
	power_up_is_active = ""
	
func start_game():
	main.add_game()
	setPathNodes()
	
func show_help():
	pass
	
func show_score():
	pass
	
func on_lose():
	var end_game = get_node("/root/main/game/end_game_interface")
	var ui_score: Label = end_game.get_node("hbox/vbox/Control/score")
	var ui_max_score: Label = end_game.get_node("hbox/vbox/Control/max_score")
	max_score = int(max(score,max_score))
	ui_score.set_text("Puntuación: "+str(score))
	ui_max_score.set_text("Puntuación máxima: "+str(max_score))
	end_game.visible = true
	score = 0

func go_to_main():
	set_init_data()
	game.queue_free()
	start_screen.visible = true
	
func restart_game():
	set_init_data()
	game.queue_free()
	start_game()
