@tool
class_name House
extends StaticBody2D

var num_stat_cover : int = 0 
var covered : bool = false 
@export var id : int 
	


func is_covered() -> bool :
	if(num_stat_cover > 0) :
		return true
	else :
		return false

#func _process(delta: float) -> void:
	#print(num_stat_cover)

func _ready() -> void:
	initialize()
	
func set_outline() -> void :
	if(num_stat_cover == 0) :
		$Sprite2D.set_instance_shader_parameter("active",false)
	else :
		$Sprite2D.set_instance_shader_parameter("active",true)
		

func initialize() -> void :
	$HouseNumber.visible = false
	set_outline()
	
	
	
