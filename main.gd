extends Node2D


onready var snake_body = get_node("game_board/snakeBody")
onready var snake_head = get_node("game_board/head")
onready var apple = get_node("game_board/apple")
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
var run = true
var tail_stop
var grow_step = 43
# Called when the node enters the scene tree for the first time.
func _ready():
	#snake_body.position = Global.board_offset
	randomize()
	Global.speed = speed_index * speed_step
	Global.end_speed = Global.speed
	initial_position = Global.board_pos[Vector2(3,3)]
	initial_tail_position = Global.board_pos[Vector2(1,3)]
	Global.solaped_board_squares = [Vector2(3,3),Vector2(2,3),Vector2(1,3)]
	var v = [2,3,5,6]
	#v.push_back(10)
	#print('push back: ',v)
	#v.pop_front()
	#print('pop front: ',v)
	#print('orginal: ',v)
	#v.insert(1,10)
	#print('with 10 on 1: ',v)
	#print('ceil 3.6: ',ceil(3.6))
	reset_snake_body()
	
	
	#print("Count")
	#print(snake_body.get_point_count())
	#print(snake_body.points)
	snake_size = get_snake_size()
	print('snake size: ',snake_size)
	#print(Vector2(20,15).distance_to(Vector2(0,0)))


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
	var indx = round_place(((snake_body.points[point].x + Global.square_size.x/2)/Global.square_size.x)-1,2)
	var indy = round_place(((snake_body.points[point].y + Global.square_size.y/2)/Global.square_size.y)-1,2)
	var reached = false
	if is_int(round_almost_int(indx,prec)) and is_int(round_almost_int(indy,prec)):
		var index = Vector2(round_almost_int(indx,prec),round_almost_int(indy,prec))
		if reach_board_square_ind[point] != index and reach_board_square_ind[point] != null:
			reached = true
			#print(reach_board_square_ind[point])
		reach_board_square_ind[point] = index
	return reached
	
func reach_board_square(_delta):
	if reach_point_to_board_square(0,0.05):
		Global.solaped_board_squares.push_back(reach_board_square_ind[0])
		
		if direction_list.size() > 0:
			Global.direction = direction_list[0]
			direction_list.pop_front()
			head_reposition(Global.direction)
			snake_body.set_point_position(1,Global.board_pos[reach_board_square_ind[0]])
			#print(snake_body.points)
	if reach_point_to_board_square(-1,0.1):
		Global.solaped_board_squares.pop_front()
		test()
		#print(Global.solaped_board_squares)
	var dist = snake_body.points[-2].distance_to(snake_body.points[-1])
	if dist < ceil(Global.speed * _delta):
		#print('enter')
		#snake_body.remove_point(1)
		snake_body.remove_point(snake_body.get_point_count()-1)
		#snake_body.points.pop_back()
		#print(snake_body.points)
	#print(dist)
		
	
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

func head_reposition(direction):
	var new_pos = Global.board_pos[reach_board_square_ind[0]]
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
		test1.position = Global.board_pos[Global.solaped_board_squares[0]]
		test2.position = Global.board_pos[Global.solaped_board_squares[-1]]
		
func tail_grow():
	if Global.end_speed == 0:
		var final_size = snake_size + grow_step
		if get_snake_size() >= final_size:
			Global.end_speed = Global.speed
			snake_size = get_snake_size()
			
func _process(delta):
	if run:
		#print('delta: ',delta)
		inputs()
		change_velocity()
		move_head(delta)
		move_snake(delta)
		reach_board_square(delta)
		tail_grow()
	
	
	#print(Global.velocity * delta)


func _on_apple_area_entered(area):
	#run = false
	print('solaped: ',Global.solaped_board_squares)
	Global.end_speed = 0
