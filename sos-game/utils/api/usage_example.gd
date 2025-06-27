extends Node


func _ready():
	# Create an instance with custom-type Instance
	var i: Instance = Instance.new()
	i.n = 3
	i.costs = [1, 2, 3, 4]
	i.coverage = [[0], [1], [2], [0, 1, 2]]

	# Get solution
	var solution: Solution = await Resquest.get_solution(self, i)

	if solution == null:
		print("Cannot get solution!")
		return

	print("Selected_stations: ", solution.selected)
	print("Total cost: ", solution.cost)
	print("Solution is optimal: ", solution.is_optimal)
	print("Time needed: ", solution.time)
