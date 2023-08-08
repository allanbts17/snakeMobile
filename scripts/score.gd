extends Control

onready var score_label = get_node("Label")
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_score_text(Global.score)

func set_score_text(text) -> void:
	score_label.text = str("Score ",text)

func add_score(score_sum) -> void:
	Global.score += score_sum
	set_score_text(Global.score)
	
func reset_score() -> void:
	Global.score = 0
	set_score_text(Global.score)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
