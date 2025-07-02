# create a global name for a script, making it easier to reference in other scripts.
#class_name Solution
extends Resource # data container

var instance: Instance
var selected: Array
var cost: float
var bound: float
var is_optimal: bool
var time: float


func _to_string() -> String:
	var instance_str: String = "[n=%d, costs=%s, coverage=%s]" % [instance.n, instance.costs, instance.coverage]
	return "[instance=%s, selected=%s, cost=%.1f, bound=%.1f, is_optimal=%s, time=%.5f]" % [instance_str, selected, cost, bound, is_optimal, time]
