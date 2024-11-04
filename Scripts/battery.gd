extends StaticBody3D

var flashlight_energy
var energy_add_amount = 0.5
var pickup_sound
var flashlight

# Called when the node enters the scene tree for the first time.
func _ready():
	flashlight = get_node("/root/" + get_tree().current_scene.name + '/Player/head/flashlight')
	pickup_sound = get_node("/root/" + get_tree().current_scene.name + "/Sounds/battery_pickup")
	flashlight_energy = get_node("/root/" + get_tree().current_scene.name + "/UI/flashlight_stuff/flashlight_slider")

func interact():
	if flashlight.picked_up == true:
		flashlight_energy.value += energy_add_amount
		pickup_sound.play()
		queue_free()
