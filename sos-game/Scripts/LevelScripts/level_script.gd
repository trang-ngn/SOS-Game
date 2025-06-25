class_name Level
extends Node2D

# Var solution: Array[bool] = [false, false, true, true, true, true, false]
var picked_stations: Array[bool] = []
var total_cost: float = 0.0
var all_houses_covered: bool = false
var num_covered_houses: int = 0
var num_picked_stations: int = 0

# Make sure the houses and station are in order
var stations: Array[RescueStation] = []
var houses: Array[House] = []

# Show-results
var optimal_solution: Solution = null

# Camera
var camera: Camera2D

func _ready() -> void:
	initialize_arrays()
	connect_signal()
	update_picked_stations()
	#$ShowOptButton.visible = false
	#$HideOptButton.visible = false
	#$ResultPopUp.visible = false
	$UI/ShowButton.visible = false
	$UI/DoneRestartContainer/DoneButton.disabled = true
	#$DoneRestartContainer/CoveragePopUp.visible = false
	camera = $Camera2D
	_setup_camera()


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
	
	# Enable Done when all_houses_covered
	$UI/DoneRestartContainer/CoveragePopUp.all_house_covered = all_houses_covered
	$UI/DoneRestartContainer/DoneButton.disabled = not all_houses_covered


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
	$UI/StatistikBar.update_number(num_picked_stations, len(stations))
	$UI/StatistikBar.update_coverage(num_covered_houses, len(houses))
	$UI/StatistikBar.update_cost(total_cost)

func _on_done_button_pressed() -> void:
	$UI/DoneDialog.visible = true;


func _on_done_ok_button_pressed() -> void:
	$UI/DoneDialog.visible = false;
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
	
	$UI/ResultPopUp/ResultDialog.show_results(optimal_solution, picked_stations, total_cost, all_houses_covered)
	$UI/ResultPopUp.visible = true
	$UI/ShowOptButton.visible = true
	


# Show-results	
func opt_highlight() -> void:
	for station in stations:
		var idx = int(station.name)
		if optimal_solution.selected[idx]:
			print("true:", idx)
			station.set_optimal(true)
		else:
			print("false:", idx)
			station.set_optimal(false)


# Show-results
func _on_show_opt_button_pressed() -> void:
	
	for s in stations :
		s.built = false
		s.change_state()
	
	if optimal_solution != null:
		opt_highlight() # Show-results
	$UI/ResultPopUp.visible = false
	$UI/ShowOptButton.visible = false
	
	# Hide all buttons
	$UI/StatistikBar.visible = false
	$UI/HelpButton.visible = false
	$UI/BackButton.visible = false
	$UI/DoneRestartContainer.visible = false
	$UI/HideButton.visible = false
	
	# Show hideOptButton
	$UI/HideOptButton.visible = true

# Show-results
func _on_hide_opt_button_pressed() -> void:
	$UI/ResultPopUp.visible = true
	$UI/ShowOptButton.visible = true
	# Show all buttons
	$UI/StatistikBar.visible = true
	$UI/HelpButton.visible = true
	$UI/BackButton.visible = true
	$UI/DoneRestartContainer.visible = true
	$UI/HideButton.visible = true
	# Hide self
	$UI/HideOptButton.visible = false


func _on_hide_button_pressed() -> void:
	$UI/HideButton.visible = false
	$UI/StatistikBar.visible = false
	$UI/HelpButton.visible = false
	$UI/BackButton.visible = false
	$UI/DoneRestartContainer.visible = false
	$UI/ShowButton.visible = true


func _on_show_button_pressed() -> void:
	$UI/HideButton.visible = true
	$UI/ShowButton.visible = false
	$UI/StatistikBar.visible = true
	$UI/HelpButton.visible = true
	$UI/BackButton.visible = true
	$UI/DoneRestartContainer.visible = true
	

func _setup_camera():	
	# Center camera on display origin
	camera.position = Vector2.ZERO
	camera.zoom = Vector2(1, 1) 
