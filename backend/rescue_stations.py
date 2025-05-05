"""
    This code is provided by Institut
"""

from typing import Any

from pydantic import BaseModel, computed_field
from ortools.sat.python import cp_model



class RescueStationInstance(BaseModel):
    """
    We assume that we want to cover n points and we select a subset of stations with costs and coverage
    such that all points are covered.
    Cover
    """
    n: int
    costs: list[float]
    coverage: list[list[int]]

    @computed_field
    @property
    def m(self) -> int:
        return len(self.costs)

    def model_post_init(self, __context: Any) -> None:
        super().model_post_init(__context)

        if len(self.costs) !=  len(self.coverage):
            raise ValueError("The number of costs and coverage lists must be the same")

        complete_coverage = set()
        for i in range(self.m):
            complete_coverage = complete_coverage.union(set(self.coverage[i]))

        if set(range(self.n)) != complete_coverage:
            raise ValueError("Even if all rescue stations are used, not all points are covered")

class RescueStationSolution(BaseModel):
    instance: RescueStationInstance
    selected: list[bool]
    cost: float
    bound: float
    is_optimal: bool
    time: float


class RescueStationSolver:

    def __init__(self, instance: RescueStationInstance, verbose: bool = False):
        self.model = cp_model.CpModel()
        self.x = [self.model.new_bool_var(name=f"x_{i}") for i in range(len(instance.coverage))]

        coverages = [set(coverage) for coverage in instance.coverage]
        for j in range(instance.n):
            # find the stations that cover point i
            self.model.add_bool_or([self.x[i] for i in range(len(coverages)) if j in coverages[i]])

        self.model.minimize(sum(instance.costs[i] * self.x[i] for i in range(instance.m)))
        self.instance = instance
        self.verbose = verbose

    def solve(self, time_limit: int = 60) -> RescueStationSolution:
        solver = cp_model.CpSolver()
        solver.parameters.max_time_in_seconds = time_limit

        if self.verbose:
            solver.parameters.log_search_progress = True

        status_code = solver.solve(self.model)

        assert status_code in [cp_model.OPTIMAL, cp_model.FEASIBLE]
        assert sum(solver.value(self.x[i]) * self.instance.costs[i] for i in range(self.instance.m)) == solver.ObjectiveValue()

        return RescueStationSolution(
            instance=self.instance,
            selected=[bool(solver.value(self.x[i])) for i in range(self.instance.m)],
            cost=solver.ObjectiveValue(),
            bound=solver.BestObjectiveBound(),
            is_optimal=status_code == cp_model.OPTIMAL,
            time=solver.WallTime()
        )

