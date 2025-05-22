extends Node2D

@onready var house_scene = preload("res://Scenes/Sandbox/house_sandbox.tscn")
@onready var houses = $Houses
@onready var default_object : DefaultObject = $PreviewObjects/DefaultObject
@onready var object_deleter : ObjectsDeleter = $PreviewObjects/ObjectDeleter
@onready var tilemap : TileMap = $TileMap

var offset : Vector2 = Vector2(0,0)
var current_object : ObjectSandbox
var is_building 
var is_deleting 

enum MODE{
	DEFAULT,
	BUILD,
	DELETE
}

#not used yet
enum BUILDING{
	HOUSE,
	STATION
}

func _ready() -> void:
	switch_mode(MODE.DEFAULT)
	
	
func _process(delta: float) -> void:
	check_area()
	#debug purpose
	#print(houses.get_child_count())

func check_area() -> void :
	var mouse_tile = get_global_mouse_position()
	var map_pos = tilemap.local_to_map(mouse_tile)
	var coordinate = tilemap.map_to_local(map_pos)
	current_object.position = to_global(coordinate + offset).snapped(Vector2.ONE)
	
	
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
		if !is_building and !is_deleting :
			switch_mode(MODE.BUILD)
			change_to_house()
		
		elif is_building :
			place_object()
		
		elif is_deleting :
			delete_object()
		
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.is_released():
		if !is_deleting and current_object == default_object:
			switch_mode(MODE.DELETE)
		elif is_deleting :
			switch_mode(MODE.DEFAULT)
	

#this function can be splited in to more function but for now this works!
func switch_mode(mode : MODE ) -> void :
	if mode == MODE.DEFAULT :
		default_mode()
	elif mode == MODE.BUILD :
		build_mode()
	elif  mode == MODE.DELETE :
		delete_mode()
	else :
		print("HOW DO WE GET HERE????????")

#these three functions set the parameters according to the mode
#why don't i just call this function to switch mode? idk i just realized that
#switch_mode sound cooler though
func default_mode() -> void :
	default_object.switch_default(true)
	object_deleter.switch_deleter(false)
	current_object = default_object
	is_building = false
	is_deleting = false
	set_offset(0,0)

func build_mode() -> void :
	default_object.switch_default(false)
	object_deleter.switch_deleter(false)
	#current_object will be changed in other function according to the building type
	is_building = true
	is_deleting = false
	set_offset(-8, 8)

func delete_mode() -> void :
	default_object.switch_default(false)
	object_deleter.switch_deleter(true)
	current_object = object_deleter
	is_building = false
	is_deleting = true
	set_offset(0,0)

func change_to_house() -> void :
	var new_house = house_scene.instantiate()
	houses.add_child(new_house)
	current_object = new_house
	
func place_object() -> void :
	if current_object.is_colliding() :
		print("This object is overlapping with another object")
	else :
		switch_mode(MODE.DEFAULT)

func delete_object() -> void :
	if object_deleter.collided_object == null :
		print("hover over to an object")
	else :
		object_deleter.collided_object.queue_free()

#this function should be expand further in the future
#it should set off set for each type of building
#for now only for house
func set_offset(x :float, y : float) -> void :
	offset = Vector2(x,y)


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/start.tscn")
