extends Control  

func _ready():
	visible = false  


func _on_help_button_pressed() -> void:
	visible = true


func _on_close_button_pressed() -> void:
	visible = false
