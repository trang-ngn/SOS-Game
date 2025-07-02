extends GutTest # import library 

"""
List of functions can be used:
https://gut.readthedocs.io/en/latest/class_ref/class_guttest.html#class-guttest
"""

var HOUSE_SCENE = preload("res://entities/house.tscn")
var houses: Node2D # houses container
var house: House


func before_all(): # run before all test, use before_each/after_each when need to reset first conditions
	houses = Node2D.new() # create houses container
	house = HOUSE_SCENE.instantiate() # create a house-instance

	# test will free child automatically, see at link above
	add_child_autoqfree(houses)

	houses.add_child(house) # add first house node

	# wait one frame to ensure child nodes are added completely
	await get_tree().process_frame


func after_all(): # run after all tests
	# wait one frame to let test free children nodes completely
	await get_tree().process_frame


func test_house_init():
	var house_1: House
	house_1 = HOUSE_SCENE.instantiate() # create a house-instance
	houses.add_child(house_1) # add second house node
	assert_eq(house.id, 0, "House 0 should have id 0.")
	assert_eq(house_1.id, 1, "House 1 should have id 1.")
	assert_false(house.is_covered, "House should not be covered when game starts.")
	assert_eq(house.num_covering_stations, 0, "House should not be covered by any station when game starts.")


func test_house_coverage_increase():
	house.update_num_covering_stations(1)
	house.update_num_covering_stations(1)
	assert_true(house.is_covered, "House should be covered when covering stations > 0")
	assert_eq(house.num_covering_stations, 2, "House should be covered by 2 stations.")


func test_house_coverage_decrease():
	house.num_covering_stations = 5
	house.is_covered = true
	house.update_num_covering_stations(-1)
	assert_true(house.is_covered, "House should be covered when it is covered by 4 stations.")
	assert_eq(house.num_covering_stations, 4, "House should be covered by 4 stations.")
	house.update_num_covering_stations(-4)
	assert_false(house.is_covered, "House should not be covered when it is covered by 0 station.")
	assert_eq(house.num_covering_stations, 0, "House should be covered by 0 stations.")
