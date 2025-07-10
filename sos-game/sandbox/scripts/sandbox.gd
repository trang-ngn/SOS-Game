extends Node2D
class_name Sandbox
#scenes
@onready var house_scene = preload("uid://b1gujflbm4onn")
@onready var station_scene = preload("uid://cpwy82qe4ahhh")
@onready var level_sandbox = preload("uid://cxh2aa1vosek5")
#containers

@onready var houses_container = $Houses
@onready var stations_container = $Stations

@onready var default_object : DefaultObject = $ConstantObject/DefaultObject
@onready var object_deleter : ObjectsDeleter = $ConstantObject/ObjectDeleter
@onready var tilemap : TileMap = $TileMap
@onready var ui: UiManagerSandbox = $UiManagerSandbox
@onready var cost_radius_ui = $UiManagerSandbox/CostRadius
@onready var cost_input: LineEdit = $UiManagerSandbox/CostRadius/Cost
@onready var radius_input: HSlider = $UiManagerSandbox/CostRadius/HSlider
@onready var done_button = $UiManagerSandbox/Buttons/DoneButton

var offset : Vector2 = Vector2(0,0)
var current_object : ObjectSandbox = null
var current_mode : MODE = MODE.DEFAULT
var current_building: BUILDING = BUILDING.HOUSE

var text_finished: bool = false
var current_house_design_index: int = 0
var current_station_design_index: int = 0

enum MODE {
	DEFAULT,
	BUILD,
	DELETE,
	EDIT_STATION
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
	cost_radius_ui.visible = false
	cost_input.text_submitted.connect(_on_cost_submitted)
	#radius_input.text_submitted.connect(_on_radius_submitted)

	cost_input.text_changed.connect(_on_cost_text_changed)
	radius_input.value_changed.connect(_on_radius_text_changed)
	ui.done_dialog.done_ok_button_pressed.connect(_on_done_ok_button_pressed)


func _process(delta: float) -> void:
	if (current_mode == MODE.BUILD or current_mode == MODE.DELETE) and current_object != null:
		update_object_position()

	#debug purpose
	#print(editing_station)
	#print("house : " + str(houses_container.get_child_count()) + "stations : " + str(stations_container.get_child_count()))


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		if current_mode == MODE.BUILD:
			place_object()
		elif current_mode == MODE.DELETE:
			delete_object()

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
		if current_mode == MODE.DELETE:
			switch_mode(MODE.DEFAULT)

		if current_mode == MODE.EDIT_STATION:
			switch_mode(MODE.DEFAULT)

		if current_mode == MODE.BUILD:
			current_object.queue_free()
			switch_mode(MODE.DEFAULT)


func _on_radius_text_changed(value: float) -> void:
	#update_float_input(radius_input,new_text)
	#radius_input.text = filter_float_input(new_text)

	if editing_station:
		#var formatted = new_text.strip_edges().replace(",", ".")
		#var value = formatted.to_float()

		if value > 0:
			editing_station.set_radius(value)

	#check_coverage()


func _on_cost_text_changed(new_text: String) -> void:

	update_input(cost_input, new_text)
	submit_cost(new_text)


func update_input(line_edit: LineEdit, input: String) -> void:
	var old_cursor = line_edit.caret_column
	var filtered = filter_input(input)

	if line_edit.text != filtered:
		line_edit.text = filtered
		line_edit.caret_column = clamp(old_cursor, 0, filtered.length())


func filter_input(input: String) -> String:
	var allowed_chars = "0123456789"
	var result = ""
	var dot_found = false

	for c in input:
		#if c in ".,": # max one , or . allowed
			#if dot_found:
				#continue
#
			#result += "."
			#dot_found = true

		#elif c in "0123456789":
		if c in allowed_chars:
			result += c

	return result
	#var result = ""
#
	#for c in input:
		#if c.is_valid_int():
			#result += c
#
	#return result


func submit_cost(text: String) -> void:
	if editing_station:
		var formatted = text.strip_edges().replace(",", ".")
		var value = formatted.to_int()

