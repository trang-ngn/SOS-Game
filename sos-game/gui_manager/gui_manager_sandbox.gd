extends UiManager
class_name UiManagerSandbox

@onready var house_button = $Buttons/HouseButton
@onready var station_button = $Buttons/StationButton
@onready var house_designs = $HouseDesigns
@onready var station_designs = $StationDesigns
@onready var delete_button = $Buttons/DeleteButton
@onready var design_background = $DesignBackground


func _ready() -> void:
	super._ready()
	statistic = $StatisticBar as StatisticSandbox
	house_button.pressed.connect(_on_house_button_pressed)
	station_button.pressed.connect(_on_station_button_pressed)
	delete_button.pressed.connect(_on_delete_button_pressed)

	for button in house_designs.get_children():
		button.pressed.connect(func(): _on_design_button_pressed(button.name))

	for button in station_designs.get_children():
		button.pressed.connect(func(): _on_design_button_pressed(button.name))

	hide_designs()


func hide_designs():
	house_designs.visible = false
	station_designs.visible = false
	design_background.visible = false


func update_statistic_sandbox(num_houses: int, num_stations: int, coverage: int) -> void:
	var sandbox_stat = statistic as StatisticSandbox
	sandbox_stat.update_houses(num_houses)
	sandbox_stat.update_stations(num_stations)
	sandbox_stat.update_coverage(coverage, num_houses)
	done_button.disabled = not (coverage == num_houses)
	all_houses_covered = coverage == num_houses


func _on_house_button_pressed():
	hide_designs()
	house_designs.visible = true
	design_background.visible = true


func _on_station_button_pressed():
	hide_designs()
	station_designs.visible = true
	design_background.visible = true


func _on_design_button_pressed(design_name: String):
	var sandbox = get_tree().get_current_scene()
	sandbox.set_design_by_name(design_name)


func _on_delete_button_pressed():
	var sandbox = get_tree().get_current_scene()

	if sandbox.has_method("switch_mode"):
		sandbox.switch_mode(sandbox.MODE.DELETE)
