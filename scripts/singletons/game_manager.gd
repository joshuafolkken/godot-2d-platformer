extends Node

const MAIN_SCENE: PackedScene = preload("res://scenes/main.tscn")
const LEVEL_SCENE: PackedScene = preload("res://scenes/level_base.tscn")


func _change_scene(packed_scene: PackedScene) -> void:
	get_tree().change_scene_to_packed(packed_scene)


func load_main_scene() -> void:
	_change_scene(MAIN_SCENE)


func load_level_scene() -> void:
	_change_scene(LEVEL_SCENE)
