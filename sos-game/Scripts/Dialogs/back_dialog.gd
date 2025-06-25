extends Control  

func _ready():
	visible = false  

func _on_ok_button_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/start.tscn")

func _on_close_button_pressed() -> void:
	visible = false

func _on_cancel_button_pressed() -> void:
	visible = false

func _on_back_button_pressed() -> void:
	visible = true
