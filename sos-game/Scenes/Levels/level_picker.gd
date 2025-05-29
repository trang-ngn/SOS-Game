extends Node2D


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/start.tscn")


func _on_button_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/level_1_auto.tscn")
	

func _on_button_level_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/level_2_auto.tscn")


func _on_button_level_3_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/level_3_auto.tscn")
