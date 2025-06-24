extends ObjectSandbox
class_name HouseSandbox

# List of the house design sprites
@onready var designs : Array[Sprite2D] = [$Design/Brown, $Design/White, $Design/Green, $Design/Lightb, $Design/Red]
var design_index : int = 0

var num_stat_cover : int = 0 
var covered : bool = false 
@export var id : int 

func initialize_in_level(pos : Vector2, index :int, design : int) -> void:
	self.position = pos
	for d in designs:
		d.visible = false
	designs[design].visible = true
	id = index

func _ready() -> void:
	for i in range(designs.size()):
		designs[i].visible = (i == design_index)

func is_covered() -> bool :
	if(num_stat_cover > 0) :
		return true
	else :
		return false

func set_outline() -> void :
	if(num_stat_cover == 0) :
		$Sprite2D.set_instance_shader_parameter("active",false)
	else :
		$Sprite2D.set_instance_shader_parameter("active",true)
		

func set_id() -> void :
	id = get_index()


func initialize() -> void :
	#sprite.texture = design
	set_outline()

func change_sprite(direction : bool) -> void:
	if direction:
		design_index = (design_index + 1) % designs.size()
	else:
		design_index = (design_index - 1 + designs.size()) % designs.size()
	
	for d in designs:
		d.visible = false
	designs[design_index].visible = true

func _on_area_entered(area: ObjectSandbox) -> void:
	area.collision_count += 1

func _on_area_exited(area: ObjectSandbox) -> void:
	area.collision_count -= 1
	
func set_design_index(index: int) -> void:
	design_index = index
	for i in range(designs.size()):
		designs[i].visible = (i == design_index)
