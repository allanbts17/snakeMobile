extends Node2D


onready var snake_body = get_node("game_board/snakeBodyArea/snakeBody")
onready var snake_head = get_node("game_board/head")
onready var apple = get_node("game_board/food/apple")
onready var scarce = get_node("game_board/food/scarce")
#onready var apple = get_node("game_board/food/apple")
onready var sfx: Node2D = get_node("/root/main/sfx")

onready var test1 = get_node("game_board/test1")
onready var test2 = get_node("game_board/test2")
var snake_size
var initial_position
var initial_tail_position
export (int) var speed_index #2
var direction_list = []
var distance_to_next_center = 2
var distance_to_prev_center = 30
var is_far_from_prev_center
var reach_board_square_ind = [null,null]
var speed_step = 25
var tail_stop
var grow_step = 43
var tween
var cutting = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#snake_body.position = Global.BOARD_OFFSET
	randomize()
	Global.speed = speed_index * speed_step
	Global.end_speed = Global.speed
	
	initial_position = Global.BOARD_POS[Vector2(3,3)]
	initial_tail_position = Global.BOARD_POS[Vector2(1,3)]
	Global.solaped_board_squares = [Vector2(3,3),Vector2(2,3),Vector2(1,3)]
	#var v = [2,3,5,6]
	reset_snake_body()
	snake_size = get_snake_size()
	print('snake size: ',snake_size)
	
	var curve = snake_body.width_curve
	print('width curve: ',curve)
	tween = Tween.new()
	add_child(tween)
	
	#print(Vector2(20,15).distance_to(Vector2(0,0)))
	#v.push_back(10)
	#print('push back: ',v)
	#v.pop_front()
	#print('pop front: ',v)
	#print('orginal: ',v)
	#v.insert(1,10)
	#print('with 10 on 1: ',v)
	#print('ceil 3.6: ',ceil(3.6))
	#print("Count")
	#print(snake_body.get_point_count())
	#print(snake_body.points)

func make_transparent():
	var duration = 0.3
	var opacity = 0.5
	var trans_type = Tween.TRANS_LINEAR
	var ease_type = Tween.EASE_OUT
	if Global.invincibility:
		tween.interpolate_property(snake_body,"modulate",Color(1,1,1,1),Color(1,1,1,opacity),duration,trans_type,ease_type)
		tween.interpolate_property(snake_head,"modulate",Color(1,1,1,1),Color(1,1,1,opacity),duration,trans_type,ease_type)
	else:
		tween.interpolate_property(snake_body,"modulate",Color(1,1,1,opacity),Color(1,1,1,1),duration,trans_type,ease_type)
		tween.interpolate_property(snake_head,"modulate",Color(1,1,1,opacity),Color(1,1,1,1),duration,trans_type,ease_type)
	tween.start()
	 
func cut_body():
	if cutting:
		var percentage_reached = get_snake_size() - snake_size*(1-Global.cut_percentage) < 5
		var max_size_reached =  get_snake_size() <= 80
		var diff = get_snake_size() - snake_size*(1-Global.cut_percentage)
		print(diff)
		if percentage_reached or max_size_reached:
			print("finished")
			Global.end_speed = Global.speed
			cutting = false
	
func get_snake_size():
	var size = 0
	for i in range(snake_body.get_point_count()):
		if i > 0:
			size += snake_body.get_point_position(i).distance_to(snake_body.get_point_position(i-1))
	return size

func reset_snake_body():
	snake_body.clear_points()
	snake_body.add_point(initial_position)
	#var t = Vector2(initial_position.x-1,initial_position.y)
	#snake_body.add_point(t)
	snake_body.add_point(initial_tail_position)
	print('all points: ',snake_body.points)
	print('point: ',snake_body.points[0])
	
func reach_point_to_board_square(point,prec) -> bool:
	var indx = round_place(((snake_body.points[point].x + Global.SQUARE_SIZE.x/2)/Global.SQUARE_SIZE.x)-1,2)
	var indy = round_place(((snake_body.points[point].y + Global.SQUARE_SIZE.y/2)/Global.SQUARE_SIZE.y)-1,2)
	var reached = false
	if is_int(round_almost_int(indx,prec)) and is_int(round_almost_int(indy,prec)):
		var index = Vector2(round_almost_int(indx,prec),round_almost_int(indy,prec))
		if reach_board_square_ind[point] != index and reach_board_square_ind[point] != null:
			reached = true
			#print(reach_board_square_ind[point])
		reach_board_square_ind[point] = index
	return reached

func reach_board_square(_delta) -> void:
	if reach_point_to_board_square(0,0.05):
		Global.solaped_board_squares.push_back(reach_board_square_ind[0])
		
		if direction_list.size() > 0:
			Global.direction = direction_list[0]
			direction_list.pop_front()
			head_reposition(Global.direction)
			snake_body.set_point_position(1,Global.BOARD_POS[reach_board_square_ind[0]])
			#print(snake_body.points)
	if reach_point_to_board_square(-1,0.1):
		Global.solaped_board_squares.pop_front()
		test()
		#print(Global.solaped_board_squares)
	var dist = snake_body.points[-2].distance_to(snake_body.points[-1])
	if dist < ceil(Global.end_speed * _delta):
		snake_body.remove_point(snake_body.get_point_count()-1)
		pass

