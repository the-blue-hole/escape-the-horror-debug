extends Node3D

var player

func _ready():
	player = get_node("/root/" + get_tree().current_scene.name + "/Player")

#e
func _process(_delta):
	get_tree().call_group("monster", "update_target_location", player.global_transform.origin)
