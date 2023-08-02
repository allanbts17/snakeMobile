extends Area2D


var total_solaped_spaces = []
var total_spaces = []
onready var head = get_tree().root.get_node("main").get_node("game_board").get_node("head")
onready var apple = get_tree().root.get_node("main").get_node("game_board").get_node("food/apple")
onready var scarce = get_tree().root.get_node("main").get_node("game_board").get_node("food/scarce")
onready var power_up = get_tree().root.get_node("main").get_node("game_board").get_node("power_ups")
onready var score = get_tree().root.get_node("main").get_node("upper_interface/score")
onready var show_timer = get_node("show_timer")
onready var hide_timer = get_node("hide_timer")
onready var blinking = get_node("AnimationPlayer")
onready var tween = get_node("Tween")

var wait_time_array = [2,6] #10,30
var wait_time
var animation_duration = 2
var movement_range = [6,12]
var first_pos
var second_pos
var forward = true

func _ready():
	randomize()
	#set_movement()
	position = Global.hide_position
	#reset_show_timer()


func reset_show_timer():
	position = Global.hide_position
	wait_time = rand_range(wait_time_array[0],wait_time_array[1])
	show_timer.wait_time = wait_time
	show_timer.start()
#func _process(delta):
#	pass
func _on_Tween_tween_completed(object, key):
	#print("tween finished")
	#tween.stop_all()
	forward = not forward
	set_tween(forward)

func _on_show_timer_timeout():
	#print('show')
	hide_timer.wait_time = Global.power_up_hide_time - animation_duration
	hide_timer.start()
	#score.add_score(Global.apple_score)
	search_new_position()
	reposition()


func _on_hide_timer_timeout():
	blinking.play("blink")


func _on_mouse_area_entered(area):
	if area.get_name() == "head":
		if blinking.is_playing():
			blinking.stop(true)
		if not hide_timer.is_stopped():
			hide_timer.stop()
		score.add_score(Global.mouse_score)
		modulate = Color( 1, 1, 1, 1 )
		#if tween.is_active():
		tween.stop_all()
		forward = true
		Global.mouse_trayectory.clear()
		reset_show_timer()


func _on_AnimationPlayer_animation_finished(anim_name):
	blinking.stop(true)
	modulate = Color( 1, 1, 1, 1 )
	#if tween.is_active():
	tween.stop_all()
	forward = true
	Global.mouse_trayectory.clear()
	reset_show_timer()
	
func search_new_position():
	total_solaped_spaces.clear()
	total_spaces.clear()
	#total_solaped_spaces = [] + Global.solaped_board_squares
	fill_total_solaped_spaces()
	add_head_pos()
	add_food_pos()
	add_scarce_pos()
	add_power_up()
	filter_total_spaces()

func set_movement(point):
	var indx = round_place(((point.x + Global.SQUARE_SIZE.x/2)/Global.SQUARE_SIZE.x)-1,2)
	var indy = round_place(((point.y + Global.SQUARE_SIZE.y/2)/Global.SQUARE_SIZE.y)-1,2)
	var pos_vector = Vector2(indx,indy)
	#first_pos = Vector2(indx,indy)
	var left = 0
	var right = 0
	var up = 0
	var down = 0
	
	#test
	#total_spaces.erase(Global.BOARD_POS[Vector2(8,10)])
	#total_spaces.erase(Global.BOARD_POS[Vector2(10,10)])
	#total_spaces.erase(Global.BOARD_POS[Vector2(9,11)])
	
	#Counting spaces to obstacules
	for x in range(indx,Global.BOARD_SQUARES.x):
		if total_spaces.find(Global.BOARD_POS[Vector2(x,indy)]) != -1:
			right += 1
		else:
			break
	for x in range(indx,-1,-1):
		if total_spaces.find(Global.BOARD_POS[Vector2(x,indy)]) != -1:
			left += 1
		else:
			break
	for y in range(indy,Global.BOARD_SQUARES.y):
		if total_spaces.find(Global.BOARD_POS[Vector2(indx,y)]) != -1:
			down += 1
		else:
			break
	for y in range(indy,-1,-1):
		if total_spaces.find(Global.BOARD_POS[Vector2(indx,y)]) != -1:
			up += 1
		else:
			break
	
	#Check if distance is the minimun
	var minimun = false
	var directions_distances = [
		[left,false],
		[right,false],
		[up,false],
		[down,false]
	]
	#print(directions_distances)
	var passed_indexes = []
	for i in 4:
		if directions_distances[i][0] >= movement_range[0]:
			directions_distances[i][1] = true
			minimun = true
			passed_indexes.append(i)
	#print("before: ",directions_distances)
	#print("indexes: ",passed_indexes)
	#print()

	#Select between the possible distances and direction
	var selected_index
	var distance
	if minimun:
		var select_from_index_array = randi() % passed_indexes.size()
		selected_index = passed_indexes[select_from_index_array]
		#print("selected_index: ",select_from_index_array)
		distance = int(round(rand_range(movement_range[0],directions_distances[selected_index][0]))) - 1
	else:
		var max_value = 0
		for i in 4:
			if directions_distances[i][0] > max_value:
				max_value = directions_distances[i][0]
				selected_index = i
		distance = max_value - 1
	#print("distance: ",distance)
	
	#Set second position
	match selected_index:
		0: #left
			second_pos = Vector2(indx-distance,indy)
		1: #right
			second_pos = Vector2(indx+distance,indy)
		2: #up
			second_pos = Vector2(indx,indy-distance)
		3: #down
			second_pos = Vector2(indx,indy+distance)
	#print("pos: ",Vector2(indx,indy),", pos2: ",second_pos)
	first_pos = Vector2(indx,indy)
	#print("first_pos on set_movement: ",first_pos)
	
	#Set tween and the array to remove it from the avalaible spaces
	if not position == second_pos:
		fill_movement_array()
		set_tween(true)
		
