class_name HouseSandbox
extends ObjectSandbox

@onready var designs : Array[Sprite2D] = [$Design/Brown,$Design/White,$Design/Green]


func _init() -> void :
	pass
	

func _on_area_entered(area: ObjectSandbox) -> void:
	area.collision_count += 1
	
func _on_area_exited(area: ObjectSandbox) -> void:
	area.collision_count -= 1
