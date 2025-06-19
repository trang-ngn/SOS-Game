extends ObjectSandbox
class_name StationSandbox

# Liste der Station-Design-Sprites – passe die Pfade ggf. an!
@onready var designs : Array[Sprite2D] = [
	$Design/Station1,
	$Design/Station2,
	$Design/Station3
]

@onready var plot_button: Button = $Plot

var station_number: int = 0
var station_cost: int = 0
var radius_value: float = 10
var design_index: int = 0

var plot_pressed: bool = false

func _ready() -> void:
	update_design_visibility()

func update_design_visibility() -> void:
	for i in range(designs.size()):
		designs[i].visible = (i == design_index)

# Kollisionsbehandlung
func _on_area_entered(area: ObjectSandbox) -> void:
	area.collision_count += 1

func _on_area_exited(area: ObjectSandbox) -> void:
	area.collision_count -= 1

# Diese Methode wird vom Sandbox.gd-Script aufgerufen
func set_design_index(index: int) -> void:
	design_index = index
	update_design_visibility()

func _on_button_mouse_entered() -> void:
	$Radius.visible = true

func _on_button_mouse_exited() -> void:
	$Radius.visisble = false

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


func set_radius(value: float) -> void:
	radius_value = value
	var shape := $Radius/RadiusSize.shape as CircleShape2D
	if shape:
		shape.radius = value
	$Radius/RadiusVisual.queue_redraw()

func get_current_radius() -> float:
	return radius_value

func _on_plot_pressed() -> void:
	var sandbox = get_tree().get_current_scene()
#	sandbox.unedit_existing_station()
	if plot_pressed == false:	
		sandbox.edit_existing_station(self)
		#plot_pressed = true
	#else:
