extends Node2D

@export var blueprint: Sprite2D  # The blueprint sprite
@export var tilemap: TileMap  # The TileMap node

const HOUSE = preload("res://Scenes/Objects/house.tscn")

# Continuously check cell under the mouse
func _process(delta: float) -> void:
	checkCell()

func checkCell() -> void:
	# Step 1: Get the mouse position in the viewport
	var mouse_tile = get_global_mouse_position()
	
	# Step 2: Convert mouse position to the TileMap's grid position
	var map_pos = tilemap.local_to_map(mouse_tile)
	
	# Step 3: Convert the grid position back to a local coordinate
	var coordinate = tilemap.map_to_local(map_pos)
	
	# Step 4: Set the blueprint's position to the calculated global coordinate
	blueprint.position = to_global(coordinate)

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT :
			place_object()
		

func place_object() -> void :
	print("clicked")
	var object : StaticBody2D = HOUSE.instantiate()
	object.global_position = blueprint.global_position
	add_child(object)
	
	
	
