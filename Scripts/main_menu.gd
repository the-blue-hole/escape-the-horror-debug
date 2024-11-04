extends Control

func play():
	get_tree().change_scene_to_file("res://Scenes/level.tscn")

func escape():
	get_tree().quit()
