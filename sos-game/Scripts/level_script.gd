class_name Level
extends Node2D

var solution : Array[bool] = [false, false, true, true, true, true, false]
var picked : Array[bool] = []

#make sure the houses and station are in order
@export var stations : Array[RescueStation] 
@export var houses : Array[House] 

func houses_covered()->bool : #check if all houses is covered
	for house in houses :
		if(!house.is_covered()) :
			return false
	
	return true
	
func update_picked() :
	var result : Array[bool]
	
	for station in stations :
		result.append(station.is_built())
		
	picked = result 
	
func _process(delta: float) -> void:
	pass


func _on_button_button_up() -> void:
	update_picked()
	if(houses_covered()) :
		print("Optimal solution : ")
		print_something(solution)
		print("Your solution : ")
		print_something(picked)
		
		
	else :
		print("Not all house is covered\n")

#cannot think of better name atm my bad
func print_something(array : Array[bool]) ->void :
	print("====================")
	var i : int = 0
	for value in array :
		print(str(i) + " : " + str(value))
		i += 1
	print("====================\n")


func _on_done_button_pressed() -> void:
	$PopupPanel.popup_centered()
	var label: Label = $PopupPanel/ResultDialog/Panel/ResultLabel
	update_picked()
	label.text = "Optimal Solution:" + "\n" + str(solution)+ "\n"
	label.text += "Your Solution:" + "\n" + str(picked) + "\n"
