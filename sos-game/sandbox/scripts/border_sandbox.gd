extends ObjectSandbox
class_name BorderSandbox


func _on_area_entered(area: Area2D) -> void:
	area.collision_count += 1


func _on_area_exited(area: Area2D) -> void:
	area.collision_count -= 1
