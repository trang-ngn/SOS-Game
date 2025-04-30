from fastapi import FastAPI, Request

from backend.rescue_stations import RescueStationSolution
from .rescue_stations import RescueStationInstance, RescueStationSolver

# Read more on https://fastapi.tiangolo.com/tutorial/first-steps/#api-schema

app = FastAPI()


@app.post("/solve")  # defines a route name that accepts HTTP POST requests
async def solve_request(request: Request) -> RescueStationSolution:
    """
    The JSON data sent in the body of the request should be a dictionary with
    the following keys:

    - n: The number of points to be covered.
    - costs: A list of the costs of each rescue station.
    - coverage: A list of lists, where each sub-list is a list of the points
      covered by the corresponding rescue station.

    The response will be a RescueStationSolution object.
    """
    # Extracting user data from the request body
    user_data = await request.json()

    # create instance with values from user_data
    instance = RescueStationInstance(
        n=user_data["n"],
        costs=user_data["costs"],
        coverage=user_data["coverage"],
    )

    # create a solver and solve the problem
    solver = RescueStationSolver(instance, verbose=False)
    result = solver.solve()

    # return the content (auto converted to json)
    return result
