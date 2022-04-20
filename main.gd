extends Node2D


onready var snake_body = get_node("snakeBody")
var snake_size
var initial_position
var initial_tail_position
export (int) var speed_index #2
var direction_list = []
var distance_to_next_center = 2
var distance_to_prev_center = 30
var is_far_from_prev_center
var reach_board_square_ind = [null,null]

# Called when the node enters the scene tree for the first time.
func _ready():
	snake_body.position = Global.board_offset
	initial_position = Global.board_pos[Vector2(3,3)]
	initial_tail_position = Global.board_pos[Vector2(1,3)]
	var v = [2,3,5,6]
	print(Vector2(0,25).normalized(),' norm')
	#print('orginal: ',v)
	#v.insert(1,10)
	#print('with 10 on 1: ',v)

	reset_snake_body()
	
	
	#print("Count")
	#print(snake_body.get_point_count())
	#print(snake_body.points)
	var snake_size = get_snake_size()
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
	
func reach_point_to_board_square(point) -> bool:
	var indx = round_place(((snake_body.points[point].x + Global.square_size.x/2)/Global.square_size.x)-1,2)
	var indy = round_place(((snake_body.points[point].y + Global.square_size.y/2)/Global.square_size.y)-1,2)
	var reached = false
	if is_int(round_almost_int(indx,0.05)) and is_int(round_almost_int(indy,0.05)):
		var index = Vector2(round_almost_int(indx,0.05),round_almost_int(indy,0.05))
		if reach_board_square_ind[point] != index and reach_board_square_ind[point] != null:
			reached = true
		reach_board_square_ind[point] = index
	return reached
	
func reach_board_square():
	if reach_point_to_board_square(0):
		Global.solaped_board_squares.push_back(reach_board_square_ind[0])
		
		if direction_list.size() > 0:
			Global.direction = direction_list[0]
			direction_list.pop_front()
			head_reposition(Global.direction)
			snake_body.set_point_position(1,Global.board_pos[reach_board_square_ind[0]])
			#print(snake_body.points)
	var dist = snake_body.points[-2].distance_to(snake_body.points[-1])
	if dist < 1:
		print('enter')
		#snake_body.remove_point(1)
		snake_body.remove_point(snake_body.get_point_count()-1)
		#snake_body.points.pop_back()
		print(snake_body.points)
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

func _process(delta):
	Global.speed = speed_index * 25
	Global.end_speed = Global.speed
	#print('delta: ',delta)
	inputs()
	change_velocity()
	move_snake(delta)
	reach_board_square()
	
	#print(Global.velocity * delta)
