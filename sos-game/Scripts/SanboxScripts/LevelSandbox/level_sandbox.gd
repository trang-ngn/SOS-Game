extends Node2D

@onready var houses = $Houses
@onready var stations = $Stations
@onready var house_scene = preload("res://Scenes/Sandbox/LevelSandbox/house_lvl_sandbox.tscn")
@onready var station_scene = preload("res://Scenes/Sandbox/LevelSandbox/station_lvl_sandbox.tscn")


func _ready() -> void:
	initialize_buildings()

func initialize_buildings() -> void :
	for data in Buildings.houses_data :
		var new_house : HouseLVL  = house_scene.instantiate() 
		houses.add_child(new_house)
		new_house.set_id()
		new_house.initialize(data.position,data.design)
	
	for data in Buildings.stations_data :
		var new_station : StationLVL = station_scene.instantiate()
		stations.add_child(new_station)
		new_station.set_id()
		new_station.initialize(data.position,data.design,data.cost,data.radius)
	
	#
	##debug purpose
	#for s in Buildings.stations_data :
		#print(s)
	#
	##debug purpose
	#for s in stations.get_children() :
		#if s is StationLVL :
			#print(s.id)

#func _process(delta: float) -> void:
	#for s in stations.get_children() :
		#if s is StationLVL :
			#print(str(s.id) + " " + str(s.radius_size)) 
