extends RayCast3D

var int_text
var last_hit

func _ready():
	int_text = get_node("/root/" + get_tree().current_scene.name + "/UI/interact_text")
	if int_text == null:
		int_text.visible = false 

func _process(_delta):
	if is_colliding():
		var hit = get_collider()
		if hit != null:
			if hit.has_method("interact"):
				int_text.visible = true
				if Input.is_action_just_pressed("interact"):
					hit.interact()
					if hit.has_method("scare"):
						last_hit = hit
						hit.scare()
			else:
				int_text.visible = false
		else:
			int_text.visible = false
	else:
		int_text.visible = false
		if last_hit != null && last_hit.has_method("scare"):
			last_hit.stop_scare()
