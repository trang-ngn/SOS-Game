extends Control

@onready var HouseBox = $HouseBox
@onready var StationBox = $StationBox
@onready var radius: int
@onready var cost: int
@onready var struct_type: BUILDING
@onready var sandbox_scene = preload("res://Scenes/Sandbox/sandbox.tscn")

enum BUILDING{
	HOUSE,
	STATION
}

func _ready() -> void:
	$HouseBox/Sprite2D.visible = false
	$StationBox/Sprite2D.visible = false
	$StationBox/RadiusInput.visible = false
	$StationBox/CostInput.visible = false
	$StationBox/Cost.visible = false
	$StationBox/Radius.visible = false
	HouseBox.button_pressed = false

func _process(delta: float) -> void:
	pass

func _on_station_box_toggled(toggled_on: bool) -> void:
	if toggled_on: 
		HouseBox.button_pressed = false
		$HouseBox/Sprite2D.visible = false
		$StationBox/Sprite2D.visible = true
		$StationBox/RadiusInput.visible = true
		$StationBox/CostInput.visible = true
		$StationBox/Cost.visible = true
		$StationBox/Radius.visible = true
		$Confirm.button_pressed = false


func _on_house_box_toggled(toggled_on: bool) -> void:
	if toggled_on: 
		StationBox.button_pressed = false
		$HouseBox/Sprite2D.visible = true
		$StationBox/Sprite2D.visible = false
		$StationBox/RadiusInput.visible = false
		$StationBox/CostInput.visible = false
		$StationBox/Cost.visible = false
		$StationBox/Radius.visible = false
		$Confirm.button_pressed = false


func verify_input(input) -> bool:
	if input.text.is_valid_int() and input.text.to_int() > 0:
		print("valid input")
		return true
	print("invalid input")
	invalidate_input(input)
	return false


func invalidate_input(input):
	input.text = "Invalid"

func pick_struct():
	var struct: String = ""
	
	if HouseBox.button_pressed == true: # chosen house
		print("chosen house")
		struct = "house"
		pass_house_to_sandbox()
	
	else: # chosen station
		var radius_valid: bool = verify_input($StationBox/CostInput)
		var cost_valid: bool = verify_input($StationBox/RadiusInput)
		print("chosen station")
		struct = "station"
		
		if not (cost_valid and radius_valid): # verify inputs are positive integers
			$Confirm.button_pressed = false
			verify_input($StationBox/RadiusInput)
			verify_input($StationBox/CostInput)
		else: 
			pass_station_to_sandbox($StationBox/RadiusInput.text.to_int(),
			$StationBox/CostInput.text.to_int()) 

func _on_confirm_pressed() -> void:
	pick_struct()

func pass_station_to_sandbox(radius: int, cost: int):
	sandbox_scene.object_type = BUILDING.STATION
	sandbox_scene.current_radius = radius
	sandbox_scene.current_cost = cost

func pass_house_to_sandbox():
	sandbox_scene.object_type = BUILDING.HOUSE
