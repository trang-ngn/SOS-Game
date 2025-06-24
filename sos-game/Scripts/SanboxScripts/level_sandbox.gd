extends Node2D

@onready var houses = $Houses
@onready var station = $Stations
@onready var house_scene = preload("res://Scenes/Sandbox/house_sandbox.tscn")
@onready var station_scene = preload("res://Scenes/Sandbox/station_sandbox.tscn")

func _on_test_pressed() -> void:
	initialize_buildings()

func initialize_buildings() -> void :
	for h in Buildings.houses_data :
		print(h)
		
	for h in Buildings.houses_data :
		var new_house : HouseSandbox  = house_scene.instantiate()
		houses.add_child(new_house)
		new_house.initialize_in_level(h.position,h.id,h.design)
	
	for s in Buildings.stations_data :
		print(s)
