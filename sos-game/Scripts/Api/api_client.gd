class_name Resquest extends Node

"""
This is a reusable script for sending HTTP requests and receiving the solution for custom instances.
"""

var http: HTTPRequest = HTTPRequest.new()

const TIMEOUT_SEC: float = 5.0 # timelimit for server response, if longer -> connection is broken

var response_data: Dictionary = {}
var request_done: bool = false
var server_error: String = ""

func _init(): # automatically run when this node is created
	add_child(http) # add HTTPRequest Node, placing in the scene tree
	
	# server responds -> trigger signale -> cause callback fucntion to run, which will run when http request finish
	http.request_completed.connect(_on_request_completed) 

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	request_done = true
	
	var text: String = body.get_string_from_utf8()
	
	if result != HTTPRequest.RESULT_SUCCESS:
		server_error = "Request failed. No response from server. Make sure that server is started!"
	elif response_code == 200:
		response_data = JSON.parse_string(text) # parse string to 
	elif response_code == 422:
		server_error = "Client error: " + text
	elif response_code == 500: 
		server_error = "Server error: " + text 
	else:
		server_error = "Unknown error: HHTP %d - %s" % [response_code, text]

func _http_post(url: String, data: Dictionary = {}, headers: Array[String] = []) -> Array:
	request_done = false # reset the flags

	var request_data = JSON.stringify(data)
		
	# create request and send post request to the given url with given header and request_data
	var request_error = http.request(url, headers, HTTPClient.METHOD_POST, request_data) 
	if request_error != OK:
		return [{"error": "Error making POST request!"}, request_error]
		
	# Waiting for request_completed
	var timer: float = 0.0
	while not request_done and timer < TIMEOUT_SEC:
		await get_tree().process_frame # Wait until the next frame (screen update) before continuing next line
		timer += get_process_delta_time()
	
	if not request_done:
		return [{"error": "Timeout. Server not responding."}, 1]
	elif server_error != "":
		return [{"error": server_error}, 2]	
	return [response_data, OK]


## Getting a solution from server for the given instance. [br]
## 
## [b]Args:[/b][br]
##		[param node]: The node to add the request to. This node will be deleted after the request is done. [br]
##		[param instance]: The instance to solve. [br]
##
## [b]Returns:[/b][br]
##		The solution for the given instance or null if the request fails.
static func get_solution(node: Node, instance: Instance) -> Solution:
	
	var req = Resquest.new() # create this class/node
	node.add_child(req) # add request node 
	
	var url: String = "http://127.0.0.1:8000/solve" # path is defined in api_server
	var headers: Array[String] = ["Content-Type: application/json"]
	
	# using "await" to pause execution until an asynchronous operation is completed—without freezing the game.
	var get_result = await req._http_post(url, instance.to_dict(), headers)
	
	# Marks the node (req) for deletion at the end of the frame. Avoids deleting during signal/callback execution.
	req.queue_free() 
	
	if get_result[1] != OK:
		print(get_result[0]["error"])
		return null

	var solution = Solution.new()
	
	solution.instance = instance
	solution.selected = get_result[0]["selected"]
	solution.cost = get_result[0]["cost"]
	solution.bound = get_result[0]["bound"]
	solution.is_optimal = get_result[0]["is_optimal"]
	solution.time = get_result[0]["time"]
	
	return solution
