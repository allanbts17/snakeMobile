extends Area2D

onready var snake_body = get_node("snakeBody")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var total_colliders = count_collision_shape()
	var total_snake_points = snake_body.get_point_count()
	create_mising_colliders(total_colliders,total_snake_points)
	for i in total_colliders:
		var coll_name = "coll_snake" + str(i)
		if i+1 < total_snake_points:
			collider_setting(get_node(coll_name),snake_body.points[i],snake_body.points[i+1],snake_body.width/2)
		else:
			get_node(coll_name).queue_free()
		

func collider_setting(collider,start_pos,final_pos,thick) -> void:
	collider.get_shape().radius = thick
	collider.get_shape().height = start_pos.distance_to(final_pos) - 2*thick
	collider.position = start_pos + (final_pos - start_pos)/2
	collider.rotation = start_pos.angle_to_point(final_pos) + PI/2
	
func count_collision_shape() -> int:
	var children = get_children()
	var count = 0
	for child in children:
		if child.get_class() == 'CollisionShape2D':
			count += 1
	return count
	
func create_mising_colliders(total_colliders,total_points) -> void:
	for i in range(total_colliders,total_points-1):
		var collider = CollisionShape2D.new()
		collider.set_shape(CapsuleShape2D.new())
		collider.set_name(str("coll_snake",i))
		add_child(collider)
