class_name Level
extends Node2D

var solution : Array[bool] = [false,true]
var picked : Array[bool] = []

@onready var station1 : RescueStation = $Stations/S0
@onready var station2 : RescueStation = $Stations/S1
@onready var stations : Array[RescueStation] = [station1, station2]

@onready var house1 : House = $Houses/H0
@onready var house2 : House = $Houses/H1

#make sure the houses is in order
@onready var houses : Array[House] = [house1,house2]

func houses_covered()->bool : #check if all houses is covered
	for house in houses :
		if(!house.covered) :
			return false
	
	return true
	
func get_solution()-> Array[bool] :
	var result : Array[bool]
	
	for station in stations :
		result.append(station.is_built())
		
	return result 
	
func _process(delta: float) -> void:
	if(houses_covered()) :
		print("Good Job")
		picked = get_solution()
		print(picked)
