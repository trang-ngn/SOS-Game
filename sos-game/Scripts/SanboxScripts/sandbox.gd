extends Node2D

@onready var house = preload("res://Scenes/Sandbox/house_sandbox.tscn")
@onready var station = preload("res://Scenes/Sandbox/station_sandbox.tscn")
@onready var houses = $Houses
@onready var stations = $Stations
@onready var default_object : DefaultObject = $ConstantObject/DefaultObject
@onready var object_deleter : ObjectsDeleter = $ConstantObject/ObjectDeleter
@onready var tilemap : TileMap = $TileMap

var offset : Vector2 = Vector2(0,0)
var current_object : ObjectSandbox
var current_mode : MODE 
var current_building : BUILDING

enum MODE{
	DEFAULT,
	BUILD,
	DELETE
}

enum BUILDING{
	HOUSE,
	STATION
}

func _ready() -> void:
	switch_mode(MODE.DEFAULT)
	current_building = BUILDING.HOUSE
	
	
func _process(delta: float) -> void:
	check_area()
	#debug purpose
	#print(houses.get_child_count())
	#print(stations.get_child_count())

func check_area() -> void :
	var mouse_tile = get_global_mouse_position()
	var map_pos = tilemap.local_to_map(mouse_tile)
	var coordinate = tilemap.map_to_local(map_pos)
	current_object.position = to_global(coordinate + offset).snapped(Vector2.ONE)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
		if current_mode == MODE.DEFAULT :
			switch_mode(MODE.BUILD)
			set_building()
			
		elif current_mode == MODE.BUILD :
			place_object()
		
		elif current_mode == MODE.DELETE :
			delete_object()
		
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.is_released():
		if current_mode == MODE.DEFAULT :
			switch_mode(MODE.DELETE)
			
		elif current_mode == MODE.DELETE :
			switch_mode(MODE.DEFAULT)
			
		elif current_mode == MODE.BUILD :
			#debug purpose
			#print("switch")
			switch_building() 
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP and event.is_released():
		if current_mode == MODE.BUILD :
			current_object.change_sprite(true)
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.is_released():
		if current_mode == MODE.BUILD :
			current_object.change_sprite(false)
	

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
	current_mode = MODE.DEFAULT
	default_object.switch_default(true)
	object_deleter.switch_deleter(false)
	current_object = default_object
	set_offset(8,8)

func build_mode() -> void :
	default_object.switch_default(false)
	object_deleter.switch_deleter(false)
	#current_object will be changed in other function according to the building type
	current_mode = MODE.BUILD
	

func delete_mode() -> void :
	default_object.switch_default(false)
	object_deleter.switch_deleter(true)
	current_object = object_deleter
	current_mode = MODE.DELETE
	set_offset(0,0)
#===================================================================================================

func switch_building() -> void :
	if current_building == BUILDING.HOUSE and current_object is HouseSandbox:
		current_object.queue_free()
		current_building = BUILDING.STATION
		change_to_station()
	elif current_building == BUILDING.STATION and current_object is StationSandbox :
		current_object.queue_free()
		current_building = BUILDING.HOUSE
		change_to_house()
	else :
		print("HOW DO WE GET HERE???")
		
func set_building() -> void :
	if current_building == BUILDING.HOUSE :
		change_to_house()
	elif current_building == BUILDING.STATION :
		change_to_station()
	else :
		print("How do I live without the ones I love? Time still turns the pages of the book it's burned")

func change_to_station() -> void :
	var new_station = station.instantiate()
	stations.add_child(new_station)
	current_object = new_station
	set_offset(16, 16)
	

func change_to_house() -> void :
	var new_house = house.instantiate()
	houses.add_child(new_house)
	current_object = new_house
	set_offset(8, 8)
	
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
