extends Node2D

@onready var house_scene = preload("res://Scenes/Objects/house_sandbox.tscn")
@onready var houses = $Houses
@onready var default_object : ObjectSandbox = $PreviewObjects/DefaultObject
@onready var object_deleter : ObjectSandbox = $PreviewObjects/ObjectDeleter
@onready var tilemap : TileMap = $TileMap

var current_grid_position
var current_object : ObjectSandbox
var is_building = false
var is_deleting = false
var object_to_delete : ObjectSandbox = null

func _ready() -> void:
	current_object = default_object
	
func _process(delta: float) -> void:
	check_area()
	print(houses.get_child_count())

func check_area() -> void :
	var mouse_tile = get_global_mouse_position()
	var map_pos = tilemap.local_to_map(mouse_tile)
	var coordinate = tilemap.map_to_local(map_pos)
	current_object.position = to_global(coordinate)
	current_grid_position = to_global(coordinate)
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
		is_deleting = false
		if !is_building :
			change_to_object()
			is_building = true
		else :
			place_object()

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.is_released():
		is_building = false
		if !is_deleting :
			current_object = object_deleter
			is_deleting = true
		elif object_to_delete == null :
			pass
		else :
			object_to_delete.queue_free()
			
func change_to_object() -> void :
	default_object.visible = false
	var new_house = house_scene.instantiate()
	houses.add_child(new_house)
	current_object = new_house
	
func place_object() -> void :
	if current_object.is_colliding() :
		print("This object is overlapping with another object")
	else :
		current_object.position = current_grid_position
		current_object = default_object
		current_object.visible = true
		is_building = false

func _on_object_deleter_area_entered(area: HouseSandbox) -> void:
	if area is HouseSandbox :
		object_to_delete = area
	print(object_to_delete)

func _on_object_deleter_area_exited(area: HouseSandbox) -> void:
	object_to_delete = null
	print(object_to_delete)
