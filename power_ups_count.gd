extends Node2D


func _ready():
	pass 

func add(power):
	Global.power_up_counter[power] += 1
	var path = str(power)+"/Label"
	#$"slow_down/Label"
	print(path)
	get_node(path).text = str(Global.power_up_counter[power])
	
	
func substract(power):
	Global.power_up_counter[power] -= 1
	if Global.power_up_counter[power] < 0:
		Global.power_up_counter[power] = 0
	get_node(str(Global.power_up_counter[power])+"/Label").text = str(Global.power_up_counter[power])

