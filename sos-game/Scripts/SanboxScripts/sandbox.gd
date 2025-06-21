extends Node2D

#scenes
@onready var house_scene = preload("res://Scenes/Sandbox/house_sandbox.tscn")
@onready var station_scene = preload("res://Scenes/Sandbox/station_sandbox.tscn")
#containers
@onready var houses_container = $Houses
@onready var stations_container = $Stations

@onready var default_object : DefaultObject = $ConstantObject/DefaultObject
@onready var object_deleter : ObjectsDeleter = $ConstantObject/ObjectDeleter
@onready var tilemap : TileMap = $TileMap

@onready var cost_radius_ui = $Camera2D/CanvasLayer/UI/CostRadius
@onready var cost_input: LineEdit = $Camera2D/CanvasLayer/UI/CostRadius/Cost
@onready var radius_input: LineEdit = $Camera2D/CanvasLayer/UI/CostRadius/Radius

var offset : Vector2 = Vector2(0,0)
var current_object : ObjectSandbox = null
var current_mode : MODE = MODE.DEFAULT
var current_building : BUILDING = BUILDING.HOUSE

var current_house_design_index : int = 0
var current_station_design_index : int = 0

enum MODE {
	DEFAULT,
	BUILD,
	DELETE
}

enum BUILDING {
	HOUSE,
	STATION
}

# Mapping der Designnamen zu Indizes
var house_design_names = {
	"BrownHouse": 0,
	"WhiteHouse": 1,
	"GreenHouse": 2,
	"LightbHouse": 3,
	"RedHouse": 4
}

var station_design_names = {
	"Station1": 0,
	"Station2": 1,
	"Station3": 2
}

var picked_stations: Array[bool] = []
var all_houses_covered: bool = false
var num_picked_stations: int = 0
var num_covered_houses: int = 0

var new_house: HouseSandbox = null
var stations: Array[StationSandbox] = []
var houses: Array[HouseSandbox] = []

#station that is currently being edited
var editing_station: StationSandbox = null

func _ready() -> void:
	switch_mode(MODE.DEFAULT)
	cost_input.text_submitted.connect(_on_cost_submitted)
	radius_input.text_submitted.connect(_on_radius_submitted)
	
	cost_input.text_changed.connect(_on_cost_text_changed)
	radius_input.text_changed.connect(_on_radius_text_changed)
	
	initialize_arrays()
	connect_signal()
	update_picked_stations()
	
	#$DoneRestartContainer/DoneButton.disabled = true


func _on_cost_text_changed(new_text: String) -> void:
	update_float_input(cost_input, new_text)

func _on_radius_text_changed(new_text: String) -> void:
	radius_input.text = filter_float_input(new_text)	
	if editing_station:
		var formatted = new_text.strip_edges().replace(",", ".")
		var value = formatted.to_float()
		if value > 0:
			editing_station.set_radius(value)

func update_float_input(line_edit: LineEdit, input: String) -> void:
	var old_cursor = line_edit.caret_column
	var filtered = filter_float_input(input)
	
	if line_edit.text != filtered:
		line_edit.text = filtered
		line_edit.caret_column = clamp(old_cursor, 0, filtered.length())

func filter_float_input(input: String) -> String:
	var allowed_chars = "0123456789.,"
	var result = ""
	var dot_found = false

	for c in input:
		if c in ".,": # max one , or . allowed
			if dot_found:
				continue
			result += "."
			dot_found = true
		elif c in "0123456789":
			result += c
	return result

func _on_cost_submitted(text: String) -> void:
	if editing_station:
		var formatted = text.strip_edges().replace(",", ".")
		var value = formatted.to_float()
		
		if value <= 0:
			print("Ungültige Kostenangabe")
			return
		
		switch_to_radius(value)

func switch_to_radius(value: float) -> void:
	editing_station.set_cost(value)
	radius_input.text = ""
	radius_input.editable = true
	radius_input.visible = true
	radius_input.grab_focus()

func _on_radius_submitted(text: String) -> void:
	if editing_station:
		var formatted = text.strip_edges().replace(",", ".")
		var value = formatted.to_float()
		if value <= 0:
			print("Ungültiger Radiuswert")
			return
		editing_station.set_radius(value)
		
		hide_radius(editing_station)
		
		editing_station = null
		cost_radius_ui.visible = false
		switch_mode(MODE.DEFAULT)

func edit_existing_station(station: StationSandbox) -> void:
	if editing_station and editing_station != station:
		hide_radius(editing_station)
	
	editing_station = station
	current_object = null
	switch_mode(MODE.DEFAULT)
	
	station.set_radius(station.get_current_radius())
	
	show_cost_input()
	show_radius(editing_station)
	
	var radius = editing_station.get_current_radius()
	radius_input.text = format_float(radius)
	
	editing_station.set_radius(radius)

