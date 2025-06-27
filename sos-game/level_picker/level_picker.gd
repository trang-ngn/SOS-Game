extends Control

@onready var back_button: TextureButton = $BackButton
@onready var help_button: TextureButton = $HelpButton
@onready var help_dialog: Control = $HelpDialog
@onready var level_buttons: Control = $LevelButtons

var START_MENU_SCENE := load("uid://l2s0qubkbnbw")
var LEVEL_SCENES := {
	1: preload("uid://xevvpwpugnd"),
	2: preload("uid://j5uig3ef0swi"),
	3: preload("uid://do75sb3gxxsyg"),
	4: preload("uid://bd57hgbps6n2"),
	5: preload("uid://mrj38kkxfhte"),
	6: preload("uid://bbl6mtw2tyt3"),
}


func _ready() -> void:
	back_button.pressed.connect(_on_back_button_pressed)
	help_button.pressed.connect(_on_help_button_pressed)
	for button in level_buttons.get_children():
		if button is TextureButton:
			button.pressed.connect(_on_level_button_pressed.bind(button))


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_packed(START_MENU_SCENE)


func _on_help_button_pressed() -> void:
	help_dialog.visible = true


func _on_level_button_pressed(button: TextureButton) -> void:
	var button_name: StringName = button.name
	var level_nr: int = button_name.right(1).to_int()

	if level_nr in LEVEL_SCENES.keys():
		get_tree().change_scene_to_packed(LEVEL_SCENES[level_nr])
