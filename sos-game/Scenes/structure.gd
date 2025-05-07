class_name Structure
extends Node2D

@export var id : int
@export var built : bool = false
@export var structure_type : type
@export var radius : float
@export var cost : int
@export var covered : bool = false
@onready var choice: String

enum type {
	house,
	station
}

func _ready() -> void:
	$Sprite2D.visible = false
	$Sprite2D2.visible = false

func _on_button_button_up() -> void:
	if(!built) :
		built = true
	else :
		built = false
	pick_structure()

func pick_structure()-> void:
	print("Would you like to build a house or a station? You can type 's' for station and 'h' for house!")
	
	structure_type = type.get(verify_input(choice)) # converts user's choice from a string to the enum type
	
	if structure_type == type.station :
		input_attributes(radius, cost)
		
	else : 
		var covered : bool = false

func change_house_state()->void :
	$Sprite2D.visible = built
	$TextEdit.visible = built
	
func change_station_state()->void :
	$Sprite2D2.visible = built
	$TextEdit.visible = built
	cover_houses(built, radius)

func cover_houses(built : bool, radius : float)->void :
	var button_center = $Button.global_position
	
	for structure in get_tree().get_nodes_in_group("targets"): 
		if structure.global_position.distance_to(button_center) <= radius and structure.built and structure_type == type.house:
			structure.covered = true

func is_built()->bool :
	return built

func input_attributes(radius: float, cost: int) -> void: # temporary values, will take user input
	radius = 10
	cost = 10
	print("Structure built")

func verify_input (input) -> String:
	while input.to_lower() != "s" and input.to_lower() != "h" and input.to_lower() != "house" and input.to_lower() != "station":
		print("invalid input, please try again")
		#input = $LIneEdit.text
	
	if input.to_lower() == "s" or input.to_lower() == "station":
		return "station"
	else: return "house"
