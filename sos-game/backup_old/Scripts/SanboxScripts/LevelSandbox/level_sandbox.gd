extends Node2D

@onready var houses_node = $Houses
@onready var stations_node = $Stations
@onready var house_scene = preload("res://Scenes/Sandbox/LevelSandbox/house_lvl_sandbox.tscn")
@onready var station_scene = preload("res://Scenes/Sandbox/LevelSandbox/station_lvl_sandbox.tscn")

#UI
@onready var statistik_bar = $UI/StatistikBar
@onready var back_button = $UI/BackButton
@onready var hide_button = $UI/HideButton
@onready var show_button = $UI/ShowButton
@onready var help_button = $UI/HelpButton
@onready var done_dialog = $UI/DoneDialog
@onready var coverage_pop_up = $UI/DoneRestartContainer/CoveragePopUp
@onready var done_button = $UI/DoneRestartContainer/DoneButton
@onready var result_pop_up = $UI/ResultPopUp
@onready var result_dialog = $UI/ResultPopUp/ResultDialog
@onready var show_optimal_button =$UI/ShowOptButton
@onready var hide_optimal_button = $UI/HideOptButton


var picked_stations: Array[bool] = []
var total_cost: float = 0.0
var all_houses_covered: bool = false
var num_covered_houses: int = 0
var num_picked_stations: int = 0

var stations: Array[StationLVL] = []
var houses: Array[HouseLVL] = []

var optimal_solution: Solution = null

func _ready() -> void:
	initialize_buildings()
	initialize_arrays()
	connect_signal()
	update_picked_stations()

func initialize_buildings() -> void :
	for data in Buildings.houses_data :
		var new_house : HouseLVL  = house_scene.instantiate() 
		houses_node.add_child(new_house)
		new_house.set_id()
		new_house.initialize(data.position,data.design)
	
	for data in Buildings.stations_data :
		var new_station : StationLVL = station_scene.instantiate()
		stations_node.add_child(new_station)
		new_station.set_id()
		new_station.initialize(data.position,data.design,data.cost,data.radius)
	
	#
	##debug purpose
	#for s in Buildings.stations_data :
		#print(s)
	#
	##debug purpose
	#for s in stations.get_children() :
		#if s is StationLVL :
			#print(s.id)

func initialize_arrays() -> void:
	for node in stations_node.get_children():
		if node is StationLVL:
			stations.append(node)
			
	for node in houses_node.get_children():
		if node is HouseLVL:
			houses.append(node)

func update_houses_covered() -> void: #check if all houses is covered
	var num : int = 0
	for h in houses:
		if h.is_covered() :
			num += 1
	num_covered_houses = num
	all_houses_covered = num_covered_houses == len(houses)
	
	coverage_pop_up.all_house_covered = all_houses_covered
	done_button.disabled = not all_houses_covered
	

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

func update_statistik() -> void :
	statistik_bar.update_number(num_picked_stations, len(stations))
	statistik_bar.update_coverage(num_covered_houses, len(houses))
	statistik_bar.update_cost(total_cost)

func opt_highlight() -> void:
	for station in stations:
		var idx = int(station.id)
		if optimal_solution.selected[idx]:
			print("true:", idx)
			station.set_optimal(true)
		else:
			print("false:", idx)
			station.set_optimal(false)

func connect_signal() -> void:
	for station in stations:
		station.connect("stations_updated", Callable(self, "update_picked_stations"))


#func _process(delta: float) -> void:
	#for s in stations.get_children() :
		#if s is StationLVL :
			#print(str(s.id) + " " + str(s.radius_size)) 


####################################################################################################################################################################
#UI BUTTONS

func _on_hide_button_pressed() -> void:
	hide_button.visible = false
	statistik_bar.visible = false
	help_button.visible = false
	back_button.visible = false
	#$UI/DoneRestartContainer.visible = false
	show_button.visible = true


func _on_show_button_pressed() -> void:
	hide_button.visible = true
	show_button.visible = false
	statistik_bar.visible = true
	help_button.visible = true
	back_button.visible = true
	#$UI/DoneRestartContainer.visible = true


func _on_done_button_pressed() -> void:
	done_dialog.visible = true

func _on_done_ok_button_pressed() -> void:
	done_dialog.visible = false
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
	
	result_dialog.show_results(optimal_solution, picked_stations, total_cost, all_houses_covered)
	result_pop_up.visible = true
	show_optimal_button.visible = true
	

func _on_show_opt_button_pressed() -> void:
	
	for s in stations :
		s.built = false
		s.change_state()
	
	if optimal_solution != null:
		opt_highlight() # Show-results
	result_pop_up.visible = false
	show_optimal_button.visible = false
	
	# Hide all buttons
	statistik_bar.visible = false
	help_button.visible = false
	back_button.visible = false
	$UI/DoneRestartContainer.visible = false
	hide_button.visible = false
	
	# Show hideOptButton
	hide_optimal_button.visible = true


func _on_hide_opt_button_pressed() -> void:
	result_pop_up.visible = true
	show_optimal_button.visible = true
	# Show all buttons
	statistik_bar.visible = true
	help_button.visible = true
	back_button.visible = true
	$UI/DoneRestartContainer.visible = true
	hide_button.visible = true
	# Hide self
	hide_optimal_button.visible = false

####################################################################################################################################################################
