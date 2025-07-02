extends GutTest

var STATISTIC_SCENE = preload("res://gui_manager/bars/statistic_bar.tscn")

var statistic: Statistic


func before_each():
	statistic = STATISTIC_SCENE.instantiate()
	add_child_autoqfree(statistic)

	await get_tree().process_frame


func after_each():
	await get_tree().process_frame


func test_update_number():
	statistic.update_number(0, 1)
	assert_eq(statistic.number_label.text, "0/1")


func test_update_coverage():
	statistic.update_coverage(0,1)
	assert_eq(statistic.coverage_label.text, "0/1")


func test_update_cost():
	statistic.update_cost(30)
	assert_eq(statistic.cost_label.text, "30M €")
