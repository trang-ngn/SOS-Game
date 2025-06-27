extends Area2D
class_name HouseLVL

@onready var designs: Array[Sprite2D] = [$Designs/Brown,$Designs/White,$Designs/Green,$Designs/Lightb,$Designs/Red]

var num_covering_stations: int = 0
var is_covered: bool = false
var id: int 
#var id : int
#var num_stat_cover : int = 0 
#var covered : bool = false 
var design_index : int  = 0


func initialize(pos : Vector2, design : int) -> void:
	self.position = pos
	design_index = design
	set_design()
	_set_outline(false)


func set_id():
	id = get_index()


#func is_covered() -> bool:
	#if (num_stat_cover > 0):
		#return true

	#else:
		#return false


func set_design() -> void:
	for d in designs:
		d.visible = false

	designs[design_index].visible = true


func _set_outline(value: bool) -> void:
	designs[design_index].set_instance_shader_parameter("active", value)


#func set_outline() -> void:
	##outline set
	#if (num_stat_cover == 0):
		#designs[design_index].set_instance_shader_parameter("active",false)

	#else:
		#designs[design_index].set_instance_shader_parameter("active",true)


func update_num_covering_stations(value: int) -> void:
	num_covering_stations = max(0, num_covering_stations + value)
	is_covered = num_covering_stations > 0
	_set_outline(is_covered)
