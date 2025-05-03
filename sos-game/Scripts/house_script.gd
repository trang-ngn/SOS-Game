class_name House
extends StaticBody2D

var covered : bool = false 
@export var id : int 

func is_covered() -> bool :
	return covered

func _ready() -> void:
	$HouseNumber.visible = false
	set_outline(false)
	
func set_outline(value : bool) -> void :
	$Sprite2D.set_instance_shader_parameter("active",value)