func change_velocity():
	Global.velocity = Vector2()
	Global.end_velocity = Vector2()
	if Global.direction == "right":
		Global.velocity.x += 1
	if Global.direction == "left":
		Global.velocity.x -= 1
	if Global.direction == "down":
		Global.velocity.y += 1
	if Global.direction == "up":
		Global.velocity.y -= 1
	
	Global.end_velocity = (snake_body.points[-2] - snake_body.points[-1]).normalized()
	#print('end: ',Global.end_velocity)
	if Global.velocity.length() > 0:
		Global.velocity = Global.velocity.normalized() * Global.speed
	if Global.end_velocity.length() > 0:
		Global.end_velocity *= Global.end_speed
	#print("end_velocity: ",Global.end_speed)

func head_reposition(direction):
	var new_pos = Global.BOARD_POS[reach_board_square_ind[0]]
	if direction == "right":
		new_pos.x += 1
	if direction == "left":
		new_pos.x -= 1
	if direction == "down":
		new_pos.y += 1
	if direction == "up":
		new_pos.y -= 1
	snake_body.add_point(new_pos,0) 

func is_int(num):
	return num - int(num) == 0

func round_place(num,places):
	return (round(num*pow(10,places))/pow(10,places))
	
func round_almost_int(num,diference):
	var int_part = int(num)
	var dec_part = num - int_part
	
	if num <= int_part+diference:
		return int_part
	elif num >= int_part+1-diference:
		return int_part+1
	else:
		return num

func move_snake(_delta):
	#for i in snake_body.get_point_count():
		#snake_body.points[i] += Global.velocity * _delta
	snake_body.points[0] += Global.velocity * _delta
	snake_body.points[-1] += Global.end_velocity * _delta

func move_head(_delta):
	snake_head.position = snake_body.points[0]
	head_orientation()

func inputs():
	if Input.is_action_just_pressed("ui_d"):
		change_direction('right')
	if Input.is_action_just_pressed("ui_a"):
		change_direction('left')
	if Input.is_action_just_pressed("ui_s"):
		change_direction('down')
	if Input.is_action_just_pressed("ui_w"):
		change_direction('up')
		
func change_direction(new_direction):
	if is_vertical(new_direction):
		if direction_list.size() == 0:
			if is_horizontal(Global.direction):
				if direction_list.size() < 2:
					direction_list.push_back(new_direction)
		else:
			if is_horizontal(direction_list[0]):
				if direction_list.size() < 2:
					direction_list.push_back(new_direction)
	else:
		if direction_list.size() == 0:
			if is_vertical(Global.direction):
				if direction_list.size() < 2:
					direction_list.push_back(new_direction)
		else:
			if is_vertical(direction_list[0]):
				if direction_list.size() < 2:
					direction_list.push_back(new_direction)
		#print(new_direction)
		#print(direction_list)
	
	
func is_vertical(direction):
	return direction == 'up' or direction == 'down'
	
func is_horizontal(direction):
	return direction == 'right' or direction == 'left'
	
func head_orientation():
	if Global.direction == "right" :
		snake_head.rotation_degrees = -90
	elif Global.direction == "left" :
		snake_head.rotation_degrees = 90
	elif Global.direction == "up" :
		snake_head.rotation_degrees = 180
	elif Global.direction == "down" :
		snake_head.rotation_degrees = 0
		
func test():
	var show = true
	if show and Global.solaped_board_squares.size() != 0:
		test1.position = Global.BOARD_POS[Global.solaped_board_squares[0]]
		test2.position = Global.BOARD_POS[Global.solaped_board_squares[-1]]
		
func tail_grow():
	if Global.end_speed == 0:
		var final_size = snake_size + grow_step
		if get_snake_size() >= final_size:
			Global.end_speed = Global.speed
			snake_size = get_snake_size()
			
func _process(delta):
	if Global.run:
		#print('delta: ',delta)
		inputs()
		change_velocity()
		move_head(delta)
		move_snake(delta)
		reach_board_square(delta)
		tail_grow()
		cut_body()
		atractObjects()
		#print(get_snake_size())
	
	
	#print(Global.velocity * delta)
	
func atractObjects():
	if Global.atracting:
		Global.on_before_atract_food_pos()
		var head_pos = snake_head.position
		var apple_distance = head_pos.distance_to(apple.position)
		var scarce_distance = head_pos.distance_to(scarce.position)
		if apple_distance <= Global.SQUARE_SIZE.x*2:
			apple.position += apple.position.direction_to(head_pos)*Global.atract_velocity
		if scarce_distance <= Global.SQUARE_SIZE.x*2:
			scarce.position +=  scarce.position.direction_to(head_pos)*Global.atract_velocity


func _on_apple_area_entered(area):
	var cut_power_activated = Global.power_up_is_active == "cut"
	if area.get_name() == 'head' and not cut_power_activated:
		Global.end_speed = 0


func _on_snakeBodyArea_area_entered(area):
	if area.get_name() == 'head':
		print('body colisiona con head')
		if !Global.body_invincibility and !Global.invincibility:
			sfx.lose_sound()
			Global.run = false
	


func _on_border_area_entered(area):
	if area.get_name() == 'head' and direction_list.size() == 0:
		print('border')
		if !Global.invincibility:
			sfx.lose_sound()
			Global.run = false
