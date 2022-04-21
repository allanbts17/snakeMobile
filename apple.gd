extends Area2D

var total_solaped_spaces = []
var total_spaces = []
onready var head = get_parent().get_node("head")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_apple_area_entered(area):
	total_solaped_spaces.clear()
	total_spaces.clear()
	total_solaped_spaces = [] + Global.solaped_board_squares
	add_head_pos()
	add_food_pos()
	filter_total_spaces()
	reposition()
	
func reposition():
	total_spaces.shuffle()
	position = total_spaces[0]
	
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
		
func dict_to_array():
	for key in Global.board_pos:
		total_spaces.append(Global.board_pos[key])
	#print(total_spaces)
