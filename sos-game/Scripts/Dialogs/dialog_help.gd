extends Control  

func _ready():
	visible = false  

func _on_close_button_pressed() -> void:
	visible = false


func _on_button_help_pressed() -> void:
	visible = true
