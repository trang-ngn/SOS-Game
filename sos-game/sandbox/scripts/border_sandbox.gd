extends ObjectSandbox
class_name BorderSandbox


func _on_area_entered(area: ObjectSandbox) -> void:
	area.collision_count += 1


func _on_area_exited(area: ObjectSandbox) -> void:
	area.collision_count -= 1
