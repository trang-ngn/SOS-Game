extends TextureButton


func _on_pressed() -> void:
	# TODO change to desired scene
	get_tree().reload_current_scene()
