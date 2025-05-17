@tool
class_name House
extends StaticBody2D



var num_stat_cover : int = 0 
var covered : bool = false 
var id : int 

@onready var sprite : Sprite2D = $Sprite2D

#@export var design : Texture2D :
	#set(value) :
		#design = value
		#if sprite :
			#sprite.texture = design
	


func is_covered() -> bool :
	if(num_stat_cover > 0) :
		return true
	else :
		return false

#func _process(delta: float) -> void:
	#print(num_stat_cover)

func _ready() -> void:
	initialize()
	id = get_index()
	
func set_outline() -> void :
	if(num_stat_cover == 0) :
		$Sprite2D.set_instance_shader_parameter("active",false)
	else :
		$Sprite2D.set_instance_shader_parameter("active",true)
		

func initialize() -> void :
	#sprite.texture = design
	$HouseNumber.visible = false
	set_outline()
	
	
	
