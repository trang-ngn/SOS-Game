class_name Level
extends Node2D

var solution: Array[bool] = [false, false, true, true, true, true, false]
var picked: Array[bool] = []
var total_cost: float = 0

#make sure the houses and station are in order
@export var stations: Array[RescueStation]
@export var houses: Array[House]


func houses_covered()->bool: #check if all houses is covered
	for house in houses:
		if (!house.is_covered()):
			return false

	return true


func update_picked():
	var result: Array[bool] = []
	var cost: float = 0

	for station in stations:
		result.append(station.is_built())
		cost += station.cost if station.is_built() else 0

	total_cost = cost
	picked = result


#func _process(delta: float) -> void:
	#pass


func _on_button_button_up() -> void:
	update_picked()
	if (houses_covered()):
		print("Optimal solution : ")
		print_something(solution)
		print("Your solution : ")
		print_something(picked)

	else:
		print("Not all house is covered\n")


#cannot think of better name atm my bad
func print_something(array: Array[bool]) -> void:
	print("====================")
	var i: int = 0

	for value in array:
		print(str(i) + " : " + str(value))
		i += 1

	print("====================\n")


func _on_done_button_pressed() -> void:
	update_picked()
	print(stations)
	var left_label: Label = $PopupPanel/ResultDialog/LeftLabel
	var right_label: Label = $PopupPanel/ResultDialog/RightLabel
	var score_label: Label = $PopupPanel/ResultDialog/HBoxContainer/ScoreLabel
	var success_label: Label = $PopupPanel/ResultDialog/HBoxContainer/SuccessLabel
	var next_level_button: TextureButton = $PopupPanel/ResultDialog/HBoxContainer/NextLevelButton
	var try_again_button: TextureButton = $PopupPanel/ResultDialog/HBoxContainer/TryAgainButton
	var optimal_solution: Solution = await get_optimal_solution()

	if optimal_solution == null:
		print("Cannot get the solution!")
		return

	print(optimal_solution)

	left_label.text = "Optimal solution:\n" + "\n-Used %d stations" % [optimal_solution.selected.count(true)] + "\n-Total cost %.1f" % [optimal_solution.cost]

	right_label.text="Your solution:\n" + "\n-Used %d stations" % [picked.count(true)] + "\n-Total cost %.1f" % [total_cost]
	print(total_cost)
	var percentage = float(total_cost) / optimal_solution.cost * 100

	score_label.text = "Score: %.f%%" % percentage

	var all_houses_covered = houses_covered()

	right_label.text += "\n\nNot all houses are covered!" if not all_houses_covered else ""

	var level_passed = percentage >= 80 and all_houses_covered;

	success_label.text = "Success!!!" if level_passed else "FAILED!"
	next_level_button.visible = level_passed
	try_again_button.visible = not level_passed
	$PopupPanel.popup_centered()


func get_optimal_solution() -> Solution:
	var i: Instance = Instance.new()
	i.n = len(houses)

	for station in stations:
		i.costs.append(station.cost)
		i.coverage.append(station.get_covered_houses())

	var solution: Solution = await Resquest.get_solution(self, i)
	print(solution)
	return solution
