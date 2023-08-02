extends Area2D


var total_solaped_spaces = []
var total_spaces = []
onready var head = get_tree().root.get_node("main").get_node("game_board").get_node("head")
onready var apple = get_parent().get_node("food/apple")
onready var scarce = get_parent().get_node("food/scarce")
onready var show_timer = get_node("show_timer")
onready var hide_timer = get_node("hide_timer")
onready var blinking = get_node("AnimationPlayer")
onready var power_sprite = get_node("AnimatedSprite")
onready var power_up_count = get_tree().root.get_node("main").get_node("upper_interface").get_node("power_ups")

var power_ups_dict = {
	0:"attract",
	1:"cut",
	2:"invincibility",
	3:"slow_down"
}
var index_by_power = {
	"attract":0,
	"cut":1,
	"invincibility":2,
	"slow_down":3
}

var probability_distribution = {
	0:27,
	1:24,
	2:28,
	3:21
}

var power_up_range = {}

var selected_power
var power_show_max_time = 20
var wait_time_array = [2,6] #10,30
var wait_time
var animation_duration = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	#timer.start(5)
	randomize()
	set_power_up_range()
	set_power_up()
	reset_show_timer()
	#	set_power_up()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(show_timer.time_left)
	pass

func _on_power_ups_area_entered(area):
	if area.get_name() == 'head':
		print(str('power-up colisiona con ',area.get_name()))
		#Global.power_up_counter[selected_power] +=1
		power_up_count.add(selected_power)
		if not hide_timer.is_stopped():
			hide_timer.stop()
		else:
			blinking.stop(true)
			modulate = Color( 1, 1, 1, 1 )
		reset_show_timer()
		set_power_up()

func _on_show_timer_timeout():
	#print('show')
	hide_timer.wait_time = Global.power_up_hide_time - animation_duration
	hide_timer.start()
	#score.add_score(Global.apple_score)
	search_new_position()
	reposition()
	
func _on_AnimationPlayer_animation_finished(anim_name):
	blinking.stop(true)
	modulate = Color( 1, 1, 1, 1 )
	reset_show_timer()
	set_power_up()

func _on_hide_timer_timeout():
	#print('hide')
	blinking.play("blink")
	
func search_new_position():
	total_solaped_spaces.clear()
	total_spaces.clear()
	#total_solaped_spaces = [] + Global.solaped_board_squares
	fill_total_solaped_spaces()
	add_head_pos()
	add_food_pos()
	add_scarce_pos()
	#add_mouse_trayectory()
	filter_total_spaces()
	
func set_power_up():
	var power_ind = rand_range(0,100)
	set_power_by_range(power_ind)
	power_sprite.frame = index_by_power[selected_power]
	#reduce_range(selected_power,20)
	print('Power: ',selected_power,", ind: ",power_ind)

func set_power_by_range(number) -> void:
	if number <= power_up_range[0]:
		selected_power = power_ups_dict[0]
	elif number <= power_up_range[1]:
		selected_power = power_ups_dict[1]
	elif number <= power_up_range[2]:
		selected_power = power_ups_dict[2]
	else:
		selected_power = power_ups_dict[3]
	#test
	selected_power = power_ups_dict[0]

func set_power_up_range():
	for x in 4:
		if x == 0:
			power_up_range[x] = probability_distribution[x]
		else:
			power_up_range[x] = power_up_range[x-1] + probability_distribution[x]
	#print(power_up_range)

func reduce_range(power,value):
	var index = index_by_power[power]
	var other_power_value = value/3
	power_up_range[index] -= value
	for x in 4:
		if x != index:
			power_up_range[index] += other_power_value
			
func increase_range(power,value):
	var index = index_by_power[power]
	var other_power_value = value/3
	power_up_range[index] += value
	for x in 4:
		if x != index:
			power_up_range[index] -= other_power_value
	
	
func reset_show_timer():
	position = Global.hide_position
	wait_time = rand_range(wait_time_array[0],wait_time_array[1])
	show_timer.wait_time = wait_time
	show_timer.start()
	#print('power-up wait time: ',wait_time)
	
func reposition():
	total_spaces.shuffle()
	position = total_spaces[0]
	print('position: ',position)
		
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
		
func add_mouse_trayectory():
	for pos in Global.mouse_trayectory:
		var mouse_ind = total_solaped_spaces.find(pos)
		if mouse_ind == -1:
			total_solaped_spaces.append(pos)
		
func filter_total_spaces():
	dict_to_array()
	for _pos in total_solaped_spaces:
		total_spaces.erase(_pos)
		
func dict_to_array():
	for key in Global.BOARD_POS:
		total_spaces.append(Global.BOARD_POS[key])