		if value <= 0:
			print("Ungültige Kostenangabe")
			return

		editing_station.set_cost(value)


func _on_cost_submitted(text: String) -> void:
	if editing_station:
		var formatted = text.strip_edges().replace(",", ".")
		var value = formatted.to_int()

		if value <= 0:
			print("Ungültige Kostenangabe")
			return

		editing_station.set_cost(value)
		#switch_to_radius(value)


#func switch_to_radius(value: float) -> void:
	#editing_station.set_cost(value)
	#radius_input.text = ""
	#radius_input.editable = true
	#radius_input.visible = true
	#radius_input.grab_focus()
	#check_coverage()


#func _on_radius_submitted(text: String) -> void:
	#if editing_station:
		#var formatted = text.strip_edges().replace(",", ".")
		#var value = formatted.to_float()
#
		#if value <= 0:
			#print("Ungültiger Radiuswert")
			#return
#
		#editing_station.set_radius(value)
#
		#hide_radius(editing_station)
#
		#editing_station = null
		#cost_radius_ui.visible = false
		#switch_mode(MODE.DEFAULT)
		#check_coverage()


#func edit_existing_station(station: StationSandbox) -> void:
	#if editing_station and editing_station != station:
		#hide_radius(editing_station)
#
	#editing_station = station
	#current_object = null
	#switch_mode(MODE.DEFAULT)
#
	#station.set_radius(station.get_current_radius())
#
	#show_cost_input()
	#editing_station.show_radius()
	#var radius = editing_station.get_current_radius()
	##radius_input.text = format_float(radius)
	#radius_input.value = radius
#
	#editing_station.set_radius(radius)
	#check_coverage()


#func hide_radius(station: StationSandbox) -> void:
	#var radius = station.get_node("Radius")
	#radius.visible = false
#
#
#func show_radius(station: StationSandbox) -> void:
	#var radius = station.get_node("Radius")
	#radius.visible = true


func format_float(value: float) -> String:
	if value == int(value):
		return str(int(value))

	return str(value)


func update_object_position() -> void:
	var mouse_pos
	var tile_pos
	var world_pos

	if current_mode == MODE.DELETE:
		mouse_pos = get_global_mouse_position()
		current_object.position = to_global(mouse_pos + offset).snapped(Vector2.ONE)
	else:
		mouse_pos = get_global_mouse_position()
		tile_pos = tilemap.local_to_map(mouse_pos)
		world_pos = tilemap.map_to_local(tile_pos)
		current_object.position = to_global(world_pos + offset).snapped(Vector2.ONE)

	update_collision_indicator()


func update_collision_indicator() -> void:
	if current_object.is_colliding():
		current_object.set_collision_indicator(true)
	else:
		current_object.set_collision_indicator(false)


func switch_mode(new_mode: MODE) -> void:
	#check_coverage()

	if editing_station != null:
		set_off_edit_mode()

	if new_mode == MODE.DEFAULT:
		set_default_mode()
	elif new_mode == MODE.BUILD:
		set_build_mode()
	elif new_mode == MODE.DELETE:
		set_delete_mode()
	elif new_mode == MODE.EDIT_STATION:
		set_edit_mode()


func set_default_mode() -> void:
	current_mode = MODE.DEFAULT
	default_object.switch_default(false)
	object_deleter.switch_deleter(false)
	toggle_stations_radius(false)
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


func set_edit_mode() -> void:
	current_mode = MODE.EDIT_STATION
	cost_radius_ui.visible = true
	default_object.switch_default(false)
	object_deleter.switch_deleter(false)


func set_off_edit_mode() -> void:
	cost_radius_ui.visible = false
	editing_station.plot_pressed = false
	editing_station.toggle_radius_visibility(false)
	editing_station = null


func spawn_building_instance() -> void:
	if current_object != null and current_object != default_object and current_object != object_deleter:
		current_object.queue_free()

