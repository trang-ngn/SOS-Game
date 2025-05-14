class_name Level
extends Node2D

#var solution: Array[bool] = [false, false, true, true, true, true, false]
var picked_stations: Array[bool] = []
var total_cost: float = 0
var all_houses_covered: bool = false

#make sure the houses and station are in order
@export var stations: Array[RescueStation]
@export var houses: Array[House]


func update_houses_covered() -> void: #check if all houses is covered
	for house in houses:
		if (!house.is_covered()):
			all_houses_covered = false
			return
	
	all_houses_covered = true


func update_picked():
	var result: Array[bool] = []
	var cost: float = 0

	for station in stations:
		result.append(station.is_built())
		cost += station.cost if station.is_built() else 0

	total_cost = cost
	picked_stations = result
	update_houses_covered()


#func _process(delta: float) -> void:
	#pass


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
