extends Node2D
class_name LevelTemplate

#@onready var camera: Camera2D = $Camera2D
@onready var ui: UiManager = $UiManager

# Make sure the houses and station are in order
var stations: Array[Station] = []
var houses: Array[House] = []

var picked_stations: Array[bool] = []
var num_covered_houses: int = 0
var num_picked_stations: int = 0
var are_all_houses_covered: bool = false
var total_cost: float = 0.0

var optimal_solution: Solution = null


func _ready() -> void:
	_initialize_house_arrays()
	_initialize_station_arrays()
	_connect_signals()
	update_picked_stations()
	#_setup_camera()


func _initialize_station_arrays() -> void:
	var station_nodes = $Stations.get_children()

	for node in station_nodes:
		if node is Station:
			stations.append(node)


func _initialize_house_arrays() -> void:
	var houses_node = $Houses.get_children()

	for node in houses_node:
		if node is House:
			houses.append(node)


func _connect_signals() -> void:
	for station in stations:
		station.stations_updated.connect(update_picked_stations)

	ui.done_dialog.done_ok_button_pressed.connect(_on_done_ok_button_pressed)
	ui.result_dialog.show_solution_button_pressed.connect(_highlight_optimal_stations)


func _update_coverage() -> void: #check if all houses is covered
	num_covered_houses = 0

	for house in houses:
		if (house.is_covered):
			num_covered_houses += 1

	are_all_houses_covered = (num_covered_houses == len(houses))


func update_picked_stations():
	picked_stations = []
	total_cost = 0.0
	num_picked_stations = 0

	for station in stations:
		if station.is_built:
			total_cost += station.cost
			num_picked_stations += 1

		picked_stations.append(station.is_built)

	_update_coverage()
	ui.update_statistic(num_picked_stations, len(stations), num_covered_houses, len(houses), total_cost)


func _on_done_ok_button_pressed() -> void:
	update_picked_stations()

	var i: Instance = Instance.new()
	i.n = len(houses)

	for station in stations:
		i.costs.append(station.cost)
		i.coverage.append(station.get_covered_houses())

	optimal_solution = await Resquest.get_solution(self, i)

	if optimal_solution == null:
		print("Request failed!")
		ui.show_error_dialog()
		return

	print("Request successed!")
	print("Instance is solved in %.3f s" % optimal_solution.time)
	ui.show_result_dialog(optimal_solution, picked_stations, total_cost, are_all_houses_covered)


# Show-results	
func _highlight_optimal_stations() -> void:
	for station in stations:
		var idx = station.id
		station.set_optimal(optimal_solution.selected[idx])
		if picked_stations[idx]:
			station.change_state(false)


'''func _setup_camera():
	# Center camera on display origin
	camera.position = Vector2.ZERO
	camera.zoom = Vector2(1, 1)'''
