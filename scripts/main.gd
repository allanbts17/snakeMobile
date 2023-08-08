extends Node2D

# Screens

onready var start_screen = get_node("start_screen")


# Called when the node enters the scene tree for the first time.
func _ready():
	start_screen.visible = true
	
func add_game():
	var scene = preload("res://scenes/game.tscn")
	var game = scene.instance()
	game.set_name("game")
	add_child(game)
	start_screen.visible = false
	Global.run = true
