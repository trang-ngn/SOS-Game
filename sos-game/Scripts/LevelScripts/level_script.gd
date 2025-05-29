class_name Level
extends Node2D

#var solution: Array[bool] = [false, false, true, true, true, true, false]
var picked_stations: Array[bool] = []
var total_cost: float = 0.0
var all_houses_covered: bool = false
var num_covered_houses: int = 0
var num_picked_stations: int = 0

#make sure the houses and station are in order
var stations: Array[RescueStation] = []
var houses: Array[House] = []

#show-results
var optimal_solution: Solution = null

func _ready() -> void:
	initialize_arrays()
	connect_signal()
	update_picked_stations()
	#$ShowOptButton.visible = false
	#$HideOptButton.visible = false
	#$ResultPopUp.visible = false
	$DoneRestartContainer/DoneButton.disabled = true
	#$DoneRestartContainer/CoveragePopUp.visible = false


func initialize_arrays() -> void:
	var station_nodes = $Stations.get_children()
	for node in station_nodes:
		if node is RescueStation:
			stations.append(node)
			
	var houses_node = $Houses.get_children()
	for node in houses_node:
		if node is House:
			houses.append(node)

func connect_signal() -> void:
	for station in stations:
		station.connect("stations_updated", Callable(self, "update_picked_stations"))
	
#func _process(delta: float) -> void:
	#print(stations)
	
func update_houses_covered() -> void: #check if all houses is covered
	var num : int = 0
	for house in houses:
		if (house.is_covered()):
			num += 1
	num_covered_houses = num
	all_houses_covered = num_covered_houses == len(houses)
	
	#enable Done when all_houses_covered
	$DoneRestartContainer/DoneButton.disabled = not all_houses_covered


func update_picked_stations():
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

func _on_done_button_pressed() -> void:
	$DoneDialog.visible = true;


func _on_done_ok_button_pressed() -> void:
	$DoneDialog.visible = false;
	update_picked_stations()
	#var optimal_solution: Solution = await get_optimal_solution()
	var i: Instance = Instance.new()
	i.n = len(houses)

	for station in stations:
		i.costs.append(station.cost)
		i.coverage.append(station.get_covered_houses())

	optimal_solution = await Resquest.get_solution(self, i)
	if optimal_solution == null:
		print("Request failed!")
		return 
	print("Request successed!")
	
	$ResultPopUp/ResultDialog.show_results(optimal_solution, picked_stations, total_cost, all_houses_covered)
	$ResultPopUp.visible = true
	$ShowOptButton.visible = true
	




func _on_hide_button_toggled(is_hidden: bool) -> void:
	$HideButton/HideLabel.text = "Show" if is_hidden else "Hide"
	$StatistikBar.visible = not is_hidden
	$HelpButton.visible = not is_hidden
	$BackButton.visible = not is_hidden
	$DoneRestartContainer.visible = not is_hidden


#show-results	
func opt_highlight() -> void:
	for station in stations:
		var idx = int(station.name)
		if optimal_solution.selected[idx]:
			print("true:", idx)
			station.set_optimal(true)
		else:
			print("false:", idx)
			station.set_optimal(false)


#show-results
func _on_show_opt_button_pressed() -> void:
	if optimal_solution != null:
		opt_highlight() #show-results
	$ResultPopUp.visible = false
	$ShowOptButton.visible = false
	#hide all buttons
	$StatistikBar.visible = false
	$HelpButton.visible = false
	$BackButton.visible = false
	$DoneRestartContainer.visible = false
	$HideButton.visible = false
	#show hideOptButton
	$HideOptButton.visible = true

#show-results
func _on_hide_opt_button_pressed() -> void:
	$ResultPopUp.visible = true
	$ShowOptButton.visible = true
	#show all buttons
	$StatistikBar.visible = true
	$HelpButton.visible = true
	$BackButton.visible = true
	$DoneRestartContainer.visible = true
	$HideButton.visible = true
	#hide self
	$HideOptButton.visible = false
