extends Control  

func _ready():
	visible = false  

func _on_ok_button_pressed() -> void:
	print("Ok button pressed!")
	get_tree().change_scene_to_file("res://Scenes/start.tscn")



func _on_close_button_pressed() -> void:
	visible = false


func _on_cancel_button_pressed() -> void:
	visible = false
