extends GutTest

var LEVEL_TEMPLATE_SCENE = preload("res://level_templates/level_template.tscn")
var STATION_SCENE = preload("res://entities/station.tscn")
var HOUSE_SCENE = preload("res://entities/house.tscn")

var root: Node2D
var level: LevelTemplate
var stations: Node2D
var houses: Node2D


func before_each():
	level = LEVEL_TEMPLATE_SCENE.instantiate()
	await get_tree().process_frame

	add_child_autoqfree(level)

	stations = level.get_node("Stations")
	houses = level.get_node("Houses")


func after_each():
	await get_tree().process_frame


func test_init_objects():
	stations.add_child(STATION_SCENE.instantiate())
	stations.add_child(STATION_SCENE.instantiate())

	level._initialize_station_arrays()
	assert_eq(len(level.stations), 2, "Station array should contain 2 stations.")

	houses.add_child(HOUSE_SCENE.instantiate())
	level._initialize_house_arrays()
	assert_eq(len(level.houses), 1, "House array should contain 1 house.")


func test_update_picked_stations():
	var station: Station = STATION_SCENE.instantiate()
	stations.add_child(station)
	level._initialize_station_arrays()
	station.cost = 10
	station.is_built = true
	level.update_picked_stations()
	assert_eq(level.num_picked_stations, 1, "Number picked stations.")
	assert_eq(level.picked_stations, [true], "Station 0 should be picked.")
	assert_eq(level.total_cost, 10.0, "Total cost.")

	station.is_built = false
	level.update_picked_stations()
	assert_eq(level.num_picked_stations, 0, "Number picked stations.")
	assert_eq(level.picked_stations, [false], "Station 0 should not be picked.")
	assert_eq(level.total_cost, 0.0, "Total cost.")
