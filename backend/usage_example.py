from rescue_stations import (
    RescueStationInstance,
    RescueStationSolver,
    RescueStationSolution,
)

instance = RescueStationInstance(
    n=5,  # 5 houses
    costs=[3.0, 3.5, 7.0, 3.5],  # cost of each station
    coverage=[  # list of houses that each station covers, every house must be covered at least by one station
        [0, 1],
        [1, 2, 3],
        [3, 4],
        [0, 2, 4],
    ],
)

solver = RescueStationSolver(instance=instance, verbose=False)
solution: RescueStationSolution = solver.solve()

selected_stations: list[bool] = solution.selected
"""
@attributes RescueStationSolution
    instance: RescueStationInstance
    selected: list[bool]
    cost: float
    bound: float
    is_optimal: bool
    time: float
"""

print(solution)
