extends ObjectSandbox
class_name StationSandbox

@onready var designs: Array[Sprite2D] = [
	$Design/Station1,
	$Design/Station2,
	$Design/Station3
]

@onready var plot_button: Button = $Plot

var houses : Array[HouseSandbox]
var id : int = 0
var station_number: int = 0
var station_cost: int = 0
var radius_value: float = 10
var design_index: int = 0

var plot_pressed: bool = false

#debug purposes
var time_passed := 0.0

signal edit_station(station: StationSandbox)


#func _process(delta: float) -> void:
	#time_passed += delta
#
	#if time_passed >= 2.5:
		#print(self.name + str(houses))
		#time_passed = 0.0


func _ready() -> void:
	update_design_visibility()


func update_design_visibility() -> void:
	for i in range(designs.size()):
		designs[i].visible = (i == design_index)


func set_collision_indicator(value: bool) -> void:
	designs[design_index].set_instance_shader_parameter("use_red",value)


# Kollisionsbehandlung
func _on_area_entered(area: ObjectSandbox) -> void:
	area.collision_count += 1


func _on_area_exited(area: ObjectSandbox) -> void:
	area.collision_count -= 1


# Diese Methode wird vom Sandbox.gd-Script aufgerufen
func set_design_index(index: int) -> void:
	design_index = index
	update_design_visibility()


#func _on_button_mouse_entered() -> void:
	#$Radius.visible = true
#
#
#func _on_button_mouse_exited() -> void:
	#$Radius.visisble = false


func set_station_number(number: int) -> void:
	station_number = number


func set_cost(cost: float) -> void:
	var integer: int = 0
	var fl: float = cost

	if cost == int(cost):
		integer = int(cost)
		plot_button.text = str(station_number) + "\n" + str(integer) + " M€"
	else:
		plot_button.text = str(station_number) + "\n" + str(fl) + " M€"

	station_cost = cost


func set_radius(value: float) -> void:
	#radius_value = value
	#var shape := $Radius/RadiusSize.shape as CircleShape2D
#
	#if shape:
		#shape.radius = value
#
	#$Radius/RadiusVisual.queue_redraw()

	radius_value = value
#
	var shape_node = $Radius/RadiusSize
	var original_shape = shape_node.shape as CircleShape2D

	# Make a unique copy of the shape to avoid shared instances
	var new_shape = original_shape.duplicate() as CircleShape2D
	new_shape.radius = value

	shape_node.shape = new_shape

	$Radius/RadiusVisual.queue_redraw()


func get_current_radius() -> float:
	return radius_value


func get_houses() -> Array[HouseSandbox]:
	var bodies = $Radius.get_overlapping_bodies()
	var new_houses: Array[HouseSandbox]
	for bd in bodies:
		var house = bd.get_parent()

		if house is HouseSandbox:
			new_houses.append(house)

	return new_houses


func cover_houses() -> void:
	houses.clear()
	houses = get_houses()

	for h in houses:
		h.num_stat_cover += 1


#func show_radius() -> void:
	#set_radius(get_current_radius())
	#$Radius.visible = true
	#$Radius/RadiusSize.visible = true
	#$Radius/RadiusVisual.visible = true
#
#
#func hide_radius() -> void:
	#set_radius(get_current_radius())
	#$Radius.visible = false
	#$Radius/RadiusSize.visible = false
	#$Radius/RadiusVisual.visible = false


func toggle_radius_visibility(value: bool):
	#set_radius(get_current_radius())
	#$Radius.visible = value
	#$Radius/RadiusSize.visible = value
	$Radius/RadiusVisual.visible = value


func _on_plot_pressed() -> void:
	#var sandbox = get_tree().get_current_scene()
##	sandbox.unedit_existing_station()
	#if plot_pressed == false:
		#sandbox.edit_existing_station(self)
		##plot_pressed = true

	emit_signal("edit_station",self)
	#else:


func _on_plot_mouse_entered() -> void:
	#var sandbox = get_tree().get_current_scene()
#
	#if sandbox.editing_station != self:
	toggle_radius_visibility(true)


func _on_plot_mouse_exited() -> void:
	#var sandbox = get_tree().get_current_scene()

	#if sandbox.editing_station != self:

	if plot_pressed:
		toggle_radius_visibility(true)
	else:
		toggle_radius_visibility(false)


func _on_radius_body_entered(body: Node2D) -> void:
	#print(name + "SOMEONE ENTERED ME")
	if body.get_parent() is HouseSandbox:
		check_coverage_from_sandbox()


func _on_radius_body_exited(body: Node2D) -> void:
	if body.get_parent() is HouseSandbox:
		check_coverage_from_sandbox()


func check_coverage_from_sandbox():
	var sandbox = get_tree().get_current_scene()

	if sandbox and sandbox.has_method("check_coverage"):
		sandbox.check_coverage()
