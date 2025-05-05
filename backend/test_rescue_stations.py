"""
    This code is provided by Institut
"""

import pytest

from rescue_stations import RescueStationInstance, RescueStationSolver


def test_simple_example():
    instance = RescueStationInstance(
        n=3,
        costs=[1, 2, 3],
        coverage=[[0], [1], [2]]
    )

    solver = RescueStationSolver(instance, verbose=False)
    solution = solver.solve()

    assert solution.cost == 6
    assert solution.is_optimal
    assert solution.selected == [True, True, True]
    assert solution.bound == 6


def test_simple_example2():
    instance = RescueStationInstance(
        n=5,
        costs=[3.0, 2.5, 7.0, 3.5],
        coverage=[
            [0, 1],
            [1, 2, 3],
            [3, 4],
            [0, 2, 4]
        ]
    )

    solver = RescueStationSolver(instance, verbose=False)
    solution = solver.solve()

    assert solution.cost == 6
    assert solution.is_optimal
    assert solution.selected == [False, True, False, True]
    assert solution.bound == 6


def test_validation():
    # The number of costs and coverage lists must be the same
    with pytest.raises(ValueError):
        RescueStationInstance(
            n=3,
            costs=[1, 2, 3],
            coverage=[[0], [1]]
        )

    # The number of costs and coverage lists must be the same
    with pytest.raises(ValueError):
        RescueStationInstance(
            n=3,
            costs=[1, 2],
            coverage=[[0], [1], [2]]
        )

    # Even if all rescue stations are used, not all points are covered
    with pytest.raises(ValueError):
        RescueStationInstance(
            n=3,
            costs=[1, 2, 3],
            coverage=[[0], [1], [0, 1]]
        )


test_simple_example()
test_validation()