func set_tween(forward):
	var velocity = 200
	#print("first_pos on tween: ",first_pos)
	var duration = abs(Global.BOARD_POS[first_pos].distance_to(Global.BOARD_POS[second_pos])) / velocity
	#print("duration: ",duration,", distance: ",first_pos.distance_to(second_pos))
	var trans_type = Tween.TRANS_LINEAR
	var ease_type = Tween.EASE_IN_OUT
	
	if second_pos.y - first_pos.y == 0:
		var second_greater = second_pos.x - first_pos.x > 0
		get_node("sprite").flip_h = (second_greater or forward) and (not second_greater or not forward)
		get_node("sprite2").flip_h = (second_greater or forward) and (not second_greater or not forward)
	
	if forward:
		tween.interpolate_property(self,"position",Global.BOARD_POS[first_pos],Global.BOARD_POS[second_pos],duration,trans_type,ease_type)
	else:
		tween.interpolate_property(self,"position",Global.BOARD_POS[second_pos],Global.BOARD_POS[first_pos],duration,trans_type,ease_type)
	tween.start()
	
func fill_movement_array():
	var diff = second_pos-first_pos
	
	#Global.mouse_trayectory.append(first_pos)
	if diff.x != 0:
		if diff.x > 0:
			for i in abs(diff.x)+1:
				var new_first_pos = Vector2(first_pos.x+i,first_pos.y)
				Global.mouse_trayectory.append(new_first_pos)
		else:
			for i in abs(diff.x)+1:
				var new_first_pos = Vector2(first_pos.x-i,first_pos.y)
				Global.mouse_trayectory.append(new_first_pos)
	else:
		if diff.y > 0:
			for i in abs(diff.y)+1:
				var new_first_pos = Vector2(first_pos.x,first_pos.y+i)
				Global.mouse_trayectory.append(new_first_pos)
		else:
			for i in abs(diff.y)+1:
				var new_first_pos = Vector2(first_pos.x,first_pos.y-i)
				Global.mouse_trayectory.append(new_first_pos)
	#print("trayectory: ",Global.mouse_trayectory)
	
	
func round_place(num,places):
	return (round(num*pow(10,places))/pow(10,places))
	
func reposition():
	#print(total_spaces)
	total_spaces.shuffle()
	position = total_spaces[0]
	#print('position: ',position)
	
	#test
	#position = Global.BOARD_POS[Vector2(9,10)]
	
	set_movement(position)
	#print()
		
func fill_total_solaped_spaces():
	for ind in Global.solaped_board_squares:
		total_solaped_spaces.append(Global.BOARD_POS[ind])
		
func add_head_pos():
	var head_ind = total_solaped_spaces.find(head.position)
	if head_ind == -1:
		total_solaped_spaces.append(head.position)
		
func add_food_pos():
	var apple_ind = total_solaped_spaces.find(apple.position)
	if apple_ind == -1:
		total_solaped_spaces.append(apple.position)
		
func add_scarce_pos():
	var scarce_ind = total_solaped_spaces.find(scarce.position)
	if scarce_ind == -1:
		total_solaped_spaces.append(scarce.position)
		
func add_power_up():
	var power_ind = total_solaped_spaces.find(power_up.position)
	if power_ind == -1:
		total_solaped_spaces.append(power_up.position)
		
func filter_total_spaces():
	dict_to_array()
	for _pos in total_solaped_spaces:
		total_spaces.erase(_pos)
		
func dict_to_array():
	for key in Global.BOARD_POS:
		total_spaces.append(Global.BOARD_POS[key])