func hide_radius(station: StationSandbox) -> void:
	var radius = station.get_node("Radius")
	radius.visible = false

func show_radius(station: StationSandbox) -> void:
	var radius = station.get_node("Radius")
	radius.visible = true

func format_float(value: float) -> String:
	if value == int(value):
		return str(int(value))
	return str(value)

func _process(delta: float) -> void:
	if (current_mode == MODE.BUILD or current_mode == MODE.DELETE) and current_object != null:
		update_object_position()

func update_object_position() -> void:
	var mouse_pos = get_global_mouse_position()
	var tile_pos = tilemap.local_to_map(mouse_pos)
	var world_pos = tilemap.map_to_local(tile_pos)
	current_object.position = to_global(world_pos + offset).snapped(Vector2.ONE)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		if current_mode == MODE.BUILD:
			place_object()
		elif current_mode == MODE.DELETE:
			delete_object()

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
		if current_mode == MODE.DELETE:
			switch_mode(MODE.DEFAULT)

func switch_mode(new_mode: MODE) -> void:
	if new_mode == MODE.DEFAULT:
		set_default_mode()
	elif new_mode == MODE.BUILD:
		set_build_mode()
	elif new_mode == MODE.DELETE:
		set_delete_mode()

func set_default_mode() -> void:
	current_mode = MODE.DEFAULT
	default_object.switch_default(true)
	object_deleter.switch_deleter(false)
	current_object = default_object
	set_offset(8,8)

func set_build_mode() -> void:
	current_mode = MODE.BUILD
	default_object.switch_default(false)
	object_deleter.switch_deleter(false)
	spawn_building_instance()

func set_delete_mode() -> void:
	current_mode = MODE.DELETE
	default_object.switch_default(false)
	object_deleter.switch_deleter(true)
	current_object = object_deleter
	set_offset(0, 0)

func spawn_building_instance() -> void:
	if current_object != null and current_object != default_object and current_object != object_deleter:
		current_object.queue_free()

	if current_building == BUILDING.HOUSE:
		var new_house = house_scene.instantiate() as HouseSandbox
		houses_container.add_child(new_house)
		current_object = new_house
		set_offset(8,8)
		new_house.set_design_index(current_house_design_index)

	elif current_building == BUILDING.STATION:
		var new_station = station_scene.instantiate() as StationSandbox
		stations_container.add_child(new_station)
		current_object = new_station
		set_offset(16,16)
		new_station.set_design_index(current_station_design_index)
		new_station.set_radius(10)

func place_object() -> void:
	if current_object.is_colliding():
		print("Platzierung nicht möglich, Objekt kollidiert")
		return
	
	if current_object is HouseSandbox:
		houses.append(current_object)
	elif current_object is StationSandbox:
		stations.append(current_object)
		
		if editing_station:
			hide_radius(editing_station)
		
		var placed_station = current_object
		current_object = null
		switch_mode(MODE.DEFAULT)
		editing_station = placed_station
		show_cost_input()
		show_radius(placed_station)
	else:
		switch_mode(MODE.DEFAULT)
	
	update_statistik()

func show_cost_input() -> void:
	#shows radius while editing
	if editing_station:
		show_radius(editing_station)
	
	cost_input.text = ""
	radius_input.text = ""
	radius_input.editable = false
	radius_input.visible = false
	cost_radius_ui.visible = false
	cost_radius_ui.visible = true
	cost_input.grab_focus()

func delete_object() -> void:
	var target = object_deleter.collided_object
	if target == null:
		print("Kein Objekt zum Löschen ausgewählt")
		return
	print(target)
	
	if target is HouseSandbox:
		target.queue_free()
		houses.erase(target)
	elif target is StationSandbox:
		target.queue_free()
		stations.erase(target)
		update_station_numbers()
	update_statistik()

func update_station_numbers() -> void:
	for i in range(stations.size()):
		stations[i].set_station_number(i + 1)

func set_offset(x: float, y: float) -> void:
	offset = Vector2(x,y)

func set_house_design_index(index: int) -> void:
	#print("House Design Index setzen auf", index)
	current_house_design_index = index
	if current_building == BUILDING.HOUSE and current_object is HouseSandbox:
		current_object.set_design_index(index)

func set_station_design_index(index: int) -> void:
	#print("Station Design Index setzen auf", index)
	current_station_design_index = index
	if current_building == BUILDING.STATION and current_object is StationSandbox:
		current_object.set_design_index(index)

