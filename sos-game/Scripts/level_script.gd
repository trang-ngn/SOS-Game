class_name Level
extends Node2D

signal station_updated

#var solution: Array[bool] = [false, false, true, true, true, true, false]
var picked_stations: Array[bool] = []
var total_cost: float = 0.0
var all_houses_covered: bool = false
var num_covered_houses: int = 0
var num_picked_stations: int = 0

#make sure the houses and station are in order
@export var stations: Array[RescueStation]
@export var houses: Array[House]

func _ready() -> void:
	for station in stations:
		station.connect("stations_updated", Callable(self, "update_picked"))
	update_picked()

func update_houses_covered() -> void: #check if all houses is covered
	var num : int = 0
	for house in houses:
		if (house.is_covered()):
			num += 1
	num_covered_houses = num
	all_houses_covered = num_covered_houses == len(houses)


func update_picked():
	var result: Array[bool] = []
	var cost: float = 0.0
	var num: int = 0

	for station in stations:
		if station.is_built():
			cost += station.cost
			num += 1
		result.append(station.is_built())

	total_cost = cost
	picked_stations = result
	num_picked_stations = num
	update_houses_covered()
	update_statistik()

func update_statistik():
	$StatistikBar.update_number(num_picked_stations, len(stations))
	$StatistikBar.update_coverage(num_covered_houses, len(houses))
	$StatistikBar.update_cost(total_cost)
	print("statistik")


#func _on_button_button_up() -> void:
	#update_picked()
	#if (all_houses_covered):
		#print("Optimal solution : ")
		#print_array(solution)
		#print("Your solution : ")
		#print_array(picked_stations)
#
	#else:
		#print("Not all house is covered\n")


func print_array(array: Array[bool]) -> void:
	print("====================")
	var i: int = 0

	for value in array:
		print(str(i) + " : " + str(value))
		i += 1

	print("====================\n")


func _on_done_button_pressed() -> void:
	update_picked()
	#var optimal_solution: Solution = await get_optimal_solution()
	var i: Instance = Instance.new()
	i.n = len(houses)

	for station in stations:
		i.costs.append(station.cost)
		i.coverage.append(station.get_covered_houses())

	var optimal_solution: Solution = await Resquest.get_solution(self, i)
	if optimal_solution == null:
		print("Request failed!")
		return 
	print("Request successed!")

	$ResultPopup/ResultDialog.show_results(optimal_solution, picked_stations, total_cost, all_houses_covered)
	$ResultPopup.popup_centered()


func _on_hide_button_toggled(hide: bool) -> void:
	$HideButton/HideLabel.text = "Show" if hide else "Hide"
	$StatistikBar.visible = not hide
