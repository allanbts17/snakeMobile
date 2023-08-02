extends Area2D

var total_solaped_spaces = []
var total_spaces = []
onready var head = get_tree().root.get_node("main").get_node("game_board").get_node("head")
onready var score = get_tree().root.get_node("main").get_node("upper_interface/score")
onready var apple = get_parent().get_node("apple")
onready var fruits = get_node("Sprite")
onready var power_up = get_tree().root.get_node("main").get_node("game_board").get_node("power_ups")
onready var fruits_shadow = get_node("Sprite2")
onready var scarce_timer = get_node("show_timer")
onready var hide_timer = get_node("hide_timer")
onready var blinking = get_node("AnimationPlayer")
onready var animation_duration = 2
var wait_time_array = [2,4] #10,30
var wait_time
var fruit_frames = [0,1,2,3]
var fruit_frames_ind = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	position = Global.hide_position
	reset_show_timer()
	fruit_frames.shuffle()
	set_fruit_frame()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func set_fruit_frame():
	#print('enter here')
	fruits.frame = fruit_frames[fruit_frames_ind]
	fruits_shadow.frame = fruit_frames[fruit_frames_ind]
	if fruit_frames_ind == 3:
		fruit_frames.shuffle()
	frame_ind_increment()

func frame_ind_increment():
	if fruit_frames_ind < 3:
		fruit_frames_ind += 1
	else:
		fruit_frames_ind = 0

func reset_show_timer():
	position = Global.hide_position
	wait_time = round(rand_range(wait_time_array[0],wait_time_array[1]))
	scarce_timer.wait_time = wait_time
	scarce_timer.start()
	#print('scarce wait time: ',wait_time)

func search_new_position():
	total_solaped_spaces.clear()
	total_spaces.clear()
	#total_solaped_spaces = [] + Global.solaped_board_squares
	fill_total_solaped_spaces()
	add_head_pos()
	add_food_pos()
	add_scarce_pos()
	add_power_up()
	#add_mouse_trayectory()
	filter_total_spaces()

func _on_AnimationPlayer_animation_finished(anim_name):
	#print('hide')
	blinking.stop(true)
	modulate = Color( 1, 1, 1, 1 )
	reset_show_timer()
	set_fruit_frame()

func _on_hide_timer_timeout():
	blinking.play("blink")
	
func _on_show_timer_timeout():
	hide_timer.wait_time = Global.scarce_hide_time - animation_duration
	hide_timer.start()
	#print('timeout show')
	#score.add_score(Global.apple_score)
	search_new_position()
	reposition()

func _on_scarce_area_entered(area):
	if area.get_name() == 'head':
		if Global.atracting:
			Global.scarce_normal_pos = null
		print(str('scarce colisiona con ',area.get_name()))
		if not hide_timer.is_stopped():
			hide_timer.stop()
		else:
			blinking.stop(true)
			modulate = Color( 1, 1, 1, 1 )
		set_score()
		reset_show_timer()
		set_fruit_frame()
		
func set_score():
	var time_passed = Global.scarce_hide_time - (hide_timer.time_left + animation_duration)
	if blinking.is_playing():
		time_passed += blinking.get_current_animation_position()
	#print("Time passed: ",time_passed)
	var score_num = time_passed * Global.scarce_max_score / Global.scarce_hide_time
	score_num = clamp(round(score_num),1,Global.scarce_max_score)
	score.add_score(score_num)
	
func reposition():
	total_spaces.shuffle()
	position = total_spaces[0]
		
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
	var scarce_ind = total_solaped_spaces.find(position)
	if scarce_ind == -1:
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
