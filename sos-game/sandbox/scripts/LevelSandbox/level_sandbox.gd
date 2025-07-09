extends Node2D

@onready var houses_node = $Houses
@onready var stations_node = $Stations
@onready var house_scene = preload("uid://ih22of5jke4x")
@onready var station_scene = preload("uid://b7qgvql7ifvq5")

@onready var camera: Camera2D = $Camera2D
@onready var ui: UiManager = $UiManager

# Make sure the houses and station are in order
var stations: Array[StationLVL] = []
var houses: Array[HouseLVL] = []

var picked_stations: Array[bool] = []
var num_covered_houses: int = 0
var num_picked_stations: int = 0
var are_all_houses_covered: bool = false
var total_cost: float = 0.0

var optimal_solution: Solution = null


func _ready() -> void:
	initialize_buildings()
	_initialize_house_arrays()
	_initialize_station_arrays()
	_connect_signals()
	update_picked_stations()
	_setup_camera()


func initialize_buildings() -> void:
	for data in Buildings.houses_data:
		var new_house: HouseLVL = house_scene.instantiate()
		houses_node.add_child(new_house)
		new_house.set_id()
		new_house.initialize(data.position,data.design)

	for data in Buildings.stations_data:
		var new_station: StationLVL = station_scene.instantiate()
		stations_node.add_child(new_station)
		new_station.set_id()
		new_station.initialize(data.position,data.design,data.cost,data.radius)

	##
	###debug purpose
	#for s in Buildings.stations_data:
		#print(s)
#
	##
	###debug purpose
	#for s in stations_node.get_children():
		#if s is StationLVL:
			#print(s.id)


func _initialize_station_arrays() -> void:
	var station_nodes = stations_node.get_children()

	for node in station_nodes:
		if node is StationLVL:
			stations.append(node)


func _initialize_house_arrays() -> void:
	var houses_node = houses_node.get_children()

	for node in houses_node:
		if node is HouseLVL:
			houses.append(node)


func _connect_signals() -> void:
	for station in stations:
		station.stations_updated.connect(update_picked_stations)

	ui.done_dialog.done_ok_button_pressed.connect(_on_done_ok_button_pressed)
	ui.result_dialog.show_solution_button_pressed.connect(_highlight_optimal_stations)


func _update_coverage() -> void: #check if all houses is covered
	var num: int = 0

	for h in houses:
		if h.is_covered:
			num += 1

	num_covered_houses = num
	are_all_houses_covered = num_covered_houses == len(houses)


func update_picked_stations():
	picked_stations = []
	total_cost = 0.0
	num_picked_stations = 0

	for station in stations:
		if station.is_built():
			total_cost += station.cost
			num_picked_stations += 1

		picked_stations.append(station.is_built())

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
			station.change_state()


func _setup_camera():
	# Center camera on display origin
	camera.position = Vector2.ZERO
	camera.zoom = Vector2(1, 1)
