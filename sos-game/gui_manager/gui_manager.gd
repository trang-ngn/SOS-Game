class_name UiManager extends CanvasLayer

@onready var statistic = $StatisticBar
@onready var buttons: Control = $Buttons
@onready var dialogs: Control = $Dialogs

@onready var show_button: TextureButton = $ShowButton
@onready var hide_button: TextureButton = $Buttons/HideButton
@onready var back_button: TextureButton = $Buttons/BackButton
@onready var help_button: TextureButton = $Buttons/HelpButton
@onready var done_button: TextureButton = $Buttons/DoneButton
@onready var restart_button: TextureButton = $Buttons/RestartButton

@onready var result_dialog: ResultDialog = $ResultDialog
@onready var error_dialog: Control = $Dialogs/ErrorDialog
@onready var done_dialog: DoneDialog = $Dialogs/DoneDialog
@onready var done_hover_msg: TextureRect = $Dialogs/DoneHoverMsg

var button_dialog_map: Dictionary[TextureButton, Control]
var all_houses_covered: bool = false


func _ready() -> void:
	#_set_ui_visible(true)
	done_button.disabled = true

	button_dialog_map = {
		back_button: $Dialogs/BackDialog,
		help_button: $Dialogs/HelpDialog,
		done_button: $Dialogs/DoneDialog,
		restart_button: $Dialogs/RestartDialog
	}
	hide_button.pressed.connect(_on_hide_button_pressed)
	show_button.pressed.connect(_on_show_button_pressed)
	done_button.mouse_entered.connect(_on_done_button_entered)
	done_button.mouse_exited.connect(_on_done_button_exited)
	#result_dialog.show_solution_button_pressed.connect(_on_hide_button_pressed)

	for button in button_dialog_map:
		button.pressed.connect(_on_button_to_show_dialog_pressed.bind(button))


######################## statistic bar ########################
func update_statistic(number: int, total_number: int, coverage: int, total_coverage: int, total_cost: float) -> void:
	statistic.update_number(number, total_number)
	statistic.update_coverage(coverage, total_coverage)
	statistic.update_cost(total_cost)
	done_button.disabled = not (coverage == total_coverage)
	all_houses_covered = total_coverage == coverage


######################## ok done pressed ########################
func show_error_dialog() -> void:
	error_dialog.visible = true


func show_result_dialog(optimal_solution: Solution, picked_stations: Array[bool], total_cost: float, are_all_houses_covered) -> void:
	result_dialog.set_results(optimal_solution, picked_stations, total_cost, are_all_houses_covered)
	_set_ui_visible(false)
	show_button.visible = false
	result_dialog.visible = true


######################## show / hide ########################
func _set_ui_visible(visible_state: bool):
	show_button.visible = not visible_state
	buttons.visible = visible_state
	dialogs.visible = visible_state
	statistic.visible = visible_state


func _on_hide_button_pressed() -> void:
	_set_ui_visible(false)


func _on_show_button_pressed() -> void:
	_set_ui_visible(true)


################## for dialogs (retart, back, help) ###################
func _on_button_to_show_dialog_pressed(button: TextureButton):
	button_dialog_map[button].visible = true


######################## hover done button ########################
func _on_done_button_entered() -> void:
	done_hover_msg.visible = not all_houses_covered


func _on_done_button_exited() -> void:
	done_hover_msg.visible = false
