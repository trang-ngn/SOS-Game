extends BaseDialog

@onready var cancel_button: Button = $CancelButton
@onready var ok_button : Button = $OkButton

var START_MENU_SCENE := load("uid://l2s0qubkbnbw")


func _ready() -> void:
	super._ready()
	cancel_button.pressed.connect(_on_cancel_button_pressed)
	ok_button.pressed.connect(_on_ok_button_pressed)


func _on_cancel_button_pressed() -> void:
	self.visible = false


func _on_ok_button_pressed() -> void:
	get_tree().change_scene_to_packed(START_MENU_SCENE)
