extends BaseDialog

@onready var cancel_button: Button = $CancelButton


func _ready() -> void:
	super._ready()
	cancel_button.pressed.connect(_on_cancel_button_pressed)


func _on_cancel_button_pressed() -> void:
	self.visible = false
