extends Control
class_name BaseDialog

@onready var close_button: TextureButton = $CloseButton


func _ready() -> void:
	self.visible = false
	close_button.pressed.connect(_on_close_button_pressed)


func _on_close_button_pressed() -> void:
	self.visible = false
