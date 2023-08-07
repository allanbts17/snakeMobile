extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_p4_pressed():
	get_node("p4").modulate.a = 0.5

func _on_p3_pressed():
	get_node("p3").modulate.a = 0.5

func _on_p2_pressed():
	get_node("p2").modulate.a = 0.5

func _on_p1_pressed():
	get_node("p1").modulate.a = 0.5

func _on_p4_released():
	get_node("p4").modulate.a = 1

func _on_p3_released():
	get_node("p3").modulate.a = 1

func _on_p2_released():
	get_node("p2").modulate.a = 1

func _on_p1_released():
	get_node("p1").modulate.a = 1
