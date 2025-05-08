class_name RescueStation
extends Node2D

var houses : Array[House]
@export var cost : int
@export var id : int
var built : bool = false

func _ready() -> void:
	initialize()
	
func _on_button_button_up() -> void:
	if(!built) :
		built = true
	else :
		built = false
	change_state()
	
func change_state()->void :
	$Sprite2D.visible = built
	#$TextEdit.visible = built
	cover_houses(built)

func cover_houses(value : bool)->void :
	for h in houses :
		if(value == true)  :
			h.num_stat_cover += 1
			h.set_outline()
		elif (value == false && h.num_stat_cover == 0) :
			h.num_stat_cover = 0
			h.set_outline()
		else :
			h.num_stat_cover -= 1
			h.set_outline()
		
		


func is_built()->bool :
	return built
	
func initialize() -> void :
	$Sprite2D.visible = false
	$Plot.text = str(id) + " : " +str(cost)
	$StationNumber.visible = false
	$StationNumber.editable =false
	$Radius/RadiusSize.visible = false
	

func _on_area_2d_body_entered(body: House) -> void:
	houses.append(body)
	
func _on_button_mouse_entered() -> void:
	$Radius/RadiusSize.visible = true

func _on_button_mouse_exited() -> void:
	$Radius/RadiusSize.visible = false
