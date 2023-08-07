extends Area2D

var total_solaped_spaces = []
var total_spaces = []
onready var head = get_tree().root.get_node("main").get_node("game_board").get_node("head")
onready var score = get_tree().root.get_node("main").get_node("upper_interface/score")
onready var power_up = get_tree().root.get_node("main").get_node("game_board").get_node("power_ups")
onready var scarce = get_parent().get_node("scarce")
onready var sfx: Node2D = get_node("/root/main/sfx")

# Called when the node enters the scene tree for the first time.
func _ready():
	#print("tree: ",score.get_name())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_apple_area_entered(area):
	if area.get_name() == 'head':
		sfx.food_sound()
		if Global.atracting:
			Global.apple_normal_pos = null
		print(str('apple colisiona con ',area.get_name()))
		Global.body_invincibility = false
		score.add_score(Global.apple_score)
		total_solaped_spaces.clear()
		total_spaces.clear()
		#total_solaped_spaces = [] + Global.solaped_board_squares
		fill_total_solaped_spaces()
		add_head_pos()
		add_scarce_pos()
		add_food_pos()
		add_power_up()
		#add_mouse_trayectory()
		filter_total_spaces()
		reposition()
	
func reposition():
	total_spaces.shuffle()
	position = total_spaces[0]
	#Global.score += 1
	#if Global.score >= 5:
	#ssss	Global.run = false
		
func fill_total_solaped_spaces():
	for ind in Global.solaped_board_squares:
		total_solaped_spaces.append(Global.BOARD_POS[ind])
		
func add_head_pos():
	var head_ind = total_solaped_spaces.find(head.position)
	if head_ind == -1:
		total_solaped_spaces.append(head.position)
		
func add_scarce_pos():
	var scarce_ind = total_solaped_spaces.find(scarce.position)
	if scarce_ind == -1:
		total_solaped_spaces.append(scarce.position)
		
func add_food_pos():
	var food_ind = total_solaped_spaces.find(position)
	if food_ind == -1:
		total_solaped_spaces.append(position)
		
func add_power_up():
	var power_ind = total_solaped_spaces.find(power_up.position)
	if power_ind == -1:
		total_solaped_spaces.append(power_up.position)

func add_mouse_trayectory():
	for pos in Global.mouse_trayectory:
		var mouse_ind = total_solaped_spaces.find(pos)
		if mouse_ind == -1:
			total_solaped_spaces.append(pos)

func filter_total_spaces():
	dict_to_array()
	
	for _pos in total_solaped_spaces:
		total_spaces.erase(_pos)
	#test()
		
func dict_to_array():
	for key in Global.BOARD_POS:
		total_spaces.append(Global.BOARD_POS[key])

func test():
	print('Finding spaces test')
	for x in total_solaped_spaces:
		print(total_spaces.find(x))
	#print(total_spaces)
