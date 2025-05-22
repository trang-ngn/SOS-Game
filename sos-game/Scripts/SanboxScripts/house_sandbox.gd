class_name HouseSandbox
extends ObjectSandbox

func _ready():
	pass

func _on_area_entered(area: HouseSandbox) -> void:
	area.collision_count += 1
	
func _on_area_exited(area: HouseSandbox) -> void:
	area.collision_count -= 1
