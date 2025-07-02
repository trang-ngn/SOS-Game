extends GutTest

const STATION_SCENE = preload("res://entities/station.tscn")
var station_container: Node2D
var station: Station
var station_1

var HOUSE_SCENE = preload("res://entities/house.tscn")
var house_container: Node2D
var house: House
var house_1: House


func before_each():
	station_container = Node2D.new()
	station = STATION_SCENE.instantiate()
	station_1 = STATION_SCENE.instantiate()

	house_container = Node2D.new()
	house = HOUSE_SCENE.instantiate()
	house_1 = HOUSE_SCENE.instantiate()

	add_child_autoqfree(station_container)
	add_child_autoqfree(house_container)

	station_container.add_child(station)
	station_container.add_child(station_1)
	house_container.add_child(house)
	house_container.add_child(house_1)

	await get_tree().process_frame


func after_all():
	await get_tree().process_frame


func test_station_init():

	#testing unique id 

	assert_eq(station.id, 0)
	assert_eq(station_1.id,1)
	assert_false(station.is_built, "Station should not be built when initialized")
	assert_false(station_1.is_built, "Station should not be built when initialized")


func get_house_ids() -> Array[int]:
	var house_ids: Array[int] = []
	var house_array = house_container.get_children()
	house_array.reverse()
	for h in house_array:
		house_ids.append(h.id)

	return house_ids


func test_station_coverage_decrease():
	#because the 2 houses initiated in the same position with station, all two houses automaticly cover all houses
	var covered_houses = station.get_covered_houses()
	assert_eq(covered_houses,get_house_ids(),"Initial array")

	#remove 1 house
	house_1.queue_free()
	await get_tree().process_frame
	covered_houses = station.get_covered_houses()
	assert_eq(covered_houses, get_house_ids(), "After removing")


#func test_station_coverage_increase():
	##because the 2 houses initiated in the same position with station, all two houses automaticly cover all houses
	#var covered_houses = station.get_covered_houses()
	#assert_eq(covered_houses,get_house_ids())
#
	##add 1 house
	#var house_2 = HOUSE_SCENE.instantiate()
	#house_container.add_child(house_2)
	#await get_tree().process_frame
	#covered_houses = station.get_covered_houses()
	#assert_eq(covered_houses, get_house_ids(), "After adding")


func test_station_state():
	watch_signals(station)

	#build station
	station.change_state()
	assert_true(station.is_built,"Station should be built")
	assert_signal_emitted(station,"stations_updated")

	var counter: int = 0

	for h in station.covered_houses:
		if h.is_covered:
			counter += 1

	assert_eq(counter, len(station.covered_houses), "All covered_houses muss be covered")

	#destroy station
	station.change_state()
	assert_false(station.is_built,"built should be false when first initialized")
	assert_signal_emitted(station,"stations_updated")

	counter = 0

	for h in station.covered_houses:
		if h.is_covered:
			counter += 1

	assert_eq(counter, 0, "All covered_houses muss be uncovered")
