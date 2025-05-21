extends Control  

func _ready():
	visible = false  


func _on_button_help_pressed() -> void:
	visible = true


func _on_button_close_pressed() -> void:
	visible = false
