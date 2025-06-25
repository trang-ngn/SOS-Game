extends Area2D
class_name HouseLVL

@onready var designs : Array[Sprite2D] = [$Design/Brown,$Design/White,$Design/Green,$Design/Lightb,$Design/Red]

var id : int
var num_stat_cover : int = 0 
var covered : bool = false 
var design_index : int  = 0

func initialize(pos : Vector2, design : int) -> void:
	self.position = pos
	design_index = design
	set_design()
	set_outline()

func set_id() :
	id = get_index()

func is_covered() -> bool :
	if(num_stat_cover > 0) :
		return true
	else :
		return false

func set_design() -> void :
	for d in designs:
		d.visible = false
	designs[design_index].visible = true

func set_outline() -> void :
	#outline set
	if(num_stat_cover == 0) :
		designs[design_index].set_instance_shader_parameter("active",false)
	else :
		designs[design_index].set_instance_shader_parameter("active",true)
