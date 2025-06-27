extends Control
class_name ResultDialog

@onready var left_label: Label = $Modal/LeftLabel
@onready var right_label: Label = $Modal/RightLabel
@onready var score_label: Label = $Modal/InfoContainer/ScoreLabel
@onready var success_label: Label = $Modal/InfoContainer/SuccessLabel

@onready var next_level_button: TextureButton = $Modal/InfoContainer/NextLevelButton
@onready var try_again_button: TextureButton = $Modal/InfoContainer/TryAgainButton
@onready var show_solution_button: TextureButton = $Modal/ShowSolutionButton
@onready var hide_solution_button: TextureButton = $HideSolutionButton
@onready var modal: Control = $Modal

var LEVEL_PICKER_SCENE: Resource = load("uid://bm0uygmmrbah5")

signal show_solution_button_pressed


func _ready() -> void:
	next_level_button.pressed.connect(_on_next_level_button_pressed)
	try_again_button.pressed.connect(_on_try_again_button_pressed)
	show_solution_button.pressed.connect(_on_show_solution_button_pressed)
	hide_solution_button.pressed.connect(_on_hide_solution_button_pressed)


func _on_next_level_button_pressed() -> void:
	get_tree().change_scene_to_packed(LEVEL_PICKER_SCENE)


func _on_try_again_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_show_solution_button_pressed() -> void:
	emit_signal("show_solution_button_pressed")
	modal.visible = false
	hide_solution_button.visible = true


func _on_hide_solution_button_pressed() -> void:
	modal.visible = true
	hide_solution_button.visible = false


func set_results(optimal_solution: Solution, picked_stations: Array[bool], total_cost: float, all_houses_covered):

	var percentage: float = _calculate_percentage(total_cost, optimal_solution.cost)
	var level_passed: bool = percentage >= 80 and all_houses_covered

	var is_optimal: bool = percentage == 100 and level_passed
	# Optimal solution
	var chosen_stations: Array[int] = _get_chosen_station_indices(optimal_solution.selected)
	left_label.text = "-Used %d stations" % [optimal_solution.selected.count(true)] + "\n-Total cost %.1f€" % [optimal_solution.cost]
	left_label.text += "\n\nChosen stations: \n%s" % [chosen_stations]

	# Player solution
	chosen_stations = _get_chosen_station_indices(picked_stations)
	right_label.text = "-Used %d stations" % [picked_stations.count(true)] + "\n-Total cost %.1f€" % [total_cost]
	right_label.text += "\n\nChosen stations: \n%s" % [chosen_stations]

	right_label.text += "\nOptimal!!!" if is_optimal else("\nAlmost optimal!" if level_passed else "\nNot optimal!")

	# print(total_cost)

	score_label.text = "Score: %.f%%" % (percentage if all_houses_covered else 0.0)
	right_label.text += "\n\nNot all houses are covered!" if not all_houses_covered else ""
	success_label.text = "Success!!!" if level_passed else "FAILED!"

	_toogle_result_button(level_passed)


func _calculate_percentage(total_cost, optimal_cost)-> float:
	return float(optimal_cost) / total_cost * 100


func _get_chosen_station_indices(picked_stations: Array) -> Array[int]:
	var chosen_stations_indices: Array[int] = []

	for i in range(len(picked_stations)):
		if picked_stations[i]:
			chosen_stations_indices.append(i)

	return chosen_stations_indices


func _toogle_result_button(passed: bool) -> void:
	next_level_button.visible = passed
	try_again_button.visible = not passed
