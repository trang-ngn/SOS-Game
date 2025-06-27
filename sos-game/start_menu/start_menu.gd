extends Node2D

@onready var start_button: TextureButton = $Buttons/StartButton
@onready var sandbox_button: TextureButton = $Buttons/SandboxButton
@onready var help_button: TextureButton = $Buttons/HelpButton
@onready var info_button: TextureButton = $Buttons/InfoButton

@onready var help_dialog: Control = $Dialogs/HelpDialog
@onready var info_dialog: Control = $Dialogs/InfoDialog

var LEVEL_PICKER_SCENE: Resource = load("uid://bm0uygmmrbah5")

var SANDBOX_SCENE: Resource = load("uid://7ograaf1h64c")


func _ready() -> void:
	start_button.pressed.connect(_on_start_button_pressed)
	sandbox_button.pressed.connect(_on_sandbox_button_pressed)
	help_button.pressed.connect(_on_help_button_pressed)
	info_button.pressed.connect(_on_info_button_pressed)


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(LEVEL_PICKER_SCENE)


func _on_sandbox_button_pressed() -> void:
	get_tree().change_scene_to_packed(SANDBOX_SCENE)


func _on_help_button_pressed() -> void:
	help_dialog.visible = true


func _on_info_button_pressed() -> void:
	info_dialog.visible = true
