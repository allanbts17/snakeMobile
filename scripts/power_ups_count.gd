extends Node2D

var active_power = false
onready var progress_ring = {
	"attract":get_node("attract/TextureProgress"),
	"cut":get_node("cut/TextureProgress"),
	"invincibility":get_node("invincibility/TextureProgress"),
	"slow_down":get_node("slow_down/TextureProgress")
}
onready var tween = get_node("Tween")

func _ready():
	Global.power_up_counter["attract"] = 10
	pass
	
func _process(delta):
	inputs()

func inputs():
	if not active_power:
		if Input.is_action_just_pressed("1"):
			active("attract")
		elif Input.is_action_just_pressed("2"):
			active("cut")
		elif Input.is_action_just_pressed("3"):
			active("invincibility")
		elif Input.is_action_just_pressed("4"):
			active("slow_down")

func add(power):
	Global.power_up_counter[power] += 1
	var path = str(power)+"/Label"
	#$"slow_down/Label"
	#print(path)
	get_node(path).text = str(Global.power_up_counter[power])
	
	
func active(power) -> void:
	if Global.power_up_counter[power] > 0:
		Global.power_up_counter[power] -= 1
		
		#Set label value
		var path = str(power)+"/Label"
		get_node(path).text = str(Global.power_up_counter[power])
		Global.active_power_up(power)
		
		#Set active power
		active_power = true
		
		#Start ring animation
		tween.interpolate_property(progress_ring[power],"value",100,0,Global.power_up_active_time)
		tween.start()



func _on_Tween_tween_completed(object, key):
	active_power = false
	Global.power_finished()
	#print("Object: ",object.get_parent().get_name(),", key: ",key)
