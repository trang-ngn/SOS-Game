class_name HouseSandbox
extends ObjectSandbox

@onready var designs : Array[Sprite2D] = [$Design/Brown,$Design/White,$Design/Green]
var design_index  : int = 0

func _process(delta: float) -> void:
	#debug purpose
	#print(design_index)
	pass

func _init() -> void :
	pass
	
func change_sprite(direction : bool) -> void :
	if direction :
		design_index = (design_index + 1) % designs.size()
	else :
		design_index =  (design_index - 1) % designs.size()
	
	for d in designs :
		d.visible = false
	designs[design_index].visible = true
	
func _on_area_entered(area: ObjectSandbox) -> void:
	area.collision_count += 1
	
func _on_area_exited(area: ObjectSandbox) -> void:
	area.collision_count -= 1
