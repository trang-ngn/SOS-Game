#class_name ResultDialog
extends Control

var chosen_stations: Array[int] = []


func show_results(optimal_solution: Solution, picked_stations: Array[bool], total_cost: float, all_houses_covered):
	var left_label: Label = $LeftLabel
	var right_label: Label = $RightLabel
	var score_label: Label = $HBoxContainer/ScoreLabel
	var success_label: Label = $HBoxContainer/SuccessLabel
	
	var percentage = _get_percentage(total_cost, optimal_solution.cost)
	var level_passed = percentage >= 80 and all_houses_covered;

	# Optimal solution
	chosen_stations = _get_chosen_station_indices(optimal_solution.selected)
	left_label.text = "-Used %d stations" % [optimal_solution.selected.count(true)] + "\n-Total cost %.1f€" % [optimal_solution.cost]
	left_label.text += "\n\nChosen stations: \n%s" % [chosen_stations]

	# Player solution
	chosen_stations = _get_chosen_station_indices(picked_stations)
	right_label.text = "-Used %d stations" % [picked_stations.count(true)] + "\n-Total cost %.1f€" % [total_cost]
	right_label.text += "\n\nChosen stations: \n%s" % [chosen_stations]

	#print(total_cost)

	score_label.text = "Score: %.f%%" % (percentage if all_houses_covered else 0.0)
	right_label.text += "\n\nNot all houses are covered!" if not all_houses_covered else ""
	success_label.text = "Success!!!" if level_passed else "FAILED!"

	_toogle_result_button(level_passed)


func _get_percentage(total_cost, optimal_cost)-> float:
	return float(optimal_cost) / total_cost * 100


func _get_chosen_station_indices(picked_stations: Array) -> Array[int]:
	var chosen_stations_indices: Array[int] = []

	for i in range(len(picked_stations)):
		if picked_stations[i]:
			chosen_stations_indices.append(i)

	return chosen_stations_indices


func _toogle_result_button(passed: bool):
	var next_level_button: TextureButton = $HBoxContainer/NextLevelButton
	var try_again_button: TextureButton = $HBoxContainer/TryAgainButton
	next_level_button.visible = passed
	try_again_button.visible = not passed
	pass
