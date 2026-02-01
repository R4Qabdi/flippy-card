extends Control

func _ready() -> void:
	#get_tree().change_scene_to_file("res://scenes/tests.tscn")
	pass

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/core/tests.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
