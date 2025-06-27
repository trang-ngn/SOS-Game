extends BaseDialog

@onready var cancel_button: Button = $CancelButton
@onready var ok_button : Button = $OkButton


func _ready() -> void:
	super._ready()
	cancel_button.pressed.connect(_on_cancel_button_pressed)
	ok_button.pressed.connect(_on_ok_button_pressed)


func _on_cancel_button_pressed() -> void:
	self.visible = false


func _on_ok_button_pressed() -> void:
	get_tree().reload_current_scene()
	#Buildings.houses_data.clear()
	#Buildings.stations_data.clear()
