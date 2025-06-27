# create a global name for a script, making it easier to reference in other scripts.
class_name Instance
extends Resource # data container

var n: int
var costs: Array[float]
var coverage: Array[Array]


func to_dict() -> Dictionary:
	return {
		"n": n,
		"costs": costs,
		"coverage": coverage
	}