	toggle_stations_radius(true)

	if current_building == BUILDING.HOUSE:
		var new_house = house_scene.instantiate() as HouseSandbox
		houses_container.add_child(new_house)
		current_object = new_house
		set_offset(8,8)
		new_house.set_design_index(current_house_design_index)

	elif current_building == BUILDING.STATION:
		var new_station = station_scene.instantiate() as StationSandbox
		stations_container.add_child(new_station)
		new_station.edit_station.connect(on_plot_pressed)

		set_offset(16,12)
		new_station.set_design_index(current_station_design_index)
		new_station.set_radius(10)
		new_station.toggle_radius_visibility(true)
		new_station.plot_pressed = true
		current_object = new_station


func on_plot_pressed(station:StationSandbox) -> void:
	if current_mode == MODE.BUILD:
		return

	switch_mode(MODE.EDIT_STATION)
	editing_station = station
	editing_station.plot_pressed = true
	radius_input.value = station.radius_value
	cost_input.text = str(station.station_cost)
	#print(station.name)


func place_object() -> void:
	if current_object.is_colliding():
		print("Platzierung nicht möglich, Objekt kollidiert")
		return

	if current_object is HouseSandbox:
		houses.append(current_object)

	elif current_object is StationSandbox:
		stations.append(current_object)
		current_object.plot_pressed = false

		#if editing_station:
			#hide_radius(editing_station)

		#var placed_station = current_object
		#current_object = null
		#switch_mode(MODE.DEFAULT)
		#editing_station = placed_station
		#show_cost_input()
		#placed_station.show_radius()
		#radius_input.value = placed_station.radius_value

	#current_object = null
	#await get_tree().process_frame
	#await get_tree().physics_frame
	toggle_stations_radius(false)
	check_coverage()

	switch_mode(MODE.DEFAULT)


#func show_cost_input() -> void:
	##shows radius while editing
	#if editing_station:
		#editing_station.show_radius()
#
	#cost_input.text = ""
	##radius_input.text = ""
	##radius_input.editable = false
	##radius_input.visible = false
	##cost_radius_ui.visible = false
	#cost_radius_ui.visible = true
	#cost_input.grab_focus()


func delete_object() -> void:
	var target = object_deleter.collided_object

	if target == null:
		print("Kein Objekt zum Löschen ausgewählt")
		return

	#print(target)

	if target is HouseSandbox:
		target.queue_free()
		houses.erase(target)
	elif target is StationSandbox:
		#target.cover_houses(false)
		target.queue_free()
		stations.erase(target)
		#update_station_numbers()

	check_coverage()


func toggle_stations_radius(value: bool) -> void:
	for s in stations:
		s.plot_pressed = value
		s.toggle_radius_visibility(value)


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


func reset_coverage() -> void:
	for h in houses_container.get_children():
		if h is HouseSandbox:
			h.num_stat_cover = 0


func check_coverage() -> void:
	var counter:int = 0
	update_coverage()

	for h in houses:
		if h.is_covered():
			counter += 1

	num_covered_houses = counter
	ui.update_statistic_sandbox(len(houses), len(stations), num_covered_houses)


func update_coverage() -> void:
	reset_coverage()
	for s in stations_container.get_children():
		if s is StationSandbox:
			s.cover_houses()


func transfer_data() -> void:
	Buildings.houses_data.clear()
	Buildings.stations_data.clear()

	for house in houses:
		if house is HouseSandbox:
			Buildings.houses_data.append({"position": house.position, "design": house.design_index})

	for station in stations:
		if station is StationSandbox:

			Buildings.stations_data.append({"position": station.position, "design": station.design_index, "cost": station.station_cost, "radius": station.radius_value})


func _on_done_ok_button_pressed() -> void:
	transfer_data()
	get_tree().change_scene_to_packed(level_sandbox)
