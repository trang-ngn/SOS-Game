extends BaseDialog
class_name DoneDialog

@onready var cancel_button: Button = $CancelButton
@onready var ok_button : Button = $OkButton

signal done_ok_button_pressed


func _ready() -> void:
	super._ready()
	cancel_button.pressed.connect(_on_cancel_button_pressed)
	ok_button.pressed.connect(_on_ok_button_pressed)


func _on_cancel_button_pressed() -> void:
	self.visible = false


func _on_ok_button_pressed() -> void:
	emit_signal("done_ok_button_pressed")
	self.visible = false