func set_building(building_type: BUILDING) -> void:
	if current_building == building_type:
		return
	current_building = building_type
	if current_mode == MODE.BUILD:
		spawn_building_instance()

func set_design_by_name(design_name: String) -> void:
	#print("Design-Name empfangen:", design_name)

	match design_name:
		# House Designs
		"BrownHouse":
			current_building = BUILDING.HOUSE
			set_house_design_index(0)
			switch_mode(MODE.BUILD)
		"WhiteHouse":
			current_building = BUILDING.HOUSE
			set_house_design_index(1)
			switch_mode(MODE.BUILD)
		"GreenHouse":
			current_building = BUILDING.HOUSE
			set_house_design_index(2)
			switch_mode(MODE.BUILD)
		"LightbHouse":
			current_building = BUILDING.HOUSE
			set_house_design_index(3)
			switch_mode(MODE.BUILD)
		"RedHouse":
			current_building = BUILDING.HOUSE
			set_house_design_index(4)
			switch_mode(MODE.BUILD)

		# Station Designs
		"Station1":
			current_building = BUILDING.STATION
			set_station_design_index(0)
			switch_mode(MODE.BUILD)
		"Station2":
			current_building = BUILDING.STATION
			set_station_design_index(1)
			switch_mode(MODE.BUILD)
		"Station3":
			current_building = BUILDING.STATION
			set_station_design_index(2)
			switch_mode(MODE.BUILD)

func connect_signal() -> void:
	for station in stations:
		station.connect("stations_updated", Callable(self, "update_picked_stations"))

func initialize_arrays() -> void:
	var station_nodes = $Stations.get_children()
	for node in station_nodes:
		if node is RescueStation:
			stations.append(node)
			
	var houses_node = $Houses.get_children()
	for node in houses_node:
		if node is House:
			houses.append(node)

#check if all houses is covered
func update_houses_covered() -> void:
	var num : int = 0
	for house in houses:
		if (house.is_covered()):
			num += 1
	num_covered_houses = num
	all_houses_covered = num_covered_houses == len(houses)
	
	#enable Done when all_houses_covered
	#$DoneRestartContainer/DoneButton.disabled = not all_houses_covered

func update_picked_stations():
	var result: Array[bool] = []
	var cost: float = 0.0
	var num: int = 0

	for station in stations:
		if station.is_built():
			cost += station.cost
			num += 1
		result.append(station.is_built())

	#total_cost = cost
	picked_stations = result
	num_picked_stations = num
	update_houses_covered()
	update_statistik()

func update_statistik():
	print((houses))
	$Camera2D/CanvasLayer/UI/SandboxStatistikBar.update_houses(len(houses))
	$Camera2D/CanvasLayer/UI/SandboxStatistikBar.update_stations(len(stations))
	$Camera2D/CanvasLayer/UI/SandboxStatistikBar.update_coverage(num_covered_houses, len(houses))

func _on_hide_button_pressed() -> void:
	$Camera2D/CanvasLayer/UI/HideButton.visible = false
	$Camera2D/CanvasLayer/UI/SandboxStatistikBar.visible = false
	$Camera2D/CanvasLayer/UI/HelpButton.visible = false
	$Camera2D/CanvasLayer/UI/BackButton.visible = false
	$Camera2D/CanvasLayer/UI/DoneRestartContainer.visible = false
	$Camera2D/CanvasLayer/UI/HouseButton.visible = false
	$Camera2D/CanvasLayer/UI/StationButton.visible = false
	$Camera2D/CanvasLayer/UI/StationDesigns.visible = false
	$Camera2D/CanvasLayer/UI/HouseDesigns.visible = false
	$Camera2D/CanvasLayer/UI/DesignBackground.visible = false
	$Camera2D/CanvasLayer/UI/CostRadius.visible = false
	$Camera2D/CanvasLayer/UI/DeleteButton.visible = false
	$Camera2D/CanvasLayer/UI/ShowButton.visible = true


func _on_show_button_pressed() -> void:
	$Camera2D/CanvasLayer/UI/HideButton.visible = true
	$Camera2D/CanvasLayer/UI/ShowButton.visible = false
	$Camera2D/CanvasLayer/UI/SandboxStatistikBar.visible = true
	$Camera2D/CanvasLayer/UI/HelpButton.visible = true
	$Camera2D/CanvasLayer/UI/BackButton.visible = true
	$Camera2D/CanvasLayer/UI/DoneRestartContainer.visible = true
	$Camera2D/CanvasLayer/UI/HouseButton.visible = true
	$Camera2D/CanvasLayer/UI/StationButton.visible = true
	$Camera2D/CanvasLayer/UI/DeleteButton.visible = true
