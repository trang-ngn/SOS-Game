extends Control  

func _ready():
	visible = false  

func _on_ok_button_pressed() -> void:
	get_tree().reload_current_scene()
	Buildings.houses_data.clear()
	Buildings.stations_data.clear()


func _on_close_button_pressed() -> void:
	visible = false


func _on_cancel_button_pressed() -> void:
	visible = false


func _on_back_button_pressed() -> void:
	visible = true


func _on_restart_button_pressed() -> void:
	visible = true
