# SOS-Game

## Introduction
🔥 This project was introduced by the Algorithmik Institute of TU Braunschweig (Softwareentwicklung 2025).

💠 The goal of the game is to find the optimal solution for building rescue stations, ensuring that the budget remains minimal while guaranteeing that citizens can reach a rescue station.

<img width="721" height="405" alt="image" src="https://github.com/user-attachments/assets/b116104c-b196-4ae3-b53a-7aa9a43dd156" />

## Setup Git with Godot

### Clone the repo

- If you already cloned, try `git pull`, if there are some errors, install vpn and try again.
- Open terminal:

```sh
git clone git@git.rz.tu-bs.de:isf/sep/sep2025/ibr_alg_g1/code.git
```

## Setup Server

Make sure that you installed Python (if not, go to python.org and install it). Check by:

```sh
python --version
pip --version
```

### 1. Install dependencies for server

```sh
cd backend/
pip install -r requirements.txt
```

### 2. Start the development server

```sh
# root of the repo
cd code/
PYTHONPATH=. uvicorn backend.api:app --reload

# or on Linus/MacOs
cd backend/
fastapi dev
```

- The server is running at: [http://127.0.0.1:8000](http://127.0.0.1:8000)
- POST requests should be sent to: [http://127.0.0.1:8000/solve](http://127.0.0.1:8000/solve)

### 3. Get solution on Godot by sending request to server

In `/sos-game/scripts/UsageExample.gd`, you will see an example of how to create an instance and how to get the solution from your created instance.

```python
extends Node

func _ready():
# Create an instance with custom-type Instance
    var i: Instance = Instance.new()
    i.n = 3
    i.costs = [1, 2, 3, 4]
    i.coverage = [[0], [1], [2], [0, 1, 2]]

# Get solution
    var solution: Solution = await Resquest.get_solution(self, i)
    ...
```

<i>Remember that, every time you want to call the solution on Godot (client), you need to start the server!</i>

(It is like if you want to get food from your sleeping mom, you need to awake her first)

## How to export the game

### MacOS

Editor -> Manage export templates -> Dowload and install

Project -> export -> Add -> MacOS -> Bundle Indentifier =sos-game

Project -> Project setting ->(search "S3") Rendering -> Textures -> ON (Import S§TC BPTC) -> save and restart

Export window -> export project
