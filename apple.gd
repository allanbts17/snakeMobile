extends Area2D

var total_solaped_spaces = []
var total_spaces = []
onready var head = get_parent().get_node("head")
onready var score = get_tree().root.get_node("main").get_node("upper_interface/score")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#print("tree: ",score.get_name())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_apple_area_entered(area):
	Global.body_invincibility = false
	score.add_score(Global.apple_score)
	total_solaped_spaces.clear()
	total_spaces.clear()
	#total_solaped_spaces = [] + Global.solaped_board_squares
	fill_total_solaped_spaces()
	add_head_pos()
	add_food_pos()
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
		total_solaped_spaces.append(Global.board_pos[ind])
		
func add_head_pos():
	var head_ind = total_solaped_spaces.find(head.position)
	if head_ind == -1:
		total_solaped_spaces.append(head.position)
		
func add_food_pos():
	var food_ind = total_solaped_spaces.find(position)
	if food_ind == -1:
		total_solaped_spaces.append(position)

func filter_total_spaces():
	dict_to_array()
	
	for _pos in total_solaped_spaces:
		total_spaces.erase(_pos)
	#test()
		
func dict_to_array():
	for key in Global.board_pos:
		total_spaces.append(Global.board_pos[key])

func test():
	print('Finding spaces test')
	for x in total_solaped_spaces:
		print(total_spaces.find(x))
	#print(total_spaces)
