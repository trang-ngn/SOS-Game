extends LevelSBObject
class_name StationLVL

@onready var plot = $Plot
@onready var radius :CollisionShape2D = $Radius/RadiusSize
@onready var designs : Array[Sprite2D] = [
	$Design/Station1,
	$Design/Station2,
	$Design/Station3
]

var id : int
var cost : int 
var design_index : int
var houses : Array[HouseLVL] 
var radius_size : float
var built : bool = false
var optimal : bool = false

func initialize(pos : Vector2, design : int, cost : int, rad : float) -> void :
	self.position = pos
	self.cost = cost
	radius_size = rad
	design_index = design
	set_design()
	set_plot()
	set_radius()
	
	
func set_id() :
	id = get_index()

func set_design() -> void :
	for d in designs:
		d.visible = false
	designs[design_index].visible = true
	designs[design_index].set_instance_shader_parameter("progress",1.0)

func set_plot() -> void :
	plot.text = str(id) + "\n" +str(cost) + "M €"

func set_radius() -> void :
	var original_shape = radius.shape
	var shape_copy = original_shape.duplicate()
	shape_copy.radius = radius_size
	radius.shape = shape_copy
	
	$Radius/RadiusVisual.queue_redraw()


func change_state() -> void :
	play_animation()
	cover_houses(built)

func cover_houses(value: bool)->void:
	for h in houses:
		if (value == true):
			h.num_stat_cover += 1
			h.set_outline()
		elif(value == false && h.num_stat_cover == 0):
			h.num_stat_cover = 0
			h.set_outline()
		else:
			h.num_stat_cover -= 1
			h.set_outline()

func play_animation()-> void :
	
	designs[design_index].set_instance_shader_parameter("wiggle_strength", 2.4)
	var total_time :float = 0.4
	var interval : float = 0.05
	var elapsed : float = 0.0
	var new_progress : float = 0.0
	
	while elapsed <= total_time:
		var raw_progress = elapsed / total_time
		var shader_progress = raw_progress if !built else (1.0 - raw_progress)
		designs[design_index].set_instance_shader_parameter("progress", shader_progress)
		await get_tree().create_timer(interval).timeout
		elapsed += interval
		
	# Disable wiggle after reveal
	designs[design_index].set_instance_shader_parameter("wiggle_strength", 0.0)

func get_covered_houses() -> Array:
	var bodies: Array = $Radius.get_overlapping_bodies()
	var index_array: Array = []

	for body in bodies:
		if body is HouseLVL:
			index_array.append(body.id)
	#print("index_array: ", index_array)
	return index_array

func is_built()->bool:
	return built

func _on_plot_button_up() -> void:
	if (!built):
		built = true
	else:
		built = false
	
	change_state()

func _on_plot_mouse_entered() -> void:
	$Radius/RadiusSize.visible = true
	$Radius/RadiusVisual.visible = true


func _on_plot_mouse_exited() -> void:
	$Radius/RadiusSize.visible = false
	$Radius/RadiusVisual.visible = false


func _on_radius_area_entered(area: HouseLVL) -> void:
	houses.append(area)
